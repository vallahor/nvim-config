local b = vim.b
local escape = vim.fn.escape
local getpos = vim.fn.getpos
local getregion = vim.fn.getregion
local nvim_get_mode = vim.api.nvim_get_mode
local nvim_win_get_cursor = vim.api.nvim_win_get_cursor
local nvim_get_current_line = vim.api.nvim_get_current_line
local nvim_get_current_win = vim.api.nvim_get_current_win
local nvim_get_current_buf = vim.api.nvim_get_current_buf
local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_win_get_buf = vim.api.nvim_win_get_buf
local nvim_buf_get_lines = vim.api.nvim_buf_get_lines
local matchadd = vim.fn.matchadd
local matchaddpos = vim.fn.matchaddpos
local matchdelete = vim.fn.matchdelete
local line = vim.fn.line

local string_sub = string.sub
local string_gsub = string.gsub
local table_concat = table.concat

vim.api.nvim_set_hl(0, "Cursorword", {
  sp = "none",
  fg = "none",
  bg = "#2D2829",
})

local disabled_bufs = {}
local last_pattern = {}
local matches = {}

local byte = string.byte

local function is_word_byte(_b)
  return _b == 95 -- _
    or (_b >= 48 and _b <= 57) -- 0-9
    or (_b >= 65 and _b <= 90) -- A-Z
    or (_b >= 97 and _b <= 122) -- a-z
end

local function get_word(_line, col, rb)
  local s = col + 1
  local e = col + 1
  local n = #_line
  -- expand left
  local lb = byte(_line, s - 1)
  while s > 1 and lb and is_word_byte(lb) do
    s = s - 1
    lb = byte(_line, s - 1)
  end
  -- expand right
  while e <= n and rb and is_word_byte(rb) do
    e = e + 1
    rb = byte(_line, e)
  end
  return string_sub(_line, s, e - 1)
end

local function clear(win)
  win = win or nvim_get_current_win()
  local m = matches[win]
  if m then
    local ids = m.ids
    local n = #ids
    for i = 1, n do
      pcall(matchdelete, ids[i], win)
    end
    matches[win] = nil
  end
  last_pattern[win] = nil
end

local function set_match(win, pattern, priority)
  if last_pattern[win] == pattern then
    return
  end
  clear(win)
  last_pattern[win] = pattern
  matches[win] = {
    ids = { matchadd("Cursorword", pattern, priority, -1, { window = win }) },
  }
end

local function set_match_visual(win, lines)
  local n = #lines
  local escaped = {}
  for i = 1, n do
    escaped[i] = string_gsub(lines[i], [[\]], [[\\]])
  end

  local pattern = table_concat(escaped, [[\n]])
  if last_pattern[win] == pattern then
    return
  end

  clear(win)
  last_pattern[win] = pattern

  local buf = nvim_win_get_buf(win)
  local top = line("w0")
  local bot = line("w$")
  local buf_lines = nvim_buf_get_lines(buf, top - 1, bot, false)
  local total = #buf_lines
  local offset = top - 1
  local first = lines[1]
  local last = lines[n]
  local first_len = #first
  local last_len = #last
  local ids = {}
  local ids_n = 0
  local pos = {}
  local pos_n = 0

  local lens = {}
  for i = 1, n do
    lens[i] = #lines[i]
  end

  for row = 1, total - n + 1 do
    local bl = buf_lines[row]
    ---@cast bl string
    if #bl >= first_len and string_sub(bl, -first_len) == first then
      local match = true
      for i = 2, n - 1 do
        if buf_lines[row + i - 1] ~= lines[i] then
          match = false
          break
        end
      end
      if match then
        local last_line = buf_lines[row + n - 1]
        if not last_line or #last_line < last_len or string_sub(last_line, 1, last_len) ~= last then
          match = false
        end
      end
      if match then
        local base = offset + row
        local col = #bl - first_len + 1
        for i = 1, n do
          local ll = lens[i]
          if ll >= 1 then
            pos_n = pos_n + 1
            pos[pos_n] = { base + i - 1, i == 1 and col or 1, ll }
          end
        end
      end
    end
  end

  if pos_n > 0 then
    ids_n = ids_n + 1
    ids[ids_n] = matchaddpos("Cursorword", pos, 200, -1, { window = win })
  end
  matches[win] = { ids = ids }
end

local function highlight(mode)
  local win = nvim_get_current_win()

  if disabled_bufs[nvim_get_current_buf()] then
    clear(win)
    return
  end

  if mode == "v" or mode == "V" or mode == "\22" then
    local from = getpos("v")
    local to = getpos(".")
    local lines = getregion(from, to, { type = mode })

    if #lines == 1 then
      local text = lines[1]
      ---@cast text string
      if #text >= 2 then
        set_match(win, [[\V]] .. escape(text, [[\]]), 10)
      else
        clear(win)
      end
    else
      set_match_visual(win, lines)
    end
    return
  elseif mode ~= "n" and mode ~= "no" then
    return
  end

  local col = nvim_win_get_cursor(0)[2]
  local _line = nvim_get_current_line()
  local _b = byte(_line, col + 1)
  if not _b or not is_word_byte(_b) then
    clear(win)
    return
  end

  local word = get_word(_line, col, _b)
  if #word > 0 then
    set_match(win, [[\V\<]] .. escape(word, [[\]]) .. [[\>]], 100)
  else
    clear(win)
  end
end

local augroup = nvim_create_augroup("cursorword", { clear = true })

nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = augroup,
  callback = function()
    highlight(nvim_get_mode().mode)
  end,
})

nvim_create_autocmd("ModeChanged", {
  group = augroup,
  callback = function()
    local mode = nvim_get_mode().mode
    if mode == "i" or mode == "t" then
      clear()
    else
      highlight(mode)
    end
  end,
})

nvim_create_autocmd({ "InsertEnter", "TermEnter", "QuitPre" }, {
  group = augroup,
  callback = function()
    clear()
  end,
})

nvim_create_autocmd("WinClosed", {
  group = augroup,
  callback = function(ev)
    last_pattern[tonumber(ev.match)] = nil
    matches[tonumber(ev.match)] = nil
  end,
})

nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "neo-tree", "SidebarNvim" },
  callback = function()
    b.cursorword_disable = true
  end,
})

nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = augroup,
  callback = function(ev)
    disabled_bufs[ev.buf] = b[ev.buf].cursorword_disable or false
  end,
})
