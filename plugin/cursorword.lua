local b = vim.b
local matchadd = vim.fn.matchadd
local matchdelete = vim.fn.matchdelete
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

local string_sub = string.sub
local string_match = string.match

vim.api.nvim_set_hl(0, "Cursorword", {
  sp = "none",
  fg = "none",
  bg = "#2D2829",
})

local match_ids = {}
local match_words = {}
local disabled_bufs = {}

local function clear(win)
  win = win or nvim_get_current_win()
  if match_ids[win] then
    matchdelete(match_ids[win], win)
    match_ids[win] = nil
    match_words[win] = nil
  end
end

local function get_word(line, col)
  local left = string_match(string_sub(line, 1, col + 1), "[%w_]+$") or ""
  local right = string_match(string_sub(line, col + 2), "^[%w_]+") or ""
  return left .. right
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
    local text = getregion(from, to, { type = mode })[1]
    if text and #text >= 2 then
      if match_words[win] ~= text then
        clear(win)
        match_words[win] = text
        match_ids[win] = matchadd("Cursorword", [[\V]] .. escape(text, [[\]]), 10, -1, { window = win })
      end
    else
      clear(win)
    end
    return
  elseif mode ~= "n" and mode ~= "no" then
    return
  end

  local col = nvim_win_get_cursor(0)[2]
  local line = nvim_get_current_line()
  local char = string_sub(line, col + 1, col + 1)
  if not string_match(char, "[%w_]") then
    clear(win)
    return
  end

  local word = get_word(line, col)
  if #word >= 2 then
    if match_words[win] ~= word then
      clear(win)
      match_words[win] = word
      match_ids[win] = matchadd("Cursorword", [[\V\<]] .. escape(word, [[\]]) .. [[\>]], -2, -1, { window = win })
    end
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
  callback = clear,
})

nvim_create_autocmd("WinClosed", {
  group = augroup,
  callback = function(ev)
    match_ids[ev.match] = nil
    match_words[ev.match] = nil
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
