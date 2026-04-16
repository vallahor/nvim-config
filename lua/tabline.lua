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
---@field indicator_left string
---@field indicator_right string
---@field indicator_left_width integer
---@field indicator_right_width integer
---@field indicator_start string
---@field indicator_end string
---@field indicator_start_width integer
---@field indicator_end_width integer
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
  is_in_small_size = true,
  lo = 1,
  hi = 1,
  buf = 1,
  index = 1,
  prefix = "",
  postfix = "",
  endfix = "%#TablineFill#",
  indicator_left = "",
  indicator_right = "",
  indicator_left_width = 2,
  indicator_right_width = 2,
  indicator_start = "",
  indicator_end = "",
  indicator_start_width = 2,
  indicator_end_width = 2,
  total_tabs_width = 0,
  close_icon_width = 0,
}

---@class Sidebar
---@field rendered_visible string
---@field rendered_focused string
---@field label string
---@field label_width integer
---@field separator_wdith integer
---@field separator string
---@field width integer
---@field focus boolean
---@field winnr integer?
local sidebar = {
  rendered_visible = "",
  rendered_focused = "",
  label = "",
  label_width = 0,
  separator = "",
  separator_width = 0,
  width = 0,
  focus = false,
  winnr = nil,
}

local sidebar_filetypes = { ["NvimTree"] = true }

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
---@field tail string
---@field ext string
---@field width integer
---@field strlen integer
---@field strwidth integer
---@field modified boolean
---@field icon Icon?
---@field rendered_visible string?
---@field rendered_focused string?
---@field update function

---@type {[integer]: Tab}
local tabs_cache = {}

local icons_ext_cache = {}
local icons_hl_cache = {}

---@type table<string, {count: integer, bufs: table<integer, boolean?>}>
local tabs_repeated_names_buf_cache = {}

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

---@return string?
local function get_hex(group, attr)
  local ok, val = pcall(api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or not val then
    return nil
  end
  local n = attr == "fg" and val.fg or val.bg
  return n and string.format("#%06x", n)
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
  buf_index = {}
  viewport.total_tabs_width = 0
  for i, b in ipairs(buf_cache) do
    buf_index[b] = i
    viewport.total_tabs_width = viewport.total_tabs_width + tabs_cache[i].width
  end
  if not sidebar.focus and buf_index[viewport.buf] then
    viewport.index = buf_index[viewport.buf]
  end
  viewport.changed = true
end

local function resolve_buf_name(buf)
  local bufname = api.nvim_buf_get_name(buf)
  local tail = bufname ~= "" and fnamemodify(bufname, ":t") or "[No Name]"
  local ext = bufname ~= "" and fnamemodify(bufname, ":e") or ""
  return bufname, tail, ext
end

local function resolve_buf_repeated_names(bufname, tail)
  if tabs_repeated_names_buf_cache[tail] and tabs_repeated_names_buf_cache[tail].count > 1 and bufname ~= "" then
    return fnamemodify(bufname, ":~:."):gsub("^%./", "")
  end
  return tail
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

local function icon_cache_insert(ext)
  if icons_ext_cache[ext] then
    icons_ext_cache[ext].count = icons_ext_cache[ext].count + 1
    return icons_ext_cache[ext].icon, icons_ext_cache[ext].color
  end
  local icon, color = M.get_icon(ext)
  icons_ext_cache[ext] = { icon = icon, color = color, count = 1 }
  return icon, color
end

local function icon_cache_remove(ext)
  if not icons_ext_cache[ext] then
    return
  end
  icons_ext_cache[ext].count = icons_ext_cache[ext].count - 1
  if icons_ext_cache[ext].count == 0 then
    icons_ext_cache[ext] = nil
    icons_hl_cache["f_" .. ext] = nil
    icons_hl_cache["v_" .. ext] = nil
  end
end

local function make_tab_icon(ext)
  if not M.icons.enabled then
    return nil
  end
  local icon, color = icon_cache_insert(ext)
  if icon == "" then
    icon_cache_remove(ext)
    return nil
  end
  icon = " " .. icon
  return {
    str = icon,
    width = api.nvim_strwidth(icon),
    get = function(focused, hl)
      return M.get_icon_hl(ext, color, focused) .. icon .. hl
    end,
  }
end

local function build_tab(buf, tail, display, ext)
  display = " " .. display .. " "
  local display_width = api.nvim_strwidth(display)
  local tab_icon = make_tab_icon(ext)
  local width = display_width + viewport.close_icon_width + (tab_icon and tab_icon.width or 0)

  local tab = {
    str = display,
    tail = tail,
    ext = ext,
    width = width,
    icon = tab_icon,
    strlen = fn.strcharlen(display),
    strwidth = display_width,
    rendered_visible = nil,
    rendered_focused = nil,
  }
  tab.update = function()
    local click = focus_on_click(buf)
    local close = close_on_click(buf)
    local hl_visible, hl_focused = M.resolve_hl(buf)

    tab.rendered_visible =
      table.concat({ click, hl_visible, tab_icon and tab_icon.get(false, hl_visible) or "", display, close })
    tab.rendered_focused =
      table.concat({ click, hl_focused, tab_icon and tab_icon.get(true, hl_focused) or "", display, close })
  end
  tab.update()
  return tab
end

local function refresh_tab(index, buf, tail)
  if not tabs_cache[index] then
    return
  end
  local bufname, _, ext = resolve_buf_name(buf)
  local display = resolve_buf_repeated_names(bufname, tail)
  local tab = build_tab(buf, tail, display, ext)
  tabs_cache[index] = tab
end

local function repeated_names_remove(buf, tail)
  if not tabs_repeated_names_buf_cache[tail] then
    return
  end
  tabs_repeated_names_buf_cache[tail].bufs[buf] = nil
  tabs_repeated_names_buf_cache[tail].count = tabs_repeated_names_buf_cache[tail].count - 1
  if tabs_repeated_names_buf_cache[tail].count == 0 then
    tabs_repeated_names_buf_cache[tail] = nil
  else
    for b, _ in pairs(tabs_repeated_names_buf_cache[tail].bufs) do
      if b ~= buf then
        refresh_tab(buf_index[b], b, tail)
      end
    end
  end
end

local function repeated_names_insert(buf, tail)
  tabs_repeated_names_buf_cache[tail] = tabs_repeated_names_buf_cache[tail] or { count = 0, bufs = {} }
  if not tabs_repeated_names_buf_cache[tail].bufs[buf] then
    tabs_repeated_names_buf_cache[tail].bufs[buf] = true
    tabs_repeated_names_buf_cache[tail].count = tabs_repeated_names_buf_cache[tail].count + 1
    if tabs_repeated_names_buf_cache[tail].count > 1 then
      for b, _ in pairs(tabs_repeated_names_buf_cache[tail].bufs) do
        if b ~= buf then
          refresh_tab(buf_index[b], b, tail)
        end
      end
    end
  end
end

local function resolve_update_tab(buf)
  local index = buf_index[buf]
  if not index then
    return
  end
  tabs_cache[index] = M.make_tab(buf)
  update_buf_index()
end

local function resolve_update_tab_unique_names(buf)
  local index = buf_index[buf]
  if not index then
    return
  end
  local tail = tabs_cache[index].tail
  local bufname, new_tail, ext = resolve_buf_name(buf)
  if tail ~= new_tail then
    repeated_names_remove(buf, tail)
    repeated_names_insert(buf, new_tail)
  end
  local display = resolve_buf_repeated_names(bufname, new_tail)
  local tab = build_tab(buf, new_tail, display, ext)
  tabs_cache[index] = tab
  update_buf_index()
end

local function remove_buf_from_tabline(bufnr)
  local index = buf_index[bufnr]
  if not index then
    return
  end

  local tab = tabs_cache[index]
  if tab.icon then
    icon_cache_remove(tab.ext)
  end
  if M.unique_names then
    repeated_names_remove(bufnr, tab.tail)
  end

  table.remove(tabs_cache, index)
  table.remove(buf_cache, index)

  ---@type integer?
  local replacement = buf_cache[index] or buf_cache[index - 1]
  if replacement then
    local cur_win = api.nvim_get_current_win()
    for _, win in ipairs(fn.win_findbuf(bufnr)) do
      api.nvim_win_set_buf(win, replacement)
      M.update_cursor_line_hl(cur_win, win)
    end
  end

  diag_cache[bufnr] = nil

  viewport.buf_deleted = true
  update_buf_index()
end

local function make_tab(buf)
  local _, tail, ext = resolve_buf_name(buf)
  return build_tab(buf, tail, tail, ext)
end

local function make_tab_unique_names(buf)
  local bufname, tail, ext = resolve_buf_name(buf)
  repeated_names_insert(buf, tail)
  local display = resolve_buf_repeated_names(bufname, tail)
  return build_tab(buf, tail, display, ext)
end

local function insert_buf_into_tabline(buf)
  local tab = M.make_tab(buf)
  table.insert(buf_cache, buf)
  table.insert(tabs_cache, tab)
  viewport.buf = buf
  update_buf_index()
end

local function init_bufs()
  for _, b in ipairs(api.nvim_list_bufs()) do
    if bo[b].buflisted then
      insert_buf_into_tabline(b)
    end
  end
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

local function sidebar_label_start(pad)
  local pad_left = math.ceil(0)
  local pad_right = math.floor(pad)
  return pad_left, pad_right
end

local function sidebar_label_mid(pad)
  local pad_left = math.ceil(pad / 2)
  local pad_right = math.floor(pad / 2)
  return pad_left, pad_right
end
local function sidebar_label_end(pad)
  local pad_left = math.ceil(pad)
  local pad_right = math.floor(0)
  return pad_left, pad_right
end

---@return integer
local function render_sidebar()
  if not sidebar.winnr or not api.nvim_win_is_valid(sidebar.winnr) then
    return 0
  end
  local sidebar_width = api.nvim_win_get_width(sidebar.winnr)
  if sidebar_width ~= sidebar.width then
    sidebar.width = sidebar_width
    local total_pad = math.max(0, sidebar_width - sidebar.label_width)
    local pad_left, pad_right = M.sidebar_label_position(total_pad)
    local spaces_left = make_spaces(cached_pad_left, sidebar_spaces_left, pad_left)
    local spaces_right = make_spaces(cached_pad_right, sidebar_spaces_right, pad_right)
    local label = spaces_left .. sidebar.label .. spaces_right
    local label_width = sidebar.label_width + pad_left + pad_right

    if label_width > sidebar_width then
      label = fn.strcharpart(label, 0, sidebar_width)
    end

    sidebar.rendered_focused = table.concat({
      "%#TablineSidebarFocusedLabel#",
      label,
      "%#TablineSidebarSep#",
      sidebar.separator,
    })
    sidebar.rendered_visible = table.concat({
      "%#TablineSidebarVisibleLabel#",
      label,
      "%#TablineSidebarSep#",
      sidebar.separator,
    })
  end
  return sidebar_width + sidebar.separator_width
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
---@return string, string
M.resolve_hl = function(b)
  if not b then
    return "", ""
  end
  local modified = bo[b].modified
  local cached = diag_cache[b] or vim.diagnostic.count(b, diag_filter)
  local sev = cached and (cached[vim.diagnostic.severity.ERROR] or 0) > 0 and 1
    or (cached[vim.diagnostic.severity.WARN] or 0) > 0 and 2
    or nil
  if sev then
    local t = diag_hl_map[sev][modified and 2 or 1]
    return t[1], t[2] -- visible, focused
  end
  if modified then
    return "%#TablineVisibleModified#", "%#TablineFocusedModified#"
  end
  return "%#TablineVisible#", "%#TablineFocused#"
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
  local pad = string.rep(" ", math.max(0, size - tab.strwidth))
  return pad .. M.resolve_hl(buf, false) .. fn.strcharpart(tab.str, tab.strlen - size, size)
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
  local pad = string.rep(" ", math.max(0, size - tab.strwidth))
  return tab_hl .. icon .. tab_hl .. fn.strcharpart(tab.str, 0, size) .. pad
end

local function make_prefix(left_remaining, indicator)
  if viewport.lo > 1 then
    viewport.prefix = viewport.indicator_left
    if left_remaining > 0 then
      local size = left_remaining - indicator
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
    prefix_size = left_remaining
  else
    viewport.prefix = viewport.indicator_start
  end
end

local function make_postfix(right_remaining, indicator)
  if viewport.hi < #tabs_cache then
    viewport.postfix = viewport.indicator_right
    if right_remaining > 0 then
      local size = right_remaining - indicator
      if size > 0 then
        viewport.postfix = focus_on_click(buf_cache[viewport.hi + 1]) .. resolve_post_str(size) .. viewport.postfix
      elseif size < 0 then
        viewport.postfix = "%#TablineVisible#" .. string.rep(" ", right_remaining) .. viewport.postfix
      end
    end
  else
    viewport.postfix = viewport.indicator_end
  end
end

local function compute_left_indicator()
  return viewport.lo > 1 and viewport.indicator_left_width or 0
end

local function compute_right_indicator()
  return viewport.hi < #tabs_cache and viewport.indicator_right_width or 0
end

local function compute_both_indicators()
  return compute_left_indicator() + compute_right_indicator()
end

local function compute_left_remain_from_end(width)
  local indicator_left = compute_left_indicator()
  local indicator_right = viewport.indicator_end_width
  local indicators = indicator_left + indicator_right
  local lo, left_remaining = get_viewport_lo(#tabs_cache, width - indicators)
  return lo, left_remaining + indicator_left
end

local function compute_right_remain_from_end(width)
  local indicator_left = viewport.indicator_start_width
  local indicator_right = compute_right_indicator()
  local indicators = indicator_left + indicator_right
  local hi, right_remaining = get_viewport_hi(1, width - indicators)
  return hi, right_remaining + indicator_right
end

local function gen_prefix_postfix(left_remaining, right_remaining)
  local indicator_size = compute_both_indicators()

  make_prefix(left_remaining, indicator_size)
  make_postfix(right_remaining, indicator_size)
end

local function handle_buf_delete(width)
  local left_remaining = 0
  local right_remaining = 0
  viewport.buf_deleted = false

  if viewport.lo == 1 then
    local indicator_left = viewport.indicator_start_width
    local indicator_right = compute_right_indicator()
    local indicators = indicator_left + indicator_right
    viewport.hi, right_remaining = get_viewport_hi(viewport.lo, width - indicators)
    right_remaining = right_remaining + indicator_right
  else
    local reserved = prefix_size > 0 and (prefix_size + viewport.indicator_left_width - viewport.indicator_right_width)
      or (viewport.indicator_left_width + viewport.indicator_right_width)
    viewport.hi, right_remaining = get_viewport_hi(viewport.lo, width - reserved)
    if viewport.hi == #tabs_cache then
      local indicator_left = viewport.indicator_left_width
      viewport.lo, left_remaining = get_viewport_lo(viewport.hi, width - indicator_left - viewport.indicator_end_width)
      left_remaining = left_remaining + indicator_left
    else
      make_postfix(right_remaining, 0)
      return
    end
  end

  gen_prefix_postfix(left_remaining, right_remaining)
end

local function handle_index_before(width)
  local left_remaining = 0
  local right_remaining = 0
  viewport.lo = viewport.index
  if viewport.lo == 1 then
    viewport.hi, right_remaining = compute_right_remain_from_end(width)
  else
    local indicator = viewport.indicator_right_width + compute_left_indicator()
    viewport.hi, right_remaining = get_viewport_hi(viewport.lo, width - indicator)
    right_remaining = right_remaining + indicator
    left_remaining = indicator
  end

  gen_prefix_postfix(left_remaining, right_remaining)
end

local function handle_index_after(width)
  local left_remaining = 0
  local right_remaining = 0
  viewport.hi = viewport.index
  if viewport.hi == #tabs_cache then
    viewport.lo, left_remaining = compute_left_remain_from_end(width)
  else
    local indicator = viewport.indicator_left_width + compute_right_indicator()
    viewport.lo, left_remaining = get_viewport_lo(viewport.hi, width - indicator)
    left_remaining = left_remaining + indicator
    right_remaining = indicator
  end

  gen_prefix_postfix(left_remaining, right_remaining)
end

local function handle_width_change(width)
  local left_remaining = 0
  local right_remaining = 0
  viewport.width = width
  if viewport.lo == 1 then
    viewport.hi, right_remaining = compute_right_remain_from_end(width)
  else
    if viewport.hi == #tabs_cache then
      viewport.lo, left_remaining = compute_left_remain_from_end(width)
    end

    local indicator_left_size = compute_left_indicator()
    local indicator_right_size = compute_right_indicator()
    local indicators = indicator_left_size + indicator_right_size

    if viewport.index <= viewport.lo and viewport.lo < viewport.hi then
      if viewport.hi == #tabs_cache then
        indicators = viewport.indicator_left_width + viewport.indicator_right_width
      end
      viewport.lo = viewport.index
      viewport.hi, right_remaining = get_viewport_hi(viewport.lo, width - indicators)
      if viewport.hi == #tabs_cache then
        viewport.lo, left_remaining = compute_left_remain_from_end(width)
      else
        left_remaining = indicators
        right_remaining = right_remaining + indicators
      end
    elseif viewport.hi < #tabs_cache then
      if viewport.index > viewport.hi then
        viewport.hi = viewport.index
      end
      viewport.lo, left_remaining = get_viewport_lo(viewport.hi, width - indicators)
      if viewport.lo == 1 then
        viewport.hi, right_remaining = compute_right_remain_from_end(width)
      else
        left_remaining = left_remaining + indicators
        right_remaining = indicators
      end
    end
  end

  gen_prefix_postfix(left_remaining, right_remaining)
end

---@param width integer
local function calc_truncated_tabs(width)
  if viewport.buf_deleted then
    handle_buf_delete(width)
  elseif viewport.index > viewport.hi then
    handle_index_after(width)
  elseif viewport.index < viewport.lo then
    handle_index_before(width)
  elseif viewport.width ~= width then
    handle_width_change(width)
  end
end

function M.tabline_make()
  local start = vim.uv.hrtime()
  local sidebar_width = render_sidebar()
  local width = vim.o.columns - sidebar_width
  if
    viewport.width ~= width
    or viewport.changed
    or viewport.diag_or_input_changed
    or viewport.buf_deleted
    or viewport.is_in_small_size
  then
    -- Mitigate the situation where the find-file of nvim_tree
    -- open-file with `{focus = false}
    -- runs vim.cmd("noautocmd wincmd p")
    -- which not trigger the leaving and reenter in the buffer.
    -- without calling the autocmd events
    if api.nvim_get_current_win() ~= sidebar.winnr and sidebar.focus then
      sidebar.focus = false
      viewport.buf = buf_cache[viewport.index]
    end

    local tab_str, tab_shrink = "", false
    local indicators = compute_both_indicators()
    local current_tab = tabs_cache[viewport.index]

    if viewport.diag_or_input_changed and not viewport.changed then
      viewport.diag_or_input_changed = false
      goto build_viewport_str
    end

    if current_tab and current_tab.width > width - indicators then
      local available = width - indicators - viewport.close_icon_width
      viewport.lo = viewport.index
      viewport.hi = viewport.index
      if viewport.hi == #tabs_cache then
        viewport.prefix = viewport.indicator_left
        viewport.postfix = viewport.indicator_end
        available = available - viewport.indicator_end_width
      elseif viewport.lo == 1 then
        viewport.prefix = viewport.indicator_start
        viewport.postfix = viewport.indicator_right
        available = available - viewport.indicator_start_width
      else
        viewport.prefix = viewport.indicator_left
        viewport.postfix = viewport.indicator_right
      end

      tab_shrink = true

      local buf = buf_cache[viewport.index]
      local focused = buf == viewport.buf
      local tab_visible_hl, tab_focused_hl = M.resolve_hl(buf)
      local tab_hl = focused and tab_focused_hl or tab_visible_hl

      local pad = string.rep(" ", math.max(0, available - current_tab.strlen))

      tab_str = table.concat({
        tab_hl,
        focus_on_click(buf),
        fn.strcharpart(current_tab.str, current_tab.strlen - available, available),
        close_on_click(buf),
        "%#TablineVisible#",
        pad,
      })
    elseif viewport.total_tabs_width > width then
      calc_truncated_tabs(width)
    else
      viewport.lo = 1
      viewport.hi = #tabs_cache
      viewport.prefix = viewport.indicator_start
      viewport.postfix = ""
    end

    ::build_viewport_str::

    local sidebar_str = ""
    if sidebar_width > 0 then
      sidebar_str = sidebar.focus and sidebar.rendered_focused or sidebar.rendered_visible
    end

    local tabs = { sidebar_str, viewport.prefix }

    if tab_shrink then
      tabs[#tabs + 1] = tab_str
    else
      for i = viewport.lo, viewport.hi do
        local tab = tabs_cache[i]
        local buf = buf_cache[i]
        local focused = buf == viewport.buf
        tabs[#tabs + 1] = focused and tab.rendered_focused or tab.rendered_visible
      end
    end

    tabs[#tabs + 1] = viewport.postfix
    tabs[#tabs + 1] = viewport.endfix

    viewport.str = table.concat(tabs)

    viewport.changed = false
  end
  viewport.width = width

  local elapsed = (vim.uv.hrtime() - start) / 1e6 -- milliseconds
  -- vim.notify(string.format("tabline: %.3fms", elapsed))
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

  remove_buf_from_tabline(bufnr)

  if api.nvim_buf_is_valid(bufnr) then
    api.nvim_buf_delete(bufnr, { force = true })
  end
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

M.get_icon_hl = function(ext, color, focused)
  if M.icons.no_hl then
    return ""
  end
  local key = focused and "f_" .. ext or "v_" .. ext
  if not icons_hl_cache[key] then
    local bg = focused and (get_hex("TablineFocused", "bg") or get_hex("Normal", "bg"))
      or (get_hex("TablineVisible", "bg") or get_hex("Normal", "bg"))
    local name = (focused and "TablineFocusedIcon_" or "TablineVisibleIcon_") .. ext
    api.nvim_set_hl(0, name, { fg = color, bg = bg })
    icons_hl_cache[key] = "%#" .. name .. "#"
  end
  return icons_hl_cache[key]
end

local ignore_buftypes = {
  ["quickfix"] = true,
  ["nofile"] = true,
  ["terminal"] = true,
  ["prompt"] = true,
}

local ignore_filetypes = {
  ["qf"] = true,
}

local function setup_autocmds()
  api.nvim_create_autocmd("BufWinEnter", {
    callback = function(ev)
      local buf = ev.buf
      if
        not api.nvim_buf_is_valid(buf)
        or not bo[buf].buflisted
        or ignore_buftypes[bo[buf].buftype]
        or ignore_filetypes[bo[buf].filetype]
      then
        return
      end
      if buf_index[buf] then
        return
      end
      insert_buf_into_tabline(buf)
      schedule_redraw()
    end,
  })

  api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function(ev)
      if sidebar_filetypes[bo[ev.buf].filetype] then
        local winnr = api.nvim_get_current_win()
        sidebar.winnr = winnr
        sidebar.focus = true
        viewport.buf = -1
      else
        sidebar.focus = false
        viewport.buf = ev.buf
        if not sidebar.focus and buf_index[viewport.buf] then
          viewport.index = buf_index[viewport.buf]
        end
      end

      viewport.changed = true
      schedule_redraw()
    end,
  })

  api.nvim_create_autocmd("BufDelete", {
    callback = function(ev)
      local bufnr = ev.buf
      local idx = buf_index[bufnr]
      if not idx then
        return
      end
      remove_buf_from_tabline(bufnr)
    end,
  })

  api.nvim_create_autocmd("BufModifiedSet", {
    callback = function(ev)
      local index = buf_index[ev.buf]
      if not index then
        return
      end
      local tab = tabs_cache[index]
      local modified = bo[ev.buf].modified
      if tab.modified ~= modified then
        tabs_cache[index].update()
        viewport.diag_or_input_changed = true
        schedule_redraw()
      end
    end,
  })

  api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function(ev)
      local index = buf_index[ev.buf]
      if not index then
        return
      end
      diag_cache[ev.buf] = nil
      tabs_cache[index].update()
      viewport.diag_or_input_changed = true
      schedule_redraw()
    end,
  })

  api.nvim_create_autocmd("BufFilePost", {
    callback = function(ev)
      M.resolve_update_tab(ev.buf)
    end,
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
    M.close_tab(0, false)
  end, { silent = true, nowait = true })
  map("n", "<c-x>", function()
    M.close_tab(0, true)
  end, { silent = true, nowait = true })
end

_G.make_tabline = M.tabline_make
vim.opt.tabline = "%!v:lua.make_tabline()"
vim.opt.showtabline = 2

_G.CloseTab = function(bufnr)
  M.close_tab(bufnr, false)
end

-- @check maybe change to click tab
-- and give more options to do
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
  close_icon = "󰅖 ",
  -- close_icon = "X ",

  -- maybe highlight?
  indicator_left = " …",
  indicator_right = "… ",
  -- indicator_left = "<<",
  -- indicator_right = ">>",
  indicator_start = "*",
  indicator_end = "*",

  icons = {
    enabled = true,
    no_hl = false,
    provider = "mini.icons", -- "mini.icons"|"nvim-web-devicons" default: "mini.icons"
  },

  sidebar = {
    label = "Explorer",
    label_position = "mid", -- "start"|"mid"|"end"
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
    M.icons.no_hl = config.icons.no_hl

    local provider = config.icons.provider
    M.icons.provider = require(provider)
    M.get_icon = get_icon_fn[provider]
  end

  if config.close_icon then
    M.close_icon = config.close_icon
    viewport.close_icon_width = api.nvim_strwidth(config.close_icon)
  end

  sidebar.separator = config.sidebar.separator
  sidebar.separator_width = strwidth(config.sidebar.separator)

  if config.sidebar.label_position == "start" then
    M.sidebar_label_position = sidebar_label_start
  elseif config.sidebar.label_position == "mid" then
    M.sidebar_label_position = sidebar_label_mid
  elseif config.sidebar.label_position == "end" then
    M.sidebar_label_position = sidebar_label_end
  else
    M.sidebar_label_position = sidebar_label_mid
  end

  sidebar.label = config.sidebar.label
  sidebar.label_width = strwidth(sidebar.label)

  if config.focus_on_click then
    M.focus_on_click = config.focus_on_click
  end

  M.unique_names = config.unique_names
  M.make_tab = config.unique_names and make_tab_unique_names or make_tab
  M.resolve_update_tab = config.unique_names and resolve_update_tab_unique_names or resolve_update_tab

  viewport.indicator_left = "%#TablineVisible#" .. config.indicator_left
  viewport.indicator_right = "%#TablineVisible#" .. config.indicator_right

  viewport.indicator_left_width = api.nvim_strwidth(config.indicator_left)
  viewport.indicator_right_width = api.nvim_strwidth(config.indicator_right)

  viewport.indicator_start = "%#TablineVisible#" .. config.indicator_start
  viewport.indicator_end = "%#TablineVisible#" .. config.indicator_end

  viewport.indicator_start_width = api.nvim_strwidth(config.indicator_start)
  viewport.indicator_end_width = api.nvim_strwidth(config.indicator_end)

  init_bufs()
  setup_autocmds()
  setup_keymaps()
  setup_tabline_hl()

  if opts and type(opts.update_cursor_line_hl) == "function" then
    M.update_cursor_line_hl = opts.update_cursor_line_hl
  end
end

return M
