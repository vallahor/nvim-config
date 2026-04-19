local bit = require("bit")
local band, bor, bnot, lshift, rshift = bit.band, bit.bor, bit.bnot, bit.lshift, bit.rshift

local api, fn, bo = vim.api, vim.fn, vim.bo
local strwidth, fnamemodify = fn.strwidth, fn.fnamemodify

local STATES = {
  VISIBLE = lshift(1, 0), -- 1
  FOCUSED = lshift(1, 1), -- 2
  MODIFIED = lshift(1, 2), -- 4
  ERROR = lshift(1, 3), -- 8
  WARN = lshift(1, 4), -- 16
  HINT = lshift(1, 5), -- 32
  INFO = lshift(1, 6), -- 64
}

local M = {}

local config = {
  focus_on_click = true,

  tabs = {
    { text = "" },
  },

  severity_filter = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severit },
  dynamic = { diagnostics = false },

  indicator_left = " …",
  indicator_right = "… ",

  indicator_start = "*",
  indicator_end = "*",

  no_diagnostic = false,
  no_modified = false,

  icons = {
    enabled = true,
    no_hl = false,
    provider = "mini.icons", -- "mini.icons"|"nvim-web-devicons" default: "mini.icons"
  },

  sidebar = {
    enabled = true,
    label = "Explorer",
    label_position = "mid", -- "start"|"mid"|"end"
    separator = "│",
    filetypes = { "NvimTree", "neo-tree" }, -- Default with ["NvimTree", "neo-tree"]
  },
}

M.update_cursor_line_hl = function(_, _) end

---@class Viewport
---@field str string
---@field width integer
---@field sidebar_width integer
---@field changed boolean
---@field size_changed boolean
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
local viewport = {
  str = "",
  width = 0,
  sidebar_width = 0,
  changed = true,
  size_changed = true,
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
}

-- @CHECK: If its in the right side ......... heheheh you know.
---@class Sidebar
---@field enabled boolean
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
  enabled = true,
  winnr = nil,
}

local sidebar_filetypes = {}

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
---@field str_width integer
---@field modified integer
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

local prefix_size = 0

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

M.dynamic = {
  diagnostics = {},
}

local function init_dynamic(dynamic)
  if not dynamic then
    return
  end

  local severity_states = { STATES.ERROR, STATES.WARN, STATES.HINT, STATES.INFO }

  local function mark_diags(flag)
    for _, severity in ipairs(severity_states) do
      M.dynamic.diagnostics[flag + severity] = true
      M.dynamic.diagnostics[flag + STATES.MODIFIED + severity] = true
    end
  end

  if dynamic.diagnostics then
    mark_diags(STATES.VISIBLE)
    mark_diags(STATES.FOCUSED)
    return
  end

  if dynamic.visible and dynamic.visible.diagnostics then
    mark_diags(STATES.VISIBLE)
  elseif dynamic.focused and dynamic.focused.diagnostics then
    mark_diags(STATES.FOCUSED)
  end
end

local hl_cache = {}

local function to_int(color)
  if type(color) == "string" then
    return tonumber(color:gsub("^#", ""), 16)
  end
  return color
end

M.derive_hl = function(group, overrides)
  local ok, val = pcall(api.nvim_get_hl, 0, { name = group, link = false })
  if not ok then
    return group
  end

  local attrs = {
    fg = to_int(overrides.fg) or val.fg,
    bg = to_int(overrides.bg) or val.bg,
    sp = to_int(overrides.sp) or val.sp,
    bold = overrides.bold or val.bold,
    italic = overrides.italic or val.italic,
    underline = overrides.underline or val.underline,
    undercurl = overrides.undercurl or val.undercurl,
    strikethrough = overrides.strikethrough or val.strikethrough,
  }

  local key = (attrs.fg or 0)
    .. "|"
    .. (attrs.bg or 0)
    .. "|"
    .. (attrs.sp or 0)
    .. "|"
    .. (attrs.bold and "b" or "")
    .. (attrs.italic and "i" or "")
    .. (attrs.underline and "u" or "")
    .. (attrs.undercurl and "c" or "")
    .. (attrs.strikethrough and "s" or "")

  local hl_name = hl_cache[key]
  if hl_name then
    return hl_name
  end

  local name = "Tbl"
    .. (attrs.fg or 0)
    .. (attrs.bg or 0)
    .. (attrs.bold and "b" or "")
    .. (attrs.italic and "i" or "")
    .. (attrs.underline and "u" or "")
    .. (attrs.undercurl and "c" or "")
    .. (attrs.strikethrough and "s" or "")

  api.nvim_set_hl(0, name, attrs)
  hl_cache[key] = name
  return name
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

local click_handlers = {}

local function focus_on_click(bufnr)
  if M.focus_on_click then
    return "%" .. bufnr .. "@v:lua.FocusTab@"
  end
  return ""
end

local function on_click(bufnr, index, text)
  return "%" .. (lshift(bufnr, 16) + index) .. "@v:lua.OnClick@" .. text .. "%X"
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
  if bufname == "" then
    return "", "[No Name]", ""
  end
  local tail = fnamemodify(bufname, ":t")
  local ext = fnamemodify(bufname, ":e")
  local relative = fnamemodify(bufname, ":~:.")
  local dir = relative:match("^(.*[/\\])") or ""
  return dir, tail, ext
end

local function resolve_buf_repeated_names(tail)
  return tabs_repeated_names_buf_cache[tail] and tabs_repeated_names_buf_cache[tail].count > 1 and tail ~= ""
end

local get_icon_fn = {
  ["mini.icons"] = function(ext)
    local icon, hl = M.icons.provider.get("extension", ext)
    -- @check: get_hex should be removed
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
  if not config.icons.enabled then
    return nil
  end
  local icon, color = icon_cache_insert(ext)
  if icon == "" then
    icon_cache_remove(ext)
    return nil
  end
  return {
    str = icon,
    width = api.nvim_strwidth(icon),
    color = color,
  }
end

local function resolve_severity(diags)
  if not diags then
    return 0
  end
  if (diags[vim.diagnostic.severity.ERROR] or 0) > 0 then
    return STATES.ERROR
  end
  if (diags[vim.diagnostic.severity.WARN] or 0) > 0 then
    return STATES.WARN
  end
  if (diags[vim.diagnostic.severity.INFO] or 0) > 0 then
    return STATES.INFO
  end
  if (diags[vim.diagnostic.severity.HINT] or 0) > 0 then
    return STATES.HINT
  end
  return 0
end

local function resolve_hl(hl, state)
  local focused = band(state, STATES.FOCUSED) ~= 0
  local modified = band(state, STATES.MODIFIED) ~= 0
  local is_error = band(state, STATES.ERROR) ~= 0
  local is_warn = band(state, STATES.WARN) ~= 0

  if is_error or is_warn then
    local diag = hl.diagnostics and (is_error and hl.diagnostics.error or hl.diagnostics.warn)
    local variant = diag and (focused and diag.focused or diag.visible)
    if variant then
      if modified and variant.modified then
        return variant.modified
      end
      if variant.default then
        return variant.default
      end
    end
  end

  local focused_hl = (hl.focused or M.base_highlights.focused)
  local visible_hl = (hl.visible or M.base_highlights.visible)
  local bucket = focused and focused_hl or visible_hl
  if not bucket then
    return ""
  end
  if modified and bucket.modified then
    return bucket.modified
  end
  return bucket.default or ""
end

local function build_tab(buf, dir, tail, ext)
  local unique_prefix = resolve_buf_repeated_names(tail) and dir or ""
  local tab_icon = make_tab_icon(ext)

  local tab = {
    dir = dir,
    tail = tail,
    unique_prefix = unique_prefix,
    ext = ext,
    display = "",
    str = "",
    icon = tab_icon,
    str_width = 0,
    modified = 0,
    width = 0,
    rendered = {},
    severity = 0,
    rendered_visible = "",
    rendered_focused = "",
  }

  tab.update_unique_prefix = function()
    tab.unique_prefix = resolve_buf_repeated_names(tail) and dir or ""
  end

  tab.resolve_string = function(state)
    local start = vim.uv.hrtime()
    state = bor(state, tab.modified + tab.severity)

    local tab_state = {
      name = tail,
      unique_prefix = tab.unique_prefix,
      is_focused = band(state, STATES.FOCUSED) ~= 0,
      is_modified = band(state, STATES.MODIFIED) ~= 0,
      diagnostics = diag_cache[buf] or {},
      close = function(force)
        force = force or false
        M.close_tab(buf, force)
      end,
    }

    local display = { focus_on_click(buf) }
    local raw = {}

    for i, comp in ipairs(M.tabs) do
      local text
      local hl = comp.highlights and resolve_hl(comp.highlights, state) or resolve_hl(M.base_highlights, state)
      if comp.icon and tab_icon then
        hl = comp.highlights and hl or M.derive_hl(hl, { fg = tab_icon.color })
        text = comp.icon(tab_icon.str, tab_state)
      elseif comp.static then
        text = comp.static
      elseif comp.text then
        text = comp.text(tab_state)
        if comp.on_click then
          local on_click_str = on_click(buf, i, text) .. focus_on_click(buf)
          click_handlers[buf] = click_handlers[buf] or {}
          click_handlers[buf][i] = comp.on_click
          display[#display + 1] = "%#" .. hl .. "#" .. on_click_str
          raw[#raw + 1] = { text = text, text_width = api.nvim_strwidth(text), hl = hl, on_click = on_click_str or nil }
          goto continue
        end
      end
      if text then
        display[#display + 1] = "%#" .. hl .. "#" .. text
        raw[#raw + 1] = { text = text, text_width = api.nvim_strwidth(text), hl = hl }
      end
      ::continue::
    end

    -- local raw_str = table.concat(raw)

    local elapsed = (vim.uv.hrtime() - start) / 1e6 -- milliseconds
    vim.notify(string.format("tab: %.3fms", elapsed))
    return {
      raw = "Aeho",
      display = table.concat(display),
      width = api.nvim_strwidth("Aeho"),
    }
  end

  tab.rendered = setmetatable({}, {
    __index = function(t, state)
      local result = tab.resolve_string(state)
      rawset(t, state, result)
      return result
    end,
  })

  local visible_ = tab.rendered[STATES.VISIBLE]
  local focused_ = tab.rendered[STATES.FOCUSED]

  tab.rendered_visible = visible_.display
  tab.rendered_focused = focused_.display
  -- tab.str = visible_.raw
  tab.str = "aeho"
  tab.str_width = visible_.width

  local new_width = math.max(visible_.width, focused_.width)
  tab.width = new_width

  tab.update = function()
    local flags = tab.modified + tab.severity
    local visible = tab.rendered[STATES.VISIBLE + flags]
    local focused = tab.rendered[STATES.FOCUSED + flags]

    tab.rendered_visible = visible.display
    tab.rendered_focused = focused.display

    local new_width = math.max(visible.width, focused.width)
    if new_width ~= tab.width then
      viewport.total_tabs_width = viewport.total_tabs_width - tab.width + new_width
      tab.width = new_width
      -- this should be another flag
      viewport.size_changed = true
    end
  end
  return tab
end

local function refresh_tab(index)
  local tab = tabs_cache[index]
  if not tab then
    return
  end
  tab.update_unique_prefix()
  tab.rendered = setmetatable({}, getmetatable(tab.rendered)) -- wipe all variants
  tab.update()
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
        refresh_tab(buf_index[b])
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
          refresh_tab(buf_index[b])
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
  local tail = tabs_cache[index].tail
  local dir, new_tail, ext = resolve_buf_name(buf)
  if tail ~= new_tail then
    repeated_names_remove(buf, tail)
    repeated_names_insert(buf, new_tail)
  end
  local tab = build_tab(buf, dir, new_tail, ext)
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
  repeated_names_remove(bufnr, tab.tail)

  table.remove(tabs_cache, index)
  table.remove(buf_cache, index)

  click_handlers[bufnr] = nil

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

local function insert_buf_into_tabline(buf)
  local dir, tail, ext = resolve_buf_name(buf)
  repeated_names_insert(buf, tail)
  local tab = build_tab(buf, dir, tail, ext)
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
  if not sidebar.enabled or not sidebar.winnr or not api.nvim_win_is_valid(sidebar.winnr) then
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

    sidebar.rendered_focused = "%#TablineSidebarFocusedLabel#" .. label .. "%#TablineSidebarSep#" .. sidebar.separator

    sidebar.rendered_visible = "%#TablineSidebarVisibleLabel#" .. label .. "%#TablineSidebarSep#" .. sidebar.separator
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
  local state = tab.modified + tab.severity
  local hl = "%#" .. resolve_hl(M.base_highlights, state) .. "#"
  local pad = string.rep(" ", math.max(0, size - tab.str_width))
  return pad .. hl .. fn.strcharpart(tab.str, tab.str_width - size, size)
end

local function resolve_post_str(size)
  local tab = tabs_cache[viewport.hi + 1]
  local state = tab.modified + tab.severity
  local hl = "%#" .. resolve_hl(M.base_highlights, state) .. "#"
  local pad = string.rep(" ", math.max(0, size - tab.str_width))
  return hl .. fn.strcharpart(tab.str, 0, size) .. pad
end

local function make_prefix(left_remaining, indicator)
  if viewport.lo > 1 then
    viewport.prefix = viewport.indicator_left
    if left_remaining > 0 then
      local size = left_remaining - indicator
      if size > 0 then
        if size > 0 then
          local buf = buf_cache[viewport.lo - 1]
          viewport.prefix = focus_on_click(buf) .. viewport.prefix .. resolve_prefix_str(size)
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
        viewport.postfix = "%#TablineFill#" .. string.rep(" ", right_remaining) .. viewport.postfix
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
  local indicator_left = viewport.indicator_left_width
  local indicator_right = viewport.indicator_end_width
  local indicators = indicator_left + indicator_right
  local lo, left_remaining = get_viewport_lo(#tabs_cache, width - indicators)
  return lo, left_remaining + indicator_left
end

local function compute_right_remain_from_start(width)
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
    viewport.hi, right_remaining = compute_right_remain_from_start(width)
  else
    local indicator = viewport.indicator_left_width + viewport.indicator_right_width
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
    local indicator = viewport.indicator_left_width + viewport.indicator_right_width
    viewport.lo, left_remaining = get_viewport_lo(viewport.hi, width - indicator)
    left_remaining = left_remaining + indicator
    right_remaining = indicator
  end

  gen_prefix_postfix(left_remaining, right_remaining)
end

local function handle_width_change(width)
  viewport.size_changed = false
  local left_remaining = 0
  local right_remaining = 0
  if viewport.lo == 1 then
    viewport.hi, right_remaining = compute_right_remain_from_start(width)
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
        viewport.hi, right_remaining = compute_right_remain_from_start(width)
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
  elseif viewport.size_changed then
    handle_width_change(width)
  end
end

function M.tabline_make()
  local start = vim.uv.hrtime()
  if
    viewport.size_changed
    or viewport.changed
    or viewport.diag_or_input_changed
    or viewport.buf_deleted
    or viewport.is_in_small_size
  then
    if api.nvim_get_current_win() ~= sidebar.winnr and sidebar.focus then
      sidebar.focus = false
      viewport.buf = buf_cache[viewport.index]
    end

    local width = viewport.width - viewport.sidebar_width

    local tab_str, tab_shrink = "", false
    local indicators = compute_both_indicators()
    local current_tab = tabs_cache[viewport.index]

    if viewport.diag_or_input_changed and not viewport.changed then
      viewport.diag_or_input_changed = false
      goto build_viewport_str
    end

    if current_tab and current_tab.width > width - indicators then
      local available = width
      viewport.lo = viewport.index
      viewport.hi = viewport.index
      if viewport.lo == viewport.hi then
        viewport.prefix = viewport.indicator_left
        viewport.postfix = viewport.indicator_end
        available = available - viewport.indicator_end_width - viewport.indicator_left_width
        if available <= viewport.indicator_left_width then
          viewport.prefix = ""
          available = available - viewport.indicator_left_width
        end
      elseif viewport.hi == #tabs_cache then
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
        available = width - indicators
      end

      tab_shrink = true

      local buf = buf_cache[viewport.index]
      local state = STATES.FOCUSED + current_tab.modified + current_tab.severity
      local hl = "%#" .. resolve_hl(M.base_highlights, state) .. "#"

      local pad = string.rep(" ", math.max(0, available - current_tab.str_width))

      tab_str = hl
        .. focus_on_click(buf)
        .. fn.strcharpart(current_tab.str, current_tab.str_width - available, available)
        .. "%#TablineFill#"
        .. pad
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
    if viewport.sidebar_width > 0 then
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

function M.prev_tab_cycle()
  if sidebar.focus then
    return
  end
  local n = #tabs_cache
  local i = ((get_current_index() - 2) % n) + 1
  api.nvim_set_current_buf(buf_cache[i])
  viewport.index = i
end

function M.next_tab_cycle()
  if sidebar.focus then
    return
  end
  local n = #tabs_cache
  local i = (get_current_index() % n) + 1
  api.nvim_set_current_buf(buf_cache[i])
  viewport.index = i
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

function M.move_tab_left_cycle()
  if sidebar.focus then
    return
  end
  local i = get_current_index()
  if i > 1 then
    swap(i, i - 1)
  else
    M.move_tab_end()
  end
end

function M.move_tab_right_cycle()
  if sidebar.focus then
    return
  end
  local i = get_current_index()
  if i < #buf_cache then
    swap(i, i + 1)
  else
    M.move_tab_begin()
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
  -- local visible_bg = "#1c161c"
  local visible_bg = get_hex("TablineVisible", "bg") or get_hex("StatusLineNC", "bg") or get_hex("TablineFill", "bg")
  local win_sep_fg = get_hex("WinSeparator", "fg")
  local tab_fill_bg = get_hex("TablineFill", "bg")
  local errors_fg = get_hex("DiagnosticError", "fg")
  local warning_fg = get_hex("DiagnosticWarn", "fg")

  local hl = api.nvim_set_hl
  hl(0, "TablineFocused", { fg = focused_fg, bg = focused_bg })
  hl(0, "TablineVisible", { fg = visible_fg, bg = visible_bg })
  hl(0, "TablineFocusedModified", { fg = focused_fg, bg = focused_bg, italic = true })
  hl(0, "TablineVisibleModified", { fg = visible_fg, bg = visible_bg, italic = true })
  hl(0, "TablineSidebarFocusedLabel", { fg = focused_fg, bg = focused_bg })
  hl(0, "TablineSidebarVisibleLabel", { fg = focused_fg, bg = visible_bg })
  hl(0, "TablineSidebarSep", { fg = win_sep_fg, bg = tab_fill_bg })
  hl(0, "TablineIndicatorSep", { fg = visible_fg, bg = tab_fill_bg })
  hl(0, "TablineFocusedSeparator", { fg = tab_fill_bg, bg = focused_bg })
  hl(0, "TablineVisibleSeparator", { fg = tab_fill_bg, bg = visible_bg })
  hl(0, "TablineFocusedDiagError", { fg = errors_fg, bg = focused_bg })
  hl(0, "TablineVisibleDiagError", { fg = errors_fg, bg = visible_bg })
  hl(0, "TablineFocusedDiagWarn", { fg = warning_fg, bg = focused_bg })
  hl(0, "TablineVisibleDiagWarn", { fg = warning_fg, bg = visible_bg })
  hl(0, "TablineFocusedDiagModifiedError", { fg = errors_fg, bg = focused_bg, italic = true })
  hl(0, "TablineVisibleDiagModifiedError", { fg = errors_fg, bg = visible_bg, italic = true })
  hl(0, "TablineFocusedDiagModifiedWarn", { fg = warning_fg, bg = focused_bg, italic = true })
  hl(0, "TablineVisibleDiagModifiedWarn", { fg = warning_fg, bg = visible_bg, italic = true })
end

---@return string
M.get_icon_hl = function(color, hl_group)
  if M.icons.no_hl then
    return hl_group
  end
  return M.derive_hl(hl_group, { fg = color })
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
      if sidebar.enabled and sidebar_filetypes[bo[ev.buf].filetype] then
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

  if not config.no_modified then
    api.nvim_create_autocmd("BufModifiedSet", {
      callback = function(ev)
        local index = buf_index[ev.buf]
        if not index then
          return
        end

        local tab = tabs_cache[index]
        local modified = bo[ev.buf].modified and STATES.MODIFIED or 0

        if tab.modified == modified then
          return
        end

        tab.modified = modified
        tab.update()

        if viewport.lo <= index and index <= viewport.hi then
          viewport.diag_or_input_changed = true
          schedule_redraw()
        end
      end,
    })
  end

  if not config.no_diagnostic then
    api.nvim_create_autocmd("DiagnosticChanged", {
      callback = function(ev)
        local index = buf_index[ev.buf]
        if not index then
          return
        end

        diag_cache[ev.buf] = vim.diagnostic.count(ev.buf, M.diag_filter)
        local tab = tabs_cache[index]
        local new_severity = resolve_severity(diag_cache[ev.buf])
        local old_severity = tab.severity

        local changed = old_severity ~= new_severity

        if next(M.dynamic.diagnostics) ~= nil then
          for state in pairs(M.dynamic.diagnostics) do
            if tab.rendered[state] ~= nil then
              tab.rendered[state] = nil
              changed = true
            end
          end
        end

        if changed then
          tab.severity = new_severity
          tab.update()
          if viewport.lo <= index and index <= viewport.hi then
            viewport.diag_or_input_changed = true
            schedule_redraw()
          end
        end
      end,
    })
  end

  api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    callback = function()
      viewport.sidebar_width = render_sidebar()
      viewport.width = vim.o.columns
      viewport.size_changed = true
    end,
  })

  api.nvim_create_autocmd("BufFilePost", {
    callback = function(ev)
      resolve_update_tab(ev.buf)
    end,
  })

  api.nvim_create_autocmd("ColorScheme", {
    once = true,
    callback = setup_tabline_hl,
  })
end

_G.make_tabline = M.tabline_make
vim.opt.tabline = "%!v:lua.make_tabline()"
vim.opt.showtabline = 2

_G.OnClick = function(id, clicks, button, mods)
  local bufnr = rshift(id, 16)
  local comp_index = band(id, 0xFFFF)
  local fn_handler = click_handlers[bufnr] and click_handlers[bufnr][comp_index]
  if fn_handler then
    fn_handler(bufnr, clicks, button, mods)
  end
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

function M.setup(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(config), opts or {})

  M.diag_filter = config.severity_filter

  M.tabs = config.tabs
  M.base_highlights = config.base_highlights

  if config.icons.enabled then
    M.icons = {}
    M.icons.no_hl = config.icons.no_hl

    local provider = config.icons.provider
    M.icons.provider = require(provider)
    M.get_icon = get_icon_fn[provider]
  end

  sidebar.separator = config.sidebar.separator
  sidebar.separator_width = strwidth(config.sidebar.separator)

  sidebar.enabled = config.sidebar.enabled

  for _, ft in ipairs(config.sidebar.filetypes) do
    sidebar_filetypes[ft] = true
  end

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

  viewport.indicator_left = "%#TablineIndicatorSep#" .. config.indicator_left
  viewport.indicator_right = "%#TablineIndicatorSep#" .. config.indicator_right

  viewport.indicator_left_width = api.nvim_strwidth(config.indicator_left)
  viewport.indicator_right_width = api.nvim_strwidth(config.indicator_right)

  viewport.indicator_start = "%#TablineIndicatorSep#" .. config.indicator_start
  viewport.indicator_end = "%#TablineIndicatorSep#" .. config.indicator_end

  viewport.indicator_start_width = api.nvim_strwidth(config.indicator_start)
  viewport.indicator_end_width = api.nvim_strwidth(config.indicator_end)

  viewport.sidebar_width = render_sidebar()
  viewport.width = vim.o.columns

  init_dynamic(config.dynamic)
  init_bufs()
  setup_autocmds()
  setup_tabline_hl()

  if opts and type(opts.update_cursor_line_hl) == "function" then
    M.update_cursor_line_hl = opts.update_cursor_line_hl
  end
end

local function debug_command()
  vim.notify(vim.inspect(click_handlers))
end

api.nvim_create_user_command("Aeho", debug_command, {})

return M
