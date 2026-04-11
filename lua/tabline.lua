local api, fn, bo = vim.api, vim.fn, vim.bo
local floor, strwidth, fnamemodify = math.floor, fn.strwidth, fn.fnamemodify

local M = {}

M.update_cursor_line_hl = function(_, _) end

---@type {str: string, width: integer, changed: boolean, diag_or_input_changed: boolean, lo: integer, hi: integer, buf: integer, index: integer}
local viewport = {
  str = "",
  width = 0,
  changed = true,
  diag_or_input_changed = true,
  lo = 1,
  hi = 1,
  buf = 1,
  index = 1,
}

local buf_cache = {}
local buf_index = {}
local diag_cache = {}
local tabs_cache = {} ---@type table

local ghost_space = 4
local tabs_width_cache = 0

local sidebar = ""
local sidebar_width_cache = 0
local sidebar_open = false
local sidebar_winnr = nil

local prefix = ""
local postfix = ""
local endfix = "%#TablineFill#"

local function update_buf_index()
  for i, b in ipairs(buf_cache) do
    buf_index[b] = i
  end
  if not sidebar_open and buf_index[viewport.buf] then
    viewport.index = buf_index[viewport.buf]
  end
  viewport.width = 0
  viewport.changed = true
end

local function resolve_tabs()
  update_buf_index()

  local buf_names = {}
  local counts = {}

  for _, b in ipairs(buf_cache) do
    local bufname = api.nvim_buf_get_name(b)
    local tail = bufname ~= "" and fnamemodify(bufname, ":t") or "[No Name]"
    counts[tail] = (counts[tail] or 0) + 1
    buf_names[#buf_names + 1] = { bufname = bufname, tail = tail }
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
    tabs[#tabs + 1] = { str = display, w = width }
    total_w = total_w + width
  end

  tabs_cache = tabs
  tabs_width_cache = total_w

  viewport.changed = true
end

local function init_bufs()
  for _, b in ipairs(api.nvim_list_bufs()) do
    if bo[b].buflisted then
      buf_cache[#buf_cache + 1] = b
    end
  end
  resolve_tabs()
end

local function get_current_index()
  return buf_index[viewport.buf] or 1
end

local nvim_tree_view = require("nvim-tree.view")
local explorer_label = "Explorer"
local explorer_label_len = strwidth(explorer_label)

local cached_pad = -1
local cached_spaces = ""
local function make_spaces(n)
  if cached_pad ~= n then
    cached_pad = n
    cached_spaces = string.rep(" ", n)
  end
  return cached_spaces
end

---@return integer
local function render_sidebar()
  if not sidebar_winnr or not api.nvim_win_is_valid(sidebar_winnr) then
    return 0
  end
  -- add the `separator` width to sidebar_width
  local sidebar_width = api.nvim_win_get_width(sidebar_winnr) + 1
  if sidebar_width ~= sidebar_width_cache then
    sidebar_width_cache = sidebar_width
    local pad = math.max(0, floor((sidebar_width - explorer_label_len) / 2))
    local p = make_spaces(pad)
    sidebar = p .. explorer_label .. p .. "%#TablineSidebarSep#│"
  end
  return sidebar_width
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
  if not diag_cache[b] then
    diag_cache[b] = vim.diagnostic.count(b, diag_filter)
  end
  local sev = diag_cache[b] and (diag_cache[b][vim.diagnostic.severity.ERROR] or 0) > 0 and 1
    or (diag_cache[b][vim.diagnostic.severity.WARN] or 0) > 0 and 2
    or nil
  if sev then
    return diag_hl_map[sev][modified and 2 or 1][focused and 2 or 1]
  end
  if modified then
    return focused and "%#TablineModifiedCurrent#" or "%#TablineModifiedVisible#"
  end
  return focused and "%#TablineCurrent#" or "%#TablineVisible#"
end

local function get_ruler_hi(idx, width)
  local w = tabs_cache[idx].w
  local hi = idx
  for pos = hi + 1, #tabs_cache do
    if w + tabs_cache[pos].w > width - ghost_space then
      break
    end
    w = w + tabs_cache[pos].w
    hi = pos
  end
  return hi, w
end

local function get_ruler_lo(idx, width)
  local w = tabs_cache[idx].w
  local lo = idx
  for pos = lo - 1, 1, -1 do
    if w + tabs_cache[pos].w > width - ghost_space then
      break
    end
    w = w + tabs_cache[pos].w
    lo = pos
  end
  return lo, -w
end

local function resolve_prefix_str(size)
  local tab = tabs_cache[viewport.lo - 1] --[[@as table]]
  local buf = buf_cache[viewport.lo - 1] --[[@as integer]]
  return resolve_hl(buf, false) .. string.sub(tab.str, -size)
end

local function resolve_post_str(size)
  local tab = tabs_cache[viewport.hi + 1] --[[@as table]]
  local buf = buf_cache[viewport.hi + 1] --[[@as integer]]
  return resolve_hl(buf, false) .. string.sub(tab.str, 1, size)
end

---@param width integer
local function calc_truncated_tabs(width)
  local w = 0

  if viewport.index > viewport.hi then
    viewport.hi = viewport.index
    viewport.lo, w = get_ruler_lo(viewport.index, width)
  elseif viewport.index < viewport.lo then
    viewport.hi, w = get_ruler_hi(viewport.index, width)
    viewport.lo = viewport.index
  elseif viewport.width ~= width then
    viewport.width = width
    viewport.hi, w = get_ruler_hi(viewport.lo, width)
    if viewport.hi == #tabs_cache then
      viewport.lo, w = get_ruler_lo(viewport.hi, width)
    end
    if viewport.index < viewport.lo then
      viewport.lo = viewport.index
      viewport.hi, w = get_ruler_hi(viewport.lo, width)
    end
    if viewport.index > viewport.hi then
      viewport.hi = viewport.index
      viewport.lo, w = get_ruler_lo(viewport.hi, width)
    end
  end

  if w ~= 0 then
    prefix = ""
    postfix = ""
    local space = (viewport.lo > 1 and 2 or 0) + (viewport.hi < #tabs_cache and 2 or 0)
    if viewport.lo > 1 then
      prefix = " %#TablineHidden#…"
      if w < 0 then
        local size = width + w - space
        if size > 0 then
          prefix = prefix .. resolve_prefix_str(width - math.abs(w) - space)
        end
      end
    end
    if viewport.hi < #tabs_cache then
      postfix = "%#TablineHidden#… "
      if w > 0 then
        local size = width - w - space
        if size > 0 then
          postfix = resolve_post_str(width - w - space) .. postfix
        end
      end
    end
  end
end

function M.make_tabline()
  local sidebar_width = render_sidebar()
  local width = vim.o.columns - sidebar_width
  if viewport.width ~= width or viewport.changed or viewport.diag_or_input_changed then
    if viewport.diag_or_input_changed and not viewport.changed then
      viewport.diag_or_input_changed = false
      goto build_viewport_str
    end

    if tabs_width_cache > width then
      calc_truncated_tabs(width)
    else
      viewport.lo = 1
      viewport.hi = #tabs_cache
      prefix = ""
      postfix = ""
    end

    ::build_viewport_str::

    local sidebar_str = ""
    local hl = ""
    if sidebar_width > 0 then
      hl = sidebar_open and "%#TablineSidebarLabelFocused#" or "%#TablineSidebarLabelHidden#"
      sidebar_str = sidebar
    end

    local tabs = { hl, sidebar_str, prefix }
    for i = viewport.lo, viewport.hi do
      ---@type table
      local tab = tabs_cache[i]
      local buf = buf_cache[i] --[[@as integer]]
      tabs[#tabs + 1] = resolve_hl(buf, buf == viewport.buf) .. tab.str
    end
    tabs[#tabs + 1] = postfix
    tabs[#tabs + 1] = endfix

    viewport.changed = false
    viewport.str = table.concat(tabs)
  end
  return viewport.str
end

local function is_nvim_tree()
  return sidebar_open
end

function M.prev_tab()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i > 1 then
    api.nvim_set_current_buf(buf_cache[i - 1])
  end
end

function M.next_tab()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i < #buf_cache then
    api.nvim_set_current_buf(buf_cache[i + 1])
  end
end

function M.move_to_begin()
  if is_nvim_tree() then
    return
  end
  api.nvim_set_current_buf(buf_cache[1])
end

function M.move_to_end()
  if is_nvim_tree() then
    return
  end
  api.nvim_set_current_buf(buf_cache[#buf_cache])
end

local function swap(i, j)
  buf_cache[i], buf_cache[j] = buf_cache[j], buf_cache[i]
  tabs_cache[i], tabs_cache[j] = tabs_cache[j], tabs_cache[i]
  buf_index[buf_cache[i]] = i
  buf_index[buf_cache[j]] = j
  viewport.index = buf_index[viewport.buf]
  viewport.changed = true
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
  if i < #buf_cache then
    swap(i, i + 1)
  end
end

function M.move_tab_begin()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i > 1 then
    local b = table.remove(buf_cache, i)
    table.insert(buf_cache, 1, b)
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
  if i < #buf_cache then
    local b = table.remove(buf_cache, i)
    buf_cache[#buf_cache + 1] = b
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

  table.remove(buf_cache, idx)

  ---@type integer?
  local replacement = buf_cache[idx] or buf_cache[idx - 1]
  if not replacement then
    replacement = api.nvim_create_buf(true, false)
    buf_cache[idx] = replacement
  end

  local cur_win = api.nvim_get_current_win()
  for _, win in ipairs(fn.win_findbuf(bufnr)) do
    api.nvim_win_set_buf(win, replacement)
    M.update_cursor_line_hl(cur_win, win)
  end

  buf_index[bufnr] = nil
  diag_cache[bufnr] = nil
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
      if not bo[b].buflisted then
        return
      end
      vim.schedule(function()
        if not api.nvim_buf_is_valid(b) or buf_index[b] then
          return
        end
        buf_cache[#buf_cache + 1] = b
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

      table.remove(buf_cache, idx)

      buf_index[b] = nil
      diag_cache[b] = nil

      resolve_tabs()
    end,
  })

  api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function(ev)
      diag_cache[ev.buf] = nil
    end,
  })

  api.nvim_create_autocmd({ "BufModifiedSet", "DiagnosticChanged" }, {
    callback = function()
      viewport.diag_or_input_changed = true
      vim.cmd.redrawtabline()
    end,
  })

  api.nvim_create_autocmd("BufFilePost", {
    callback = resolve_tabs,
  })

  api.nvim_create_autocmd("ColorScheme", {
    once = true,
    callback = setup_tabline_hl,
  })

  api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
      sidebar_winnr = nvim_tree_view.get_winnr()
      sidebar_open = api.nvim_get_current_win() == sidebar_winnr
      viewport.buf = sidebar_open and -1 or api.nvim_get_current_buf()

      if not sidebar_open and buf_index[viewport.buf] then
        viewport.index = buf_index[viewport.buf]
      end

      viewport.changed = true
    end,
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

  if opts and type(opts.update_cursor_line_hl) == "function" then
    M.update_cursor_line_hl = opts.update_cursor_line_hl
  end
end

return M
