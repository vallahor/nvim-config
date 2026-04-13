local nvim_tree_view = require("nvim-tree.view")

local api, fn, bo = vim.api, vim.fn, vim.bo
local strwidth, fnamemodify = fn.strwidth, fn.fnamemodify

local M = {}

local prefix_size = 0

M.update_cursor_line_hl = function(_, _) end

---@class Viewport
---@field str string
---@field width integer
---@field changed boolean
---@field buf_deleted boolean
---@field diag_or_input_changed boolean
---@field lo integer
---@field hi integer
---@field buf integer
---@field index integer
---@field indicator_left integer
---@field indicator_right integer
---@field prefix string
---@field postfix string
---@field endfix string
---@field total_tabs_width integer
---@field close_icon_width integer
local viewport = {
  str = "",
  width = 0,
  changed = true,
  buf_deleted = false,
  diag_or_input_changed = true,
  lo = 1,
  hi = 1,
  buf = 1,
  index = 1,
  prefix = "",
  postfix = "",
  endfix = "%#TablineFill#",
  indicator_left = 2,
  indicator_right = 2,
  total_tabs_width = 0,
  close_icon_width = 0,
}

---@class Sidebar
---@field str string
---@field label string
---@field label_width integer
---@field separator_wdith integer
---@field separator string
---@field width integer
---@field focus boolean
---@field winnr integer?
local sidebar = {
  str = "",
  label = "",
  label_width = 0,
  separator = "",
  separator_width = 0,
  width = 0,
  focus = false,
  winnr = nil,
}

---@type {[integer]: integer}
local buf_cache = {}

---@type {[integer]: integer?}
local buf_index = {}

---@type {[integer]: table<integer, integer>?}
local diag_cache = {}

---@class Icon
---@field str string
---@field width integer
---@field get function

---@class Tab
---@field str string
---@field width integer
---@field icon Icon?

---@type {[integer]: Tab}
local tabs_cache = {}

local redraw_scheduled = false

local function schedule_redraw()
  if not redraw_scheduled then
    redraw_scheduled = true
    vim.schedule(function()
      redraw_scheduled = false
      vim.cmd.redrawtabline()
    end)
  end
end

local function focus_on_click(bufnr)
  if M.focus_on_click then
    return "%" .. bufnr .. "@v:lua.FocusTab@"
  end
  return ""
end

local function close_on_click(bufnr)
  if M.close_icon ~= "" then
    return "%" .. bufnr .. "@v:lua.CloseTab@" .. M.close_icon .. "%X"
  end
  return ""
end

local function update_buf_index()
  for i, b in ipairs(buf_cache) do
    buf_index[b] = i
  end
  if not sidebar.focus and buf_index[viewport.buf] then
    viewport.index = buf_index[viewport.buf]
  end
  viewport.changed = true
end

local function resolve_tabs()
  update_buf_index()

  tabs_cache = {}

  local buf_names = {}
  local counts = {}

  for _, buf in ipairs(buf_cache) do
    local bufname = api.nvim_buf_get_name(buf)
    local tail = bufname ~= "" and fnamemodify(bufname, ":t") or "[No Name]"
    local ext = bufname ~= "" and fnamemodify(bufname, ":e") or ""
    counts[tail] = (counts[tail] or 0) + 1
    buf_names[#buf_names + 1] = { buf = buf, ext = ext, bufname = bufname, tail = tail }
  end

  local total_w = 0

  for _, info in ipairs(buf_names) do
    local display
    if counts[info.tail] > 1 and info.bufname ~= "" and M.unique_names then
      display = " " .. fnamemodify(info.bufname, ":~:."):gsub("^%./", "") .. " "
    else
      display = " " .. info.tail .. " "
    end
    local width = vim.api.nvim_strwidth(display) + viewport.close_icon_width
    local tab_icon
    if M.icons.enabled then
      local icon, color = M.get_icon(info.ext)
      if icon ~= "" then
        icon = " " .. icon
        local icon_width = vim.api.nvim_strwidth(icon)
        width = width + icon_width
        tab_icon = {
          str = icon,
          width = icon_width,
          get = function(focused, hl)
            return M.get_icon_hl(info.ext, color, focused) .. icon .. hl
          end,
        }
      end
    end
    tabs_cache[#tabs_cache + 1] = {
      str = display,
      width = width,
      icon = tab_icon,
    }
    total_w = total_w + width
  end

  viewport.total_tabs_width = total_w
end

local icon_hl_cache = {}

local function init_bufs()
  for _, b in ipairs(api.nvim_list_bufs()) do
    if bo[b].buflisted then
      buf_cache[#buf_cache + 1] = b
    end
  end
  resolve_tabs()
end

--- @return integer
local function get_current_index()
  return buf_index[viewport.buf] or 1
end

local cached_pad_left = -1
local cached_pad_right = -1
local sidebar_spaces_left = ""
local sidebar_spaces_right = ""
local function make_spaces(cached_pad, str, n)
  if cached_pad ~= n then
    cached_pad = n
    str = string.rep(" ", n)
  end
  return str
end

---@return integer
local function render_sidebar()
  if not sidebar.winnr or not api.nvim_win_is_valid(sidebar.winnr) then
    return 0
  end
  -- add the `separator` width to sidebar_width
  local sidebar_width = api.nvim_win_get_width(sidebar.winnr) + sidebar.separator_width
  if sidebar_width ~= sidebar.width then
    sidebar.width = sidebar_width
    local total_pad = math.max(0, sidebar_width - sidebar.label_width - sidebar.separator_width)
    local pad_left = math.ceil(total_pad / 2)
    local pad_right = math.floor(total_pad / 2)
    local spaces_left = make_spaces(cached_pad_left, sidebar_spaces_left, pad_left)
    local spaces_right = make_spaces(cached_pad_right, sidebar_spaces_right, pad_right)
    sidebar.str = spaces_left .. sidebar.label .. spaces_right .. "%#TablineSidebarSep#" .. sidebar.separator
  end
  return sidebar_width
end

---@type table<integer, table<integer, table<integer, string>>>
local diag_hl_map = {
  [1] = {
    { "%#TablineVisibleDiagError#", "%#TablineFocusedDiagError#" },
    { "%#TablineVisibleDiagModifiedError#", "%#TablineFocusedDiagModifiedError#" },
  },
  [2] = {
    { "%#TablineVisibleDiagWarn#", "%#TablineFocusedDiagWarn#" },
    { "%#TablineVisibleDiagModifiedWarn#", "%#TablineFocusedDiagModifiedWarn#" },
  },
}

local diag_filter = { severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR } }

---@param b integer
---@param focused boolean
---@return string
M.resolve_hl = function(b, focused)
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
    return focused and "%#TablineFocusedModified#" or "%#TablineVisibleModified#"
  end
  return focused and "%#TablineFocused#" or "%#TablineVisible#"
end

local function get_viewport_hi(idx, width)
  local w = tabs_cache[idx].width
  local hi = idx
  for pos = hi + 1, #tabs_cache do
    if w + tabs_cache[pos].width > width then
      break
    end
    w = w + tabs_cache[pos].width
    hi = pos
  end
  return hi, width - w
end

local function get_viewport_lo(idx, width)
  local w = tabs_cache[idx].width
  local lo = idx
  for pos = lo - 1, 1, -1 do
    if w + tabs_cache[pos].width > width then
      break
    end
    w = w + tabs_cache[pos].width
    lo = pos
  end
  return lo, width - w
end

local function resolve_prefix_str(size)
  local tab = tabs_cache[viewport.lo - 1]
  local buf = buf_cache[viewport.lo - 1]
  local pad = string.rep(" ", math.max(0, size - vim.api.nvim_strwidth(tab.str)))
  return pad .. M.resolve_hl(buf, false) .. vim.fn.strcharpart(tab.str, vim.fn.strcharlen(tab.str) - size, size)
end

local function resolve_post_str(size)
  local tab = tabs_cache[viewport.hi + 1]
  local buf = buf_cache[viewport.hi + 1]
  local tab_hl = M.resolve_hl(buf, false)
  local icon = ""
  if tab.icon then
    local remaining = size - tab.icon.width
    if remaining >= 0 then
      icon = tab.icon.get(false, tab_hl)
      size = remaining
    else
      return string.rep(" ", size)
    end
  end
  return icon .. tab_hl .. vim.fn.strcharpart(tab.str, 0, size)
end

local function make_prefix(l_size, indicator)
  if viewport.lo > 1 then
    viewport.prefix = " %#TablineVisible#…"
    if l_size > 0 then
      local size = l_size - indicator
      if size > 0 then
        if size - viewport.close_icon_width > 0 then
          size = size - viewport.close_icon_width
          local buf = buf_cache[viewport.lo - 1]
          viewport.prefix = focus_on_click(buf) .. viewport.prefix .. resolve_prefix_str(size) .. close_on_click(buf)
        else
          viewport.prefix = viewport.prefix .. string.rep(" ", size)
        end
      end
    end
    prefix_size = l_size
  else
    viewport.prefix = ""
  end
end
local function make_postfix(r_size, indicator)
  if viewport.hi < #tabs_cache then
    viewport.postfix = "%#TablineVisible#… "
    if r_size > 0 then
      local size = r_size - indicator
      if size > 0 then
        viewport.postfix = focus_on_click(buf_cache[viewport.hi + 1]) .. resolve_post_str(size) .. viewport.postfix
      elseif size < 0 then
        viewport.postfix = string.rep(" ", r_size) .. viewport.postfix
      end
    end
  else
    viewport.postfix = ""
  end
end

---@param width integer
local function calc_truncated_tabs(width)
  local l_size = 0
  local r_size = 0

  if viewport.buf_deleted then
    viewport.buf_deleted = false

    if viewport.lo == 1 then
      viewport.hi, r_size = get_viewport_hi(viewport.lo, width)
    else
      local reserved = prefix_size > 0 and (prefix_size + viewport.indicator_left - viewport.indicator_right)
        or (viewport.indicator_left + viewport.indicator_right)
      viewport.hi, r_size = get_viewport_hi(viewport.lo, width - reserved)
      if viewport.hi == #tabs_cache then
        viewport.lo, l_size = get_viewport_lo(viewport.hi, width - viewport.indicator_left)
        l_size = l_size + viewport.indicator_left
      else
        make_postfix(r_size, 0)
        return
      end
    end
  elseif viewport.index > viewport.hi then
    viewport.hi = viewport.index
    local indicator = viewport.indicator_left + (viewport.hi < #tabs_cache and viewport.indicator_right or 0)
    viewport.lo, l_size = get_viewport_lo(viewport.hi, width - indicator)
    l_size = l_size + indicator
  elseif viewport.index < viewport.lo then
    viewport.lo = viewport.index
    if viewport.lo == 1 then
      viewport.hi, r_size = get_viewport_hi(viewport.lo, width)
    else
      local indicator = viewport.indicator_right + (viewport.lo > 1 and viewport.indicator_left or 0)
      viewport.hi, r_size = get_viewport_hi(viewport.lo, width - indicator)
      r_size = r_size + indicator
    end
  elseif viewport.width ~= width then
    viewport.width = width
    local indicator_right = viewport.hi < #tabs_cache and viewport.indicator_right or 0
    local indicator_left = viewport.lo > 1 and viewport.indicator_left or 0
    viewport.hi, r_size = get_viewport_hi(viewport.lo, width - indicator_left - indicator_right)
    r_size = r_size + indicator_left + indicator_right
    if viewport.hi == #tabs_cache then
      indicator_right = 0
      viewport.lo, l_size = get_viewport_lo(viewport.hi, width - indicator_left)
      l_size = l_size + indicator_left
    end

    if viewport.index < viewport.lo then
      viewport.lo = viewport.index
      local indicator = viewport.indicator_right + (viewport.lo > 1 and viewport.indicator_left or 0)
      viewport.hi, r_size = get_viewport_hi(viewport.lo, width - indicator)
      r_size = r_size + indicator
    elseif viewport.index > viewport.hi then
      viewport.hi = viewport.index
      local indicator = viewport.indicator_left + (viewport.hi < #tabs_cache and viewport.indicator_right or 0)
      viewport.lo, l_size = get_viewport_lo(viewport.hi, width - indicator)
      l_size = l_size + indicator
    end
  else
    return
  end

  local indicator_size = (viewport.lo > 1 and viewport.indicator_left or 0)
    + (viewport.hi < #tabs_cache and viewport.indicator_right or 0)

  make_prefix(l_size, indicator_size)
  make_postfix(r_size, indicator_size)
end

function M.make_tabline()
  local start = vim.uv.hrtime()
  local sidebar_width = render_sidebar()
  local width = vim.o.columns - sidebar_width
  if viewport.width ~= width or viewport.changed or viewport.diag_or_input_changed or viewport.buf_deleted then
    if viewport.diag_or_input_changed and not viewport.changed then
      goto build_viewport_str
    end

    if viewport.total_tabs_width > width then
      calc_truncated_tabs(width)
    else
      viewport.lo = 1
      viewport.hi = #tabs_cache
      viewport.prefix = ""
      viewport.postfix = ""
    end

    ::build_viewport_str::

    local sidebar_str = ""
    local hl = ""
    if sidebar_width > 0 then
      hl = sidebar.focus and "%#TablineSidebarFocusedLabel#" or "%#TablineSidebarVisibleLabel#"
      sidebar_str = sidebar.str
    end

    local tabs = { hl, sidebar_str, viewport.prefix }

    for i = viewport.lo, viewport.hi do
      ---@type table
      local tab = tabs_cache[i]
      local buf = buf_cache[i] --[[@as integer]]
      local focused = buf == viewport.buf
      local tab_hl = M.resolve_hl(buf, focused)
      tabs[#tabs + 1] = focus_on_click(buf)
      tabs[#tabs + 1] = tab_hl
      if tab.icon then
        tabs[#tabs + 1] = tab.icon.get(focused, tab_hl)
      end
      tabs[#tabs + 1] = tab.str
      tabs[#tabs + 1] = close_on_click(buf)
    end
    tabs[#tabs + 1] = viewport.postfix
    tabs[#tabs + 1] = viewport.endfix

    viewport.str = table.concat(tabs)

    viewport.changed = false
    viewport.diag_or_input_changed = false
  end
  local elapsed = (vim.uv.hrtime() - start) / 1e6 -- milliseconds
  vim.notify(string.format("tabline: %.3fms", elapsed))
  return viewport.str
end

function M.prev_tab()
  if sidebar.focus then
    return
  end
  local i = get_current_index()
  if i > 1 then
    api.nvim_set_current_buf(buf_cache[i - 1])
    viewport.index = i - 1
  end
end

function M.next_tab()
  if sidebar.focus then
    return
  end
  local i = get_current_index()
  if i < #buf_cache then
    api.nvim_set_current_buf(buf_cache[i + 1])
    viewport.index = i + 1
  end
end

function M.move_to_begin()
  if sidebar.focus then
    return
  end
  local buf = buf_cache[1]
  api.nvim_set_current_buf(buf)
  viewport.index = buf_index[buf]
end

function M.move_to_end()
  if sidebar.focus then
    return
  end
  local buf = buf_cache[#buf_cache]
  api.nvim_set_current_buf(buf)
  viewport.index = buf_index[buf]
end

local function swap(i, j)
  buf_cache[i], buf_cache[j] = buf_cache[j], buf_cache[i]
  tabs_cache[i], tabs_cache[j] = tabs_cache[j], tabs_cache[i]
  buf_index[buf_cache[i]] = i
  buf_index[buf_cache[j]] = j
  viewport.index = buf_index[viewport.buf]
  viewport.changed = true
  schedule_redraw()
end

function M.move_tab_left()
  if sidebar.focus then
    return
  end
  local i = get_current_index()
  if i > 1 then
    swap(i, i - 1)
  end
end

function M.move_tab_right()
  if sidebar.focus then
    return
  end
  local i = get_current_index()
  if i < #buf_cache then
    swap(i, i + 1)
  end
end

function M.move_tab_begin()
  if sidebar.focus then
    return
  end
  local i = get_current_index()
  if i > 1 then
    local b = table.remove(buf_cache, i)
    table.insert(buf_cache, 1, b)
    local t = table.remove(tabs_cache, i)
    table.insert(tabs_cache, 1, t)
    update_buf_index()
    schedule_redraw()
  end
end

function M.move_tab_end()
  if sidebar.focus then
    return
  end
  local i = get_current_index()
  if i < #buf_cache then
    local b = table.remove(buf_cache, i)
    buf_cache[#buf_cache + 1] = b
    local t = table.remove(tabs_cache, i)
    tabs_cache[#tabs_cache + 1] = t
    update_buf_index()
    schedule_redraw()
  end
end

function M.close_tab(bufnr, force)
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
      M.close_tab(bufnr, true)
    elseif choice == 2 then
      M.close_tab(bufnr, true)
    end
    return
  end

  table.remove(buf_cache, idx)
  viewport.hi = math.min(viewport.hi, #buf_cache)

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

  viewport.buf_deleted = true
  resolve_tabs()

  if api.nvim_buf_is_valid(bufnr) then
    api.nvim_buf_delete(bufnr, { force = true })
  end
end

---@return string?
local function get_hex(group, attr)
  local ok, val = pcall(api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or not val then
    return nil
  end
  local n = attr == "fg" and val.fg or val.bg
  return n and string.format("#%06x", n)
end

local function setup_tabline_hl()
  local focused_fg = get_hex("TablineFocused", "fg") or get_hex("Normal", "fg")
  local focused_bg = get_hex("TablineFocused", "bg") or get_hex("CursorLine", "bg") or get_hex("Visual", "bg")
  local visible_fg = get_hex("TablineVisible", "fg") or get_hex("Comment", "fg")
  local visible_bg = get_hex("TablineVisible", "bg") or get_hex("StatusLineNC", "bg") or get_hex("TablineFill", "bg")
  local win_sep_fg = get_hex("WinSeparator", "fg")
  local errors_fg = get_hex("DiagnosticError", "fg")
  local warning_fg = get_hex("DiagnosticWarn", "fg")

  local hl = api.nvim_set_hl
  hl(0, "TablineFocused", { fg = focused_fg, bg = focused_bg })
  hl(0, "TablineVisible", { fg = visible_fg, bg = visible_bg })
  hl(0, "TablineFocusedModified", { fg = focused_fg, bg = focused_bg, italic = true })
  hl(0, "TablineVisibleModified", { fg = visible_fg, bg = visible_bg, italic = true })
  hl(0, "TablineSidebarFocusedLabel", { fg = focused_fg, bg = focused_bg })
  hl(0, "TablineSidebarVisibleLabel", { fg = focused_fg, bg = visible_bg })
  hl(0, "TablineSidebarSep", { fg = win_sep_fg, bg = visible_bg })
  hl(0, "TablineFocusedDiagError", { fg = errors_fg, bg = focused_bg })
  hl(0, "TablineVisibleDiagError", { fg = errors_fg, bg = visible_bg })
  hl(0, "TablineFocusedDiagWarn", { fg = warning_fg, bg = focused_bg })
  hl(0, "TablineVisibleDiagWarn", { fg = warning_fg, bg = visible_bg })
  hl(0, "TablineFocusedDiagModifiedError", { fg = errors_fg, bg = focused_bg, italic = true })
  hl(0, "TablineVisibleDiagModifiedError", { fg = errors_fg, bg = visible_bg, italic = true })
  hl(0, "TablineFocusedDiagModifiedWarn", { fg = warning_fg, bg = focused_bg, italic = true })
  hl(0, "TablineVisibleDiagModifiedWarn", { fg = warning_fg, bg = visible_bg, italic = true })
end

local get_icon_fn = {
  ["mini.icons"] = function(ext)
    local icon, hl = M.icons.provider.get("extension", ext)
    return icon, get_hex(hl, "fg")
  end,
  ["nvim-web-devicons"] = function(ext)
    return M.icons.provider.get_icon_color(nil, ext, { default = true })
  end,
}

M.get_icon_hl = function(ext, color, focused)
  if M.icons.no_hl then
    return ""
  end
  local key = focused and "f_" .. ext or "v_" .. ext
  if not icon_hl_cache[key] then
    local bg = focused and (get_hex("TablineFocused", "bg") or get_hex("Normal", "bg"))
      or (get_hex("TablineVisible", "bg") or get_hex("Normal", "bg"))
    local name = (focused and "TablineFocusedIcon_" or "TablineVisibleIcon_") .. ext
    api.nvim_set_hl(0, name, { fg = color, bg = bg })
    icon_hl_cache[key] = "%#" .. name .. "#"
  end
  return icon_hl_cache[key]
end

local ignore_buftypes = {
  ["quickfix"] = true,
  ["terminal"] = true,
}

local function setup_autocmds()
  api.nvim_create_autocmd("BufEnter", {
    callback = function()
      local b = api.nvim_get_current_buf()
      if not bo[b].buflisted or ignore_buftypes[bo[b].buftype] then
        return
      end
      vim.schedule(function()
        if not api.nvim_buf_is_valid(b) or buf_index[b] then
          return
        end
        buf_cache[#buf_cache + 1] = b
        resolve_tabs()
        schedule_redraw()
      end)
    end,
  })

  api.nvim_create_autocmd("BufDelete", {
    callback = function(ev)
      local bufnr = ev.buf
      local idx = buf_index[bufnr]
      if not idx then
        return
      end

      table.remove(buf_cache, idx)
      viewport.hi = math.min(viewport.hi, #buf_cache)

      ---@type integer?
      local replacement = buf_cache[idx] or buf_cache[idx - 1]
      if replacement then
        local cur_win = api.nvim_get_current_win()
        for _, win in ipairs(fn.win_findbuf(bufnr)) do
          api.nvim_win_set_buf(win, replacement)
          M.update_cursor_line_hl(cur_win, win)
        end
      end

      buf_index[bufnr] = nil
      diag_cache[bufnr] = nil

      viewport.buf_deleted = true
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
      schedule_redraw()
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
      sidebar.winnr = nvim_tree_view.get_winnr()
      sidebar.focus = api.nvim_get_current_win() == sidebar.winnr
      viewport.buf = sidebar.focus and -1 or api.nvim_get_current_buf()

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
    M.close_tab(0, false)
  end, { silent = true, nowait = true })
  map("n", "<c-x>", function()
    M.close_tab(0, true)
  end, { silent = true, nowait = true })
end

_G.make_tabline = M.make_tabline
vim.opt.tabline = "%!v:lua.make_tabline()"
vim.opt.showtabline = 2

_G.CloseTab = function(bufnr)
  M.close_tab(bufnr, false)
end

_G.FocusTab = function(bufnr, _clicks, button)
  if button == "l" then
    api.nvim_set_current_buf(bufnr)
    viewport.index = buf_index[bufnr]
  elseif button == "m" then
    M.close_tab(bufnr, false)
  end
end

local config = {
  focus_on_click = true,
  unique_names = true,
  -- close_icon = "",
  -- close_icon = "󰅖 ",
  close_icon = "X ",

  icons = {
    enabled = true,
    no_hl = true,
    provider = "mini.icons",
  },

  sidebar = {
    label = "Explorer",
    -- label = "Files",
    separator = "│",
    -- separator = " ",
  },
}

function M.setup(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(config), opts or {})
  M.icons = {
    enabled = false,
  }
  if config.icons.enabled then
    M.icons.enabled = config.icons.enabled
    M.icons.no_hl = config.icons.no_hl or false

    -- "mini.icons"|"nvim-web-devicons" default: "mini.icons"
    local provider = "mini.icons"
    if config.icons.provider and config.icons.provider ~= "" then
      provider = config.icons.provider
    end
    M.icons.provider = require(provider)
    M.get_icon = get_icon_fn[provider]
  end

  if config.close_icon then
    M.close_icon = config.close_icon
    viewport.close_icon_width = vim.api.nvim_strwidth(config.close_icon)
  end

  if config.sidebar.separator then
    sidebar.separator = config.sidebar.separator
    sidebar.separator_width = strwidth(config.sidebar.separator)
  end

  if config.sidebar.label then
    sidebar.label = config.sidebar.label
    sidebar.label_width = strwidth(sidebar.label)
  end

  if config.focus_on_click then
    M.focus_on_click = config.focus_on_click
  end

  if config.unique_names then
    M.unique_names = config.unique_names
  end

  init_bufs()
  setup_autocmds()
  setup_keymaps()
  setup_tabline_hl()

  if opts and type(opts.update_cursor_line_hl) == "function" then
    M.update_cursor_line_hl = opts.update_cursor_line_hl
  end
end

return M
