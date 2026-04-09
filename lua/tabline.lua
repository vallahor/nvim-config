local api, fn, bo = vim.api, vim.fn, vim.bo
local floor, strwidth, fnamemodify = math.floor, fn.strwidth, fn.fnamemodify

local M = {}

M.update_cursor_line_hl = function(_, _) end

local focus_idx = 1
local ghost_space = 4
---@type {slide_window: {b: integer, str: string, w: integer }[]|{b: nil, str: string, w: integer }[], w_avail: integer, w_changed: boolean, lo: integer, hi: integer}
local ruler = {
  slide_window = {},
  w_avail = 0,
  w_changed = true,
  lo = 1,
  hi = 1,
}
local buf_order = {}
local buf_index = {}
local diag_cache = {}
local tabs_cache = {} ---@type table
local tabs_width_cache = 0

local function update_buf_index()
  for i, b in ipairs(buf_order) do
    buf_index[b] = i
  end
  ruler.w_avail = 0
  ruler.w_changed = true
end

local function get_current_index()
  return buf_index[api.nvim_get_current_buf()] or 1
end

local function init_bufs()
  for _, b in ipairs(api.nvim_list_bufs()) do
    if bo[b].buflisted then
      buf_order[#buf_order + 1] = b
    end
  end
  update_buf_index()
end

local function resolve_tabs()
  local buf_names = {}
  local counts = {}

  for _, b in ipairs(buf_order) do
    local bufname = api.nvim_buf_get_name(b)
    local tail = bufname ~= "" and fnamemodify(bufname, ":t") or "[No Name]"
    counts[tail] = (counts[tail] or 0) + 1
    buf_names[#buf_names + 1] = { b = b, bufname = bufname, tail = tail }
  end

  local tabs = {}
  local total_w = 0

  for _, info in ipairs(buf_names) do
    local display
    if counts[info.tail] > 1 and info.bufname ~= "" then
      display = " " .. fnamemodify(info.bufname, ":~:."):gsub("^%./", "") .. " "
    else
      display = " " .. info.tail .. " "
    end
    local width = strwidth(display)
    tabs[#tabs + 1] = { b = info.b, str = display, w = width }
    total_w = total_w + width
  end

  tabs_cache = tabs
  tabs_width_cache = total_w
end

local nvim_tree_view = require("nvim-tree.view")
local explorer_label = "Explorer"
local explorer_label_len = strwidth(explorer_label)

local cached_pad = -1
local cached_spaces = ""
local function spaces(n)
  if cached_pad ~= n then
    cached_pad = n
    cached_spaces = string.rep(" ", n)
  end
  return cached_spaces
end

local function render_sidebar(tree_winnr, in_tree)
  if not tree_winnr then
    return "", 0
  end
  local sidebar_width = api.nvim_win_get_width(tree_winnr)
  local pad = math.max(0, floor((sidebar_width - explorer_label_len) / 2))
  local hl = in_tree and "%#TablineSidebarLabelFocused#" or "%#TablineSidebarLabelHidden#"
  local p = spaces(pad)
  return hl .. p .. explorer_label .. p .. "%#TablineSidebarSep#│", sidebar_width
end

---@type table<integer, table<integer, table<integer, string>>>
local diag_hl_map = {
  [1] = {
    { "%#TablineDiagErrorHid#", "%#TablineDiagError#" },
    { "%#TablineDiagModifiedErrorHid#", "%#TablineDiagModifiedError#" },
  },
  [2] = {
    { "%#TablineDiagWarnHid#", "%#TablineDiagWarn#" },
    { "%#TablineDiagModifiedWarnHid#", "%#TablineDiagModifiedWarn#" },
  },
}

local diag_filter = { severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR } }

---@param b integer
---@param focused boolean
---@return string
local function resolve_hl(b, focused)
  if not b then
    return ""
  end
  local modified = bo[b].modified
  local cached = diag_cache[b]
  if not cached then
    cached = vim.diagnostic.count(b, diag_filter)
    diag_cache[b] = cached
  end
  local sev = (cached[1] and cached[1] > 0) and 1 or (cached[2] and cached[2] > 0) and 2 or nil
  if sev then
    return diag_hl_map[sev][modified and 2 or 1][focused and 2 or 1]
  end
  if modified then
    return focused and "%#TablineModifiedCurrent#" or "%#TablineModifiedVisible#"
  end
  return focused and "%#TablineCurrent#" or "%#TablineVisible#"
end

local function get_ruler_hi(idx, avail)
  local w = tabs_cache[idx].w
  local hi = idx
  for pos = hi + 1, #tabs_cache do
    if w + tabs_cache[pos].w > avail - ghost_space then
      break
    end
    w = w + tabs_cache[pos].w
    hi = pos
  end
  return hi, w
end

local function get_ruler_lo(idx, avail)
  local w = tabs_cache[idx].w
  local lo = idx
  for pos = lo - 1, 1, -1 do
    if w + tabs_cache[pos].w > avail - ghost_space then
      break
    end
    w = w + tabs_cache[pos].w
    lo = pos
  end
  return lo, w
end

local function truncate_tabs(avail)
  local w = 0

  if focus_idx > ruler.hi then
    ruler.hi = focus_idx
    ruler.lo, w = get_ruler_lo(focus_idx, avail)
  elseif focus_idx < ruler.lo then
    ruler.hi, w = get_ruler_hi(focus_idx, avail)
    ruler.lo = focus_idx
  elseif ruler.w_avail ~= avail or ruler.w_changed then
    ruler.w_avail = avail
    ruler.hi, w = get_ruler_hi(ruler.lo, avail)
    if ruler.hi == #tabs_cache then
      ruler.lo, w = get_ruler_lo(ruler.hi, avail)
    end
  end

  if w ~= 0 then
    ruler.slide_window = {}
    if ruler.lo > 1 then
      ruler.slide_window[#ruler.slide_window + 1] = { b = nil, str = " %#TablineHidden#…", w = 1 }
    end
    for i = ruler.lo, ruler.hi do
      ruler.slide_window[#ruler.slide_window + 1] = tabs_cache[i]
    end
    if ruler.hi < #tabs_cache then
      ruler.slide_window[#ruler.slide_window + 1] = { b = nil, str = "%#TablineHidden#… ", w = 1 }
    end
  end

  return ruler.slide_window
end

function M.make_tabline()
  local cur_win = api.nvim_get_current_win()
  local tree_winnr = nvim_tree_view.get_winnr()
  local in_tree = tree_winnr ~= nil and cur_win == tree_winnr

  local cur_buf = in_tree and -1 or api.nvim_get_current_buf()

  local sidebar, sidebar_width = render_sidebar(tree_winnr, in_tree)

  if not in_tree and buf_index[cur_buf] then
    focus_idx = buf_index[cur_buf]
  end
  focus_idx = math.max(1, math.min(focus_idx, #tabs_cache))

  local avail = vim.o.columns - sidebar_width - (tree_winnr and 1 or 0)

  ---@type {b: integer, str: string, w: integer }[]|{b: nil, str: string, w: integer }[]
  local result_tabs = (tabs_width_cache > avail and truncate_tabs(avail) or tabs_cache)

  local parts = { sidebar }
  for _, part in ipairs(result_tabs) do
    if part.b then
      local hl = resolve_hl(part.b, part.b == cur_buf)
      parts[#parts + 1] = hl .. part.str
    else
      parts[#parts + 1] = part.str
    end
  end
  parts[#parts + 1] = "%#TablineFill#"
  return table.concat(parts)
end

local function is_nvim_tree()
  return api.nvim_get_current_win() == nvim_tree_view.get_winnr()
end

function M.prev_tab()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i > 1 then
    api.nvim_set_current_buf(buf_order[i - 1])
  end
end

function M.next_tab()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i < #buf_order then
    api.nvim_set_current_buf(buf_order[i + 1])
  end
end

function M.move_to_begin()
  if is_nvim_tree() then
    return
  end
  api.nvim_set_current_buf(buf_order[1])
end

function M.move_to_end()
  if is_nvim_tree() then
    return
  end
  api.nvim_set_current_buf(buf_order[#buf_order])
end

local function swap(i, j)
  buf_order[i], buf_order[j] = buf_order[j], buf_order[i]
  tabs_cache[i], tabs_cache[j] = tabs_cache[j], tabs_cache[i]
  buf_index[buf_order[i]] = i
  buf_index[buf_order[j]] = j
  ruler.w_changed = true
  vim.cmd.redrawtabline()
end

function M.move_tab_left()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i > 1 then
    swap(i, i - 1)
  end
end

function M.move_tab_right()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i < #buf_order then
    swap(i, i + 1)
  end
end

function M.move_tab_begin()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i > 1 then
    local b = table.remove(buf_order, i)
    table.insert(buf_order, 1, b)
    local t = table.remove(tabs_cache, i)
    table.insert(tabs_cache, 1, t)
    update_buf_index()
    vim.cmd.redrawtabline()
  end
end

function M.move_tab_end()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i < #buf_order then
    local b = table.remove(buf_order, i)
    buf_order[#buf_order + 1] = b
    local t = table.remove(tabs_cache, i)
    tabs_cache[#tabs_cache + 1] = t
    update_buf_index()
    vim.cmd.redrawtabline()
  end
end

function M.buf_delete(bufnr, force)
  bufnr = bufnr == 0 and api.nvim_get_current_buf() or bufnr
  local idx = buf_index[bufnr]
  if not idx then
    return
  end

  if not force and bo[bufnr].modified then
    -- @check if worth it (delete scratch buffer without asking)
    -- if bo[bufnr].buftype == "" then
    --   M.buf_delete(bufnr, true)
    --   return
    -- end
    local choice = fn.confirm("Unsaved changes:", "&Save\n&Discard\n&Cancel", 1)
    if choice == 1 then
      pcall(api.nvim_buf_call, bufnr, function()
        vim.cmd.write()
      end)
      M.buf_delete(bufnr, true)
    elseif choice == 2 then
      M.buf_delete(bufnr, true)
    end
    return
  end

  table.remove(buf_order, idx)

  ---@type integer?
  local replacement = buf_order[idx] or buf_order[idx - 1]
  if not replacement then
    replacement = api.nvim_create_buf(true, false)
    buf_order[idx] = replacement
  end

  local cur_win = api.nvim_get_current_win()
  for _, win in ipairs(fn.win_findbuf(bufnr)) do
    api.nvim_win_set_buf(win, replacement)
    M.update_cursor_line_hl(cur_win, win)
  end

  buf_index[bufnr] = nil
  diag_cache[bufnr] = nil
  update_buf_index()
  resolve_tabs()

  if api.nvim_buf_is_valid(bufnr) then
    api.nvim_buf_delete(bufnr, { force = true })
  end
end

local function setup_tabline_hl()
  local function get_hex(group, attr)
    local ok, val = pcall(api.nvim_get_hl, 0, { name = group, link = false })
    if not ok or not val then
      return
    end
    local n = attr == "fg" and val.fg or val.bg
    return n and string.format("#%06x", n)
  end

  local dim_fg = "#7e706c"
  local focused_bg = "#3f303f"
  local hidden_bg = "#191319"
  local normal_fg = get_hex("Normal", "fg")
  local win_sep_fg = get_hex("WinSeparator", "fg")
  local errors_fg = get_hex("DiagnosticError", "fg")
  local warning_fg = get_hex("DiagnosticWarn", "fg")

  local hl = api.nvim_set_hl
  hl(0, "TablineCurrent", { fg = normal_fg, bg = focused_bg })
  hl(0, "TablineVisible", { fg = dim_fg, bg = hidden_bg })
  hl(0, "TablineHidden", { fg = dim_fg, bg = hidden_bg })
  hl(0, "TablineModifiedCurrent", { fg = normal_fg, bg = focused_bg, italic = true })
  hl(0, "TablineModifiedVisible", { fg = dim_fg, bg = hidden_bg, italic = true })
  hl(0, "TablineModifiedHidden", { fg = dim_fg, bg = hidden_bg, italic = true })
  hl(0, "TablineFill", { bg = hidden_bg })
  hl(0, "TablineSidebarLabelFocused", { fg = normal_fg, bg = focused_bg })
  hl(0, "TablineSidebarLabelHidden", { fg = normal_fg, bg = hidden_bg })
  hl(0, "TablineSidebarSep", { fg = win_sep_fg, bg = hidden_bg })
  hl(0, "TablineDiagError", { fg = errors_fg, bg = focused_bg })
  hl(0, "TablineDiagErrorHid", { fg = errors_fg, bg = hidden_bg })
  hl(0, "TablineDiagWarn", { fg = warning_fg, bg = focused_bg })
  hl(0, "TablineDiagWarnHid", { fg = warning_fg, bg = hidden_bg })
  hl(0, "TablineDiagModifiedError", { fg = errors_fg, bg = focused_bg, italic = true })
  hl(0, "TablineDiagModifiedErrorHid", { fg = errors_fg, bg = hidden_bg, italic = true })
  hl(0, "TablineDiagModifiedWarn", { fg = warning_fg, bg = focused_bg, italic = true })
  hl(0, "TablineDiagModifiedWarnHid", { fg = warning_fg, bg = hidden_bg, italic = true })
end

local function setup_autocmds()
  api.nvim_create_autocmd("BufEnter", {
    callback = function()
      local b = api.nvim_get_current_buf()
      if not bo[b].buflisted or buf_index[b] then
        return
      end
      vim.schedule(function()
        if not api.nvim_buf_is_valid(b) or buf_index[b] then
          return
        end
        buf_order[#buf_order + 1] = b
        update_buf_index()
        ruler.w_changed = true
        resolve_tabs()
        vim.cmd.redrawtabline()
      end)
    end,
  })

  api.nvim_create_autocmd("BufDelete", {
    callback = function(ev)
      local b = ev.buf
      local idx = buf_index[b]
      if not idx then
        return
      end

      table.remove(buf_order, idx)

      buf_index[b] = nil
      diag_cache[b] = nil
      ruler.w_changed = true
      update_buf_index()
      resolve_tabs()
    end,
  })

  api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function(ev)
      diag_cache[ev.buf] = nil
    end,
  })

  api.nvim_create_autocmd({ "BufFilePost", "BufAdd" }, {
    callback = resolve_tabs,
  })

  api.nvim_create_autocmd("ColorScheme", {
    once = true,
    callback = setup_tabline_hl,
  })
end

local function setup_keymaps()
  local map = vim.keymap.set
  map("n", "<home>", M.prev_tab, { silent = true })
  map("n", "<end>", M.next_tab, { silent = true })
  map("n", "<s-home>", M.move_to_begin, { silent = true })
  map("n", "<s-end>", M.move_to_end, { silent = true })
  map("n", "<c-home>", M.move_tab_left, { silent = true })
  map("n", "<c-end>", M.move_tab_right, { silent = true })
  map("n", "<c-s-home>", M.move_tab_begin, { silent = true })
  map("n", "<c-s-end>", M.move_tab_end, { silent = true })
  map("n", "<c-w>", function()
    M.buf_delete(0, false)
  end, { silent = true, nowait = true })
  map("n", "<c-x>", function()
    M.buf_delete(0, true)
  end, { silent = true, nowait = true })
end

_G.make_tabline = M.make_tabline
vim.opt.tabline = "%!v:lua.make_tabline()"
vim.opt.showtabline = 2

function M.setup(opts)
  init_bufs()
  setup_autocmds()
  setup_keymaps()
  setup_tabline_hl()
  resolve_tabs()

  if opts and type(opts.update_cursor_line_hl) == "function" then
    M.update_cursor_line_hl = opts.update_cursor_line_hl
  end
end

return M
