local bit = require("bit")
local band, bor, lshift, rshift = bit.band, bit.bor, bit.lshift, bit.rshift

local api, fn, bo = vim.api, vim.fn, vim.bo

local redrawtabline = vim.cmd.redrawtabline
local diagnostic_count = vim.diagnostic.count

local string_rep = string.rep
local string_gsub = string.gsub
local string_match = string.match
local string_format = string.format

local math_max = math.max
local math_ceil = math.ceil
local math_floor = math.floor

local table_concat = table.concat
local table_insert = table.insert
local table_remove = table.remove

local fnamemodify = fn.fnamemodify
local strcharpart = fn.strcharpart
local win_findbuf = fn.win_findbuf

local nvim_strwidth = api.nvim_strwidth
local nvim_buf_get_name = api.nvim_buf_get_name
local nvim_create_buf = api.nvim_create_buf
local nvim_get_current_win = api.nvim_get_current_win
local nvim_win_set_buf = api.nvim_win_set_buf
local nvim_win_is_valid = api.nvim_win_is_valid
local nvim_win_get_width = api.nvim_win_get_width
local nvim_set_current_buf = api.nvim_set_current_buf
local nvim_get_current_buf = api.nvim_get_current_buf
local nvim_buf_call = api.nvim_buf_call
local nvim_buf_is_valid = api.nvim_buf_is_valid
local nvim_buf_delete = api.nvim_buf_delete
local nvim_get_hl = api.nvim_get_hl
local nvim_set_hl = api.nvim_set_hl
local nvim_list_bufs = api.nvim_list_bufs
local nvim_win_get_position = api.nvim_win_get_position

local IS_WINDOWS = fn.has("win32") == 1

local STATES = {
  VISIBLE = lshift(1, 0), -- 1
  FOCUSED = lshift(1, 1), -- 2
  MODIFIED = lshift(1, 2), -- 4
  ERROR = lshift(1, 3), -- 8
  WARN = lshift(1, 4), -- 16
  HINT = lshift(1, 5), -- 32
  INFO = lshift(1, 6), -- 64
}

local Galfo = {}
local I = {}

local config = {
  focus_on_click = true,

  base_highlights = {
    visible = { default = "TablineVisible", modified = "" },
    focused = { default = "TablineFocused", modified = "" },
  },

  scratch_buffer_name = "[No Name]",

  -- Only useful if on windows.
  force_unix_path_sep = true,

  -- There are cases where the width of the tabline can't accommodate the last icon
  -- before the truncate_right, so it will blend with the
  -- next char or being half displayed if no truncate_right.
  -- If don't matter that happening set it to true.
  last_icon_blend = false,

  -- the `on_click` applies to the entire tab without `on_click`
  -- parameters the default on_click parameters and tab.
  -- `tab`
  -- bufnr: integer
  -- focus()
  -- close() -- receive the force (boolean) parameter to force delete the buffer
  -- toggle_pin() -- receive the force (boolean) parameter to force delete the buffer
  tab = {
    on_click = function(tab, _clicks, button, _mods)
      if button == "l" then
        tab.focus()
      elseif button == "m" then
        tab.close(false)
      end
    end,
  },

  -- Each tab could be text, static or icon
  -- `text`: fuction(tab) end
  -- `static`: "" -- just a string
  -- `icon`: function(icon, tab) end -- icon is the filetype string. must return just 1 icon.
  -- And if the highlights in this case are no passed it applies the provider filetype color.
  -- If using some custom icon you should provide the highlight group
  -- Or just `highlights = {}` to use the defaults.
  -- `on_click`: function(bufnr, clicks, button, mods) end
  -- the `tab` parameter is:
  -- name: string
  -- unique_prefix: string -- with a path if a file with the same name appears.
  -- index: integer
  -- is_focused: boolean
  -- is_modified: boolean
  -- is_pinned: boolean
  -- diagnostics: {[vim.diagnostic.severity]: integer} -- Eg.: ab.diagnostics[vim.diagnostic.severity.ERROR]
  --
  -- `highlights`: It receives the highlight group.
  -- You can customize existing colors using:
  -- `Galfo.derive_hl` (returns new group)
  -- `Galfo.get_hex` (return { fg: string, bf: string })
  -- Diagnostics overrides the default and is applied using `diagnostic.filter`
  -- highlights = {
  --   visible = { default = "", modified = "" },
  --   focused = { default = "", modified = "" },
  --   diagnostics = {
  --     error = {
  --       focused = { default = "", modified = "" },
  --       visible = { default = "", modified = "" },
  --     },
  --     warn = {
  --       focused = { default = "", modified = "" },
  --       visible = { default = "", modified = "" },
  --     },
  --   },
  -- },

  tabs = {
    {
      static = " ",
      highlights = {
        visible = { default = "TablineVisible", modified = "TablineVisible" },
        focused = { default = "TablineFocused", modified = "TablineFocused" },
      },
    },
    {
      text = function(tab)
        return tab.unique_prefix .. tab.name
      end,
    },
    {
      static = " ",
      highlights = {
        visible = { default = "TablineVisible", modified = "TablineVisible" },
        focused = { default = "TablineFocused", modified = "TablineFocused" },
      },
    },
  },

  diagnostics = {
    filter = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severit },
    order = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.INFO,
      vim.diagnostic.severity.HINT,
    },
  },

  -- This is for when you want to display some information from diagnostic or react to it
  -- like showing how many errors or warnings.
  -- if diagnostics = true so all other will fallback to it otherwise it will only be
  -- dynamic in the state set.
  -- The index is if you want to display the tab index position.
  -- So it will update whenever that position changes.
  -- dynamic = { index = false, diagnostics = true, focused = { diagnostics = false }, visible = { diagnostics = true } },
  dynamic = { index = true, diagnostics = true },

  -- `first`: appears for the first tab.
  -- `last`: appears for the last tab if tab is fullfilled.
  -- `truncate_left`: appears when theres more tabs left.
  -- `truncate_right`: appears when theres more tabs right.
  indicators = {
    first = { text = "", highlight = "TablineVisible" },
    last = { text = "", highlight = "TablineVisible" },
    truncate_left = { text = "…", highlight = "TablineVisible" },
    truncate_right = { text = "…", highlight = "TablineVisible" },
  },

  -- If you don't want to react too diagnostics or modified just set it up.
  no_diagnostic = false,
  no_modified = false,

  icons = {
    enabled = true,
    provider = "mini.icons", -- "mini.icons"|"nvim-web-devicons" default: "mini.icons"
  },

  sidebar = {
    enabled = true,
    label = "Explorer",
    label_position = "mid", -- "start"|"mid"|"end"
    separator = "│",
    filetypes = { "NvimTree", "neo-tree" }, -- Default with ["NvimTree", "neo-tree"]
    highlights = {
      label = { focused = "TablineFocused", visible = "TablineVisible" },
      sep = "TablineVisible",
    },
  },

  ignore = {
    bufnames = {},
    buftypes = {
      "terminal",
      "prompt",
    },
    filetypes = {
      "qf",
    },
  },

  -- Used when a buffer is deleted/replaced in a window.
  -- That's is for my use case. hehe
  -- I have a bright cursor line in the "current buffer" and a dimmed version in
  -- all other windows, so it has to run in other windows to preserve this behavior.
  -- If you don't have that kind of usage, just ignore.
  -- Check my usage. That code is from my `Galfo.setup({})`
  -- on_buf_replaced = function(cur_win, win)
  --   local hl = cur_win == win and cursor_line_active or cursor_line_inactive
  --   vim.api.nvim_set_option_value("winhighlight", hl, { win = win })
  -- end,
  on_buf_replaced = function(_, _) end,
}

---@class ViewportState
---@field updated boolean
---@field size_changed boolean
---@field should_not_focus boolean
---@field buf_deleted_partial boolean
---@field tab_width_changed boolean
---@field simple_redraw boolean
---@field tab_shrink boolean
---@field partial_left_redraw boolean
---@field partial_right_redraw boolean
local viewport_state = {
  updated = true,
  size_changed = true,
  should_not_focus = false,
  buf_deleted_partial = false,
  tab_width_changed = false,
  simple_redraw = true,
  tab_shrink = false,
  partial_left_redraw = false,
  partial_right_redraw = false,
}

---@class Viewport
---@field display string
---@field width integer
---@field lo integer
---@field hi integer
---@field buf integer
---@field index integer
---@field truncate_left string
---@field truncate_right string
---@field truncate_left_width integer
---@field truncate_right_width integer
---@field indicator_first string
---@field indicator_last string
---@field indicator_first_width integer
---@field indicator_last_width integer
---@field prefix string
---@field postfix string
---@field viewport.left_reserved integer
---@field viewport.right_reserved integer
---@field endfix string
---@field total_tabs_width integer
local viewport = {
  display = "",
  tab_shrink_str = "",
  width = 0,
  sidebar_width = 0,
  lo = 1,
  hi = 1,
  buf = 1,
  index = 1,
  prefix = "",
  postfix = "",
  endfix = "%#TablineFill#",
  truncate_left = "",
  truncate_right = "",
  truncate_left_width = 2,
  truncate_right_width = 2,
  indicator_first = "",
  indicator_last = "",
  indicator_first_width = 2,
  indicator_last_width = 2,
  total_tabs_width = 0,
  left_reserved = 0,
  right_reserved = 0,
}

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

---@type {[string], string?}
local hl_cache = {}

---@class Components
---@field text string
---@field text_width integer
---@field hl string
---@field on_click string?
---@field is_icon boolean
---
---@class Rendered
---@field components Components[]
---@field display string
---@field width integer

---@class TabIcon
---@field str string
---@field color string

---@class Tab
---@field display string
---@field tail string
---@field ext string
---@field unique_prefix string
---@field width integer
---@field visibility integer
---@field severity integer
---@field modified integer
---@field icon TabIcon?
---@field rendered table<integer, Rendered?>
---@field update fun()
---@field rerender fun(): boolean
---@field set_new_display fun(): boolean
---@field update_unique_prefix fun()
---@field resolve_string fun(state: integer): Rendered
---@field partial_left fun(width: integer, state: integer?): string
---@field partial_right fun(width: integer): string

---@type {[integer]: Tab}
local tabs_cache = {}

---@type {[integer]: boolean?}
local tabs_pin_cache = {}

---@type {[string]: {count: integer, icon: string, color: string}?}
local icons_ext_cache = {}

---@type {[string]: {count: integer, bufs: table<integer, boolean?>}?}
local tabs_repeated_names_buf_cache = {}

local function init_dynamic(dynamic)
  if not dynamic then
    return
  end

  I.dynamic.index = dynamic.index or false

  local severity_states = { STATES.ERROR, STATES.WARN, STATES.HINT, STATES.INFO }

  local function mark_diags(flag)
    for i = 1, #severity_states do
      local severity = severity_states[i]
      I.dynamic.diagnostics[flag + severity] = true
      I.dynamic.diagnostics[flag + STATES.MODIFIED + severity] = true
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

local function to_int(color)
  if type(color) == "string" then
    return tonumber(string_gsub(color, "^#", ""), 16)
  end
  return color
end

Galfo.derive_hl = function(group, overrides)
  local ok, val = pcall(nvim_get_hl, 0, { name = group, link = false })
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

  nvim_set_hl(0, name, attrs)
  hl_cache[key] = name
  return name
end

---@return nil|{fg: string, bg:string}
Galfo.get_hex = function(group)
  local ok, val = pcall(nvim_get_hl, 0, { name = group, link = false })
  if not ok or not val then
    return nil
  end
  return {
    fg = val.fg and string_format("#%06x", val.fg) or "",
    bg = val.bg and string_format("#%06x", val.bg) or "",
  }
end

---@type table<integer, table<integer, function>?>
local click_components_handlers = {}

---@type table<integer, function?>
local click_tab_handlers = {}

local function tab_on_click(bufnr)
  if I.focus_on_click then
    return "%" .. bufnr .. "@v:lua.TabOnClick@"
  end
  return ""
end

local function component_on_click(bufnr, index, text)
  return "%" .. (lshift(bufnr, 16) + index) .. "@v:lua.ComponentOnClick@" .. text .. "%X" .. tab_on_click(bufnr)
end

local function update_buf_index()
  buf_index = {}
  viewport.total_tabs_width = 0
  for i = 1, #buf_cache do
    buf_index[buf_cache[i]] = i
    viewport.total_tabs_width = viewport.total_tabs_width + tabs_cache[i].width
  end
  local index = buf_index[viewport.buf]
  if not sidebar.focus and index then
    viewport.index = index
  end
  viewport_state.updated = true
end

local function resolve_buf_name(buf)
  local bufname = nvim_buf_get_name(buf)
  if bufname == "" then
    return "", I.tab.scratch_buffer_name, ""
  end
  local tail = fnamemodify(bufname, ":t")
  local ext = fnamemodify(bufname, ":e")
  local relative = fnamemodify(bufname, ":~:.")

  if IS_WINDOWS and I.tab.force_unix_path_sep then
    relative = string_gsub(relative, "\\", "/")
  end

  local sep = (IS_WINDOWS and not I.tab.force_unix_path_sep) and "^(.*\\)" or "^(.*/)"
  local dir = string_match(relative, sep) or ""

  return dir, tail, ext
end

local function resolve_buf_repeated_names(tail)
  return tabs_repeated_names_buf_cache[tail] and tabs_repeated_names_buf_cache[tail].count > 1 and tail ~= ""
end

local get_icon_fn = {
  ["mini.icons"] = function(ext)
    local icon, hl = I.icons.provider.get("extension", ext)
    local color = nvim_get_hl(0, { name = hl, link = false })
    return icon, string_format("#%06x", color.fg)
  end,
  ["nvim-web-devicons"] = function(ext)
    return I.icons.provider.get_icon_color(nil, ext, { default = true })
  end,
}

local function icon_cache_insert(ext)
  if icons_ext_cache[ext] then
    icons_ext_cache[ext].count = icons_ext_cache[ext].count + 1
    return icons_ext_cache[ext].icon, icons_ext_cache[ext].color
  end
  local icon, color = I.get_icon(ext)
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
    color = color,
  }
end

local diag_to_state = {
  [vim.diagnostic.severity.ERROR] = STATES.ERROR,
  [vim.diagnostic.severity.WARN] = STATES.WARN,
  [vim.diagnostic.severity.INFO] = STATES.INFO,
  [vim.diagnostic.severity.HINT] = STATES.HINT,
}

local function resolve_severity(diags)
  if not diags then
    return 0
  end
  for i = 1, #I.diag_order do
    local diag = I.diag_order[i]
    if (diags[diag] or 0) > 0 then
      return diag_to_state[diag]
    end
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

  local focused_hl = (hl.focused or I.base_highlights.focused)
  local visible_hl = (hl.visible or I.base_highlights.visible)
  local bucket = focused and focused_hl or visible_hl
  if not bucket then
    return ""
  end
  if modified and bucket.modified then
    return bucket.modified
  end
  return bucket.default or ""
end

---@param buf integer
---@param dir string
---@param tail string
---@param ext string
---@return Tab
local function build_tab(buf, dir, tail, ext)
  local unique_prefix = resolve_buf_repeated_names(tail) and dir or ""
  local tab_icon = make_tab_icon(ext)

  local tab = {
    dir = dir,
    visibility = STATES.VISIBLE,
    tail = tail,
    unique_prefix = unique_prefix,
    ext = ext,
    str = "",
    icon = tab_icon,
    modified = 0,
    width = 0,
    rendered = {},
    severity = 0,
  }

  tab.update_unique_prefix = function()
    tab.unique_prefix = resolve_buf_repeated_names(tail) and dir or ""
  end

  tab.resolve_string = function(state)
    local tab_state = {
      name = tail,
      index = buf_index[buf] or #tabs_cache + 1,
      unique_prefix = tab.unique_prefix,
      is_focused = band(state, STATES.FOCUSED) ~= 0,
      is_modified = band(state, STATES.MODIFIED) ~= 0,
      is_pinned = tabs_pin_cache[buf] ~= nil,
      diagnostics = diag_cache[buf] or {},
    }

    -- register in the handlers the `tab.on_click` with the current buf
    click_tab_handlers[buf] = I.tab.on_click

    -- init the tab with `tab.on_click`
    local display = { tab_on_click(buf) }

    local tab_width = 0
    local components = {}

    for i = 1, #I.tabs do
      local comp = I.tabs[i]
      local hl = comp.highlights and resolve_hl(comp.highlights, state) or resolve_hl(I.base_highlights, state)

      local text
      if comp.icon and tab_icon then
        hl = comp.highlights and hl or Galfo.derive_hl(hl, { fg = tab_icon.color })
        text = comp.icon(tab_icon.str, tab_state)
        comp.is_icon = true
      elseif comp.static then
        text = comp.static
      elseif comp.text then
        text = comp.text(tab_state)
      end

      if not text then
        goto continue
      end

      local text_width = nvim_strwidth(text)
      tab_width = tab_width + text_width

      if comp.on_click then
        local on_click_str = component_on_click(buf, i, text)
        click_components_handlers[buf] = click_components_handlers[buf] or {}
        click_components_handlers[buf][i] = comp.on_click
        display[#display + 1] = "%#" .. hl .. "#" .. on_click_str
        components[#components + 1] = {
          text = text,
          text_width = text_width,
          hl = hl,
          is_icon = comp.is_icon or false,
          on_click = on_click_str,
        }
        goto continue
      end

      if text then
        display[#display + 1] = "%#" .. hl .. "#" .. text
        components[#components + 1] = {
          text = text,
          text_width = text_width,
          hl = hl,
          is_icon = comp.is_icon or false,
        }
      end

      ::continue::
    end

    return {
      components = components,
      display = table_concat(display),
      width = tab_width,
    }
  end

  tab.rendered = setmetatable({}, {
    __index = function(t, state)
      local result = tab.resolve_string(state)
      rawset(t, state, result)
      return result
    end,
  })

  tab.update = function()
    local flags = tab.modified + tab.severity
    local _ = tab.rendered[STATES.VISIBLE + flags]
    local _ = tab.rendered[STATES.FOCUSED + flags]
  end

  tab.rerender = function()
    tab.rendered = setmetatable({}, getmetatable(tab.rendered))
    tab.update()
  end

  tab.set_new_display = function()
    local old_width = tab.width
    local flags = tab.visibility + tab.modified + tab.severity
    local rendered = tab.rendered[flags]
    ---@cast rendered Rendered

    tab.display = rendered.display
    tab.width = rendered.width
    viewport.total_tabs_width = viewport.total_tabs_width - tab.width + old_width
    return tab.width ~= old_width
  end

  tab.partial_right = function(width)
    ---@type Components[]
    local components = tab.rendered[STATES.VISIBLE + tab.modified + tab.severity].components
    ---@type string[]
    local partial_right = { tab_on_click(buf) }
    ---@type integer
    local w = 0
    for i = 1, #components do
      ---@type Components
      local component = components[i]
      if w + component.text_width + (component.is_icon and 1 or 0) > width then
        local remaining = width - w
        ---@cast remaining integer
        if remaining > 0 then
          if component.is_icon and remaining == 1 and not I.tab.last_icon_blend then
            -- If not substitute the icon with one space, it blends with the next
            -- icon/indicator or got cut in half.
            partial_right[#partial_right + 1] = " "
          else
            local text = component.text
            local part = strcharpart(text, 0, remaining, 1)
            partial_right[#partial_right + 1] = "%#"
              .. component.hl
              .. "#"
              .. (component.on_click and component_on_click(buf, i, part) or part)
          end
          w = w + remaining
        end
        break
      end
      w = w + component.text_width
      partial_right[#partial_right + 1] = "%#" .. component.hl .. "#" .. (component.on_click or component.text)
    end
    local pad = string_rep(" ", math_max(0, width - w))
    partial_right[#partial_right + 1] = pad
    return table_concat(partial_right)
  end

  tab.partial_left = function(width, state)
    state = state or STATES.VISIBLE
    ---@type Components[]
    local components = tab.rendered[bor(state, tab.modified + tab.severity)].components
    ---@type string[]
    local partial_left = {}
    ---@type integer
    local w = 0
    local total = #components

    for i = total, 1, -1 do
      ---@type Components?
      local component = components[i]
      if w + component.text_width + (component.is_icon and 1 or 0) > width then
        local remaining = width - w
        ---@cast remaining integer
        if remaining > 0 then
          local part = strcharpart(component.text, component.text_width - remaining)
          partial_left[#partial_left + 1] = "%#"
            .. component.hl
            .. "#"
            .. (component.on_click and component_on_click(buf, i, part) or part)
        end
        break
      end
      w = w + component.text_width
      partial_left[#partial_left + 1] = "%#" .. component.hl .. "#" .. (component.on_click or component.text)
    end

    local n = #partial_left
    for i = 1, math_floor(n / 2) do
      partial_left[i], partial_left[n - i + 1] = partial_left[n - i + 1], partial_left[i]
    end

    return tab_on_click(buf) .. table_concat(partial_left)
  end

  return tab
end

local function refresh_tab(index)
  ---@type Tab?
  local tab = tabs_cache[index]
  if not tab then
    return
  end
  tab.update_unique_prefix()
  tab.rerender()
  tab.set_new_display()
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
  tab.update()
  tab.set_new_display()
  tabs_cache[index] = tab
  update_buf_index()
end

local function insert_buf_into_tabline(buf)
  local dir, tail, ext = resolve_buf_name(buf)
  repeated_names_insert(buf, tail)
  local tab = build_tab(buf, dir, tail, ext)
  tab.update()
  tab.set_new_display()
  table_insert(buf_cache, buf)
  table_insert(tabs_cache, tab)
  viewport.buf = buf
  update_buf_index()
end

local function remove_buf_from_tabline(bufnr)
  local index = buf_index[bufnr]
  if not index then
    return
  end

  ---@type Tab
  local tab = tabs_cache[index]
  if tab.icon then
    icon_cache_remove(tab.ext)
  end
  repeated_names_remove(bufnr, tab.tail)

  table_remove(tabs_cache, index)
  table_remove(buf_cache, index)

  diag_cache[bufnr] = nil
  click_tab_handlers[bufnr] = nil
  click_components_handlers[bufnr] = nil

  viewport_state.tab_width_changed = true
  viewport_state.buf_deleted_partial = index == viewport.lo - 1

  ---@type integer?
  local replacement = buf_cache[index] or buf_cache[index - 1]
  if not replacement then
    local bufs = nvim_list_bufs()
    for i = 1, #bufs do
      local buf = bufs[i]
      if bo[buf].buflisted and nvim_buf_is_valid(buf) and nvim_buf_get_name(buf) == "" then
        replacement = buf
        break
      end
    end
    if not replacement then
      replacement = nvim_create_buf(true, false)
    end
  end

  local cur_win = nvim_get_current_win()
  local wins = win_findbuf(bufnr)
  for i = 1, #wins do
    local win = wins[i]
    nvim_win_set_buf(win, replacement)
    I.on_buf_replaced(cur_win, win)
  end
  update_buf_index()

  if I.dynamic.index then
    for i = index, #tabs_cache do
      tabs_cache[i].rerender()
      tabs_cache[i].set_new_display()
    end
  end
end

local function init_bufs()
  for _, b in ipairs(nvim_list_bufs()) do
    if bo[b].buflisted then
      insert_buf_into_tabline(b)
    end
  end
end

--- @return integer
local function get_current_index()
  return buf_index[viewport.buf] or 1
end

local cached_pad_tab = -1
local sidebar_spaces_tab = ""

local cached_pad_left = -1
local sidebar_spaces_left = ""

local cached_pad_right = -1
local sidebar_spaces_right = ""

local function make_spaces(cached_pad, str, n)
  if cached_pad ~= n then
    cached_pad = n
    str = string_rep(" ", n)
  end
  return str
end

local function sidebar_label_start(pad)
  local pad_left = math_ceil(0)
  local pad_right = math_floor(pad)
  return pad_left, pad_right
end

local function sidebar_label_mid(pad)
  local pad_left = math_ceil(pad / 2)
  local pad_right = math_floor(pad / 2)
  return pad_left, pad_right
end

local function sidebar_label_end(pad)
  local pad_left = math_ceil(pad)
  local pad_right = math_floor(0)
  return pad_left, pad_right
end

---@return integer
local function render_sidebar()
  if not sidebar.enabled or not sidebar.winnr or not nvim_win_is_valid(sidebar.winnr) then
    return 0
  end
  local sidebar_width = nvim_win_get_width(sidebar.winnr)
  if sidebar_width ~= sidebar.width then
    sidebar.width = sidebar_width
    local total_pad = math_max(0, sidebar_width - sidebar.label_width)
    local pad_left, pad_right = I.sidebar_label_position(total_pad)
    local spaces_left = make_spaces(cached_pad_left, sidebar_spaces_left, pad_left)
    local spaces_right = make_spaces(cached_pad_right, sidebar_spaces_right, pad_right)
    local label = spaces_left .. sidebar.label .. spaces_right
    local label_width = sidebar.label_width + pad_left + pad_right

    if label_width > sidebar_width then
      label = strcharpart(label, 0, sidebar_width)
    end

    sidebar.right = nvim_win_get_position(sidebar.winnr)[2] ~= 0

    if sidebar.right then
      sidebar.rendered_focused = "%#"
        .. config.sidebar.highlights.sep
        .. "#"
        .. sidebar.separator
        .. "%#"
        .. config.sidebar.highlights.label.focused
        .. "#"
        .. label
      sidebar.rendered_visible = "%#"
        .. config.sidebar.highlights.sep
        .. "#"
        .. sidebar.separator
        .. "%#"
        .. config.sidebar.highlights.label.visible
        .. "#"
        .. label
    else
      sidebar.rendered_focused = "%#"
        .. config.sidebar.highlights.label.focused
        .. "#"
        .. label
        .. "%#"
        .. config.sidebar.highlights.sep
        .. "#"
        .. sidebar.separator
      sidebar.rendered_visible = "%#"
        .. config.sidebar.highlights.label.visible
        .. "#"
        .. label
        .. "%#"
        .. config.sidebar.highlights.sep
        .. "#"
        .. sidebar.separator
    end
  end
  return sidebar_width + sidebar.separator_width
end

local function get_viewport_hi(index, width)
  local w = tabs_cache[index].width
  local hi = index
  for pos = hi + 1, #tabs_cache do
    local tab_width = tabs_cache[pos].width
    if w + tab_width > width then
      break
    end
    w = w + tab_width
    hi = pos
  end
  return hi, width - w
end

local function get_viewport_lo(index, width)
  local w = tabs_cache[index].width
  local lo = index
  for pos = lo - 1, 1, -1 do
    local tab_width = tabs_cache[pos].width
    if w + tab_width > width then
      break
    end
    w = w + tab_width
    lo = pos
  end
  return lo, width - w
end

local function make_prefix(left_remaining, indicator)
  if viewport.lo > 1 then
    viewport.prefix = viewport.truncate_left
    if left_remaining > 0 then
      local size = left_remaining - indicator
      if size > 0 then
        viewport.prefix = viewport.prefix .. tabs_cache[viewport.lo - 1].partial_left(size)
        -- else
        --   viewport.prefix = viewport.prefix .. string_rep(" ", left_remaining)
      end
    end
    viewport.left_reserved = left_remaining
  else
    viewport.prefix = viewport.indicator_first
    viewport.left_reserved = 0
  end
end

local function make_postfix(right_remaining, indicator)
  if viewport.hi < #tabs_cache then
    viewport.postfix = viewport.truncate_right
    if right_remaining > 0 then
      local size = right_remaining - indicator
      if size > 0 then
        viewport.postfix = tabs_cache[viewport.hi + 1].partial_right(size) .. viewport.postfix
      elseif size < 0 then
        viewport.postfix = "%#TablineFill#" .. string_rep(" ", right_remaining) .. viewport.postfix
      end
    end
    viewport.right_reserved = right_remaining
  else
    viewport.postfix = viewport.indicator_last
    viewport.right_reserved = 0
  end
end

local function compute_left_indicator()
  return viewport.lo > 1 and viewport.truncate_left_width or 0
end

local function compute_right_indicator()
  return viewport.hi < #tabs_cache and viewport.truncate_right_width or 0
end

local function compute_both_indicators()
  return compute_left_indicator() + compute_right_indicator()
end

local function compute_left_remain_from_end(width)
  viewport.right_reserved = 0
  local indicator_left = viewport.truncate_left_width
  local indicator_right = viewport.indicator_last_width
  local indicators = indicator_left + indicator_right
  local lo, left_remaining = get_viewport_lo(#tabs_cache, width - indicators)
  return lo, left_remaining + indicator_left
end

local function compute_right_remain_from_start(width)
  viewport.left_reserved = 0
  local indicator_left = viewport.indicator_first_width
  local indicator_right = viewport.truncate_right_width
  local indicators = indicator_left + indicator_right
  local hi, right_remaining = get_viewport_hi(1, width - indicators)
  return hi, right_remaining + indicator_right
end

local function gen_prefix_postfix(left_remaining, right_remaining)
  local indicator_size = compute_both_indicators()

  make_prefix(left_remaining, indicator_size)
  make_postfix(right_remaining, indicator_size)
end

local function handle_index_before(width)
  local left_remaining = 0
  local right_remaining = 0
  viewport.lo = viewport.index
  if viewport.lo == 1 then
    viewport.hi, right_remaining = compute_right_remain_from_start(width)
  else
    local indicator = viewport.truncate_left_width + viewport.truncate_right_width
    viewport.hi, right_remaining = get_viewport_hi(viewport.lo, width - indicator)
    right_remaining = right_remaining + indicator
  end
  viewport.left_reserved = 0

  gen_prefix_postfix(left_remaining, right_remaining)
end

local function handle_index_after(width)
  local left_remaining = 0
  local right_remaining = 0
  viewport.hi = viewport.index
  if viewport.hi == #tabs_cache then
    viewport.lo, left_remaining = compute_left_remain_from_end(width)
  else
    local indicator = viewport.truncate_left_width + viewport.truncate_right_width
    viewport.lo, left_remaining = get_viewport_lo(viewport.hi, width - indicator)
    left_remaining = left_remaining + indicator
  end
  viewport.right_reserved = 0

  gen_prefix_postfix(left_remaining, right_remaining)
end

local function handle_width_change(width)
  viewport_state.size_changed = false
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
        indicators = viewport.truncate_left_width + viewport.truncate_right_width
      end
      viewport.lo = viewport.index
      viewport.hi, right_remaining = get_viewport_hi(viewport.lo, width - indicators)
      if viewport.hi == #tabs_cache then
        viewport.lo, left_remaining = compute_left_remain_from_end(width)
      else
        left_remaining = indicators
        right_remaining = right_remaining + indicators
        viewport.left_reserved = 0
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
        viewport.right_reserved = 0
      end
    end
  end

  gen_prefix_postfix(left_remaining, right_remaining)
end

local function handle_tab_width_change(width)
  local left_remaining = 0
  local right_remaining = 0
  viewport_state.tab_width_changed = false

  local partial_deleted = viewport_state.buf_deleted_partial
  if partial_deleted then
    viewport_state.buf_deleted_partial = false
    viewport.lo = math_max(1, viewport.lo - 1)
  end

  if viewport.index == 1 then
    viewport.lo = viewport.index
    viewport.hi, right_remaining = compute_right_remain_from_start(width)
  elseif viewport.index == #tabs_cache then
    viewport.hi = viewport.index
    viewport.lo, left_remaining = compute_left_remain_from_end(width)
  else
    if viewport.lo == 1 then
      viewport.hi, right_remaining = compute_right_remain_from_start(width)
    elseif viewport.hi == #tabs_cache then
      viewport.lo, left_remaining = compute_left_remain_from_end(width)
    elseif partial_deleted then
      local indicators = viewport.truncate_left_width + viewport.truncate_right_width
      viewport.hi, right_remaining = get_viewport_hi(viewport.lo, width - indicators)
      if viewport.hi == #tabs_cache then
        viewport.lo, left_remaining = compute_left_remain_from_end(width)
        right_remaining = 0
      else
        right_remaining = right_remaining + indicators
        left_remaining = indicators
        viewport.left_reserved = 0
      end
    else
      local indicators = viewport.truncate_left_width + viewport.truncate_right_width
      if viewport.index == viewport.hi then
        if viewport.right_reserved == 0 then
          viewport.lo, left_remaining = get_viewport_lo(viewport.hi, width - indicators)
          make_prefix(left_remaining, 0)
          return
        end
      end
      local reserved = viewport.left_reserved > 0 and viewport.left_reserved or indicators
      viewport.hi, right_remaining = get_viewport_hi(viewport.lo, width - reserved)
      make_prefix(viewport.left_reserved, indicators)
      make_postfix(right_remaining, 0)
      return
    end
  end

  gen_prefix_postfix(left_remaining, right_remaining)
end

---@param width integer
local function calc_truncated_tabs(width)
  if viewport.index > viewport.hi then
    handle_index_after(width)
  elseif viewport.index < viewport.lo then
    handle_index_before(width)
  elseif viewport_state.size_changed then
    handle_width_change(width)
  elseif viewport_state.tab_width_changed then
    handle_tab_width_change(width)
  else
    if viewport_state.partial_left_redraw then
      make_prefix(viewport.left_reserved, 0)
      viewport_state.partial_left_redraw = false
    end
    if viewport_state.partial_right_redraw then
      make_postfix(viewport.right_reserved, 0)
      viewport_state.partial_right_redraw = false
    end
  end
end

function I.GalfoRender()
  if
    viewport_state.updated
    or viewport_state.simple_redraw
    or viewport_state.size_changed
    or viewport_state.tab_width_changed
  then
    if sidebar.winnr and nvim_get_current_win() == sidebar.winnr then
      sidebar.focus = true
      viewport.buf = -1
    end

    local current_tab = tabs_cache[viewport.index]

    if current_tab == nil then
      init_bufs()
      viewport.index = buf_index[viewport.buf]
      current_tab = tabs_cache[viewport.index]
    end

    if not sidebar.focus and current_tab.visibility ~= STATES.FOCUSED then
      current_tab.visibility = STATES.FOCUSED
      if current_tab.set_new_display() then
        viewport_state.tab_width_changed = true
      end
    end

    local indicators = 0

    local width = viewport.width - viewport.sidebar_width

    if viewport_state.simple_redraw and not viewport_state.updated and not viewport_state.tab_shrink then
      viewport_state.simple_redraw = false
      goto build_viewport_str
    end

    if viewport.total_tabs_width > width then
      calc_truncated_tabs(width)
    else
      viewport.lo = 1
      viewport.hi = #tabs_cache
      viewport.prefix = viewport.indicator_first
      viewport.postfix = ""
      viewport.left_reserved = 0
      viewport.right_reserved = 0
    end

    if viewport.lo == 1 then
      indicators = viewport.indicator_first_width + viewport.truncate_right_width
    elseif viewport.hi == #tabs_cache then
      indicators = viewport.truncate_left_width + viewport.indicator_last_width
    else
      indicators = viewport.truncate_left_width + viewport.truncate_right_width
    end

    viewport_state.tab_shrink = current_tab and current_tab.width > width - indicators

    if viewport_state.tab_shrink then
      local available = width
      viewport.lo = viewport.index
      viewport.hi = viewport.index
      if viewport.hi == #tabs_cache then
        viewport.prefix = viewport.truncate_left
        viewport.postfix = viewport.indicator_last
        available = available - viewport.truncate_left_width - viewport.indicator_last_width
      elseif viewport.lo == 1 then
        viewport.prefix = viewport.indicator_first
        viewport.postfix = viewport.truncate_right
        available = available - viewport.indicator_first_width - viewport.truncate_right_width
      else
        viewport.prefix = viewport.truncate_left
        viewport.postfix = viewport.truncate_right
        available = width - indicators
      end

      local buf = buf_cache[viewport.index]
      local focused = buf == viewport.buf and STATES.FOCUSED or STATES.VISIBLE
      local state = bor(focused, current_tab.modified + current_tab.severity)

      local pad = string_rep(" ", math_max(0, available - current_tab.rendered[state].width))
      viewport.tab_shrink_str = current_tab.partial_left(available, focused) .. pad
    end

    ::build_viewport_str::

    local sidebar_str = ""
    if viewport.sidebar_width > 0 then
      sidebar_str = sidebar.focus and sidebar.rendered_focused or sidebar.rendered_visible
    end

    local tabs = {}
    if not sidebar.right then
      tabs[#tabs + 1] = sidebar_str
    end
    tabs[#tabs + 1] = viewport.prefix

    local filled_spaces = 0
    if viewport_state.tab_shrink then
      tabs[#tabs + 1] = viewport.tab_shrink_str
    else
      for i = viewport.lo, viewport.hi do
        ---@type Tab
        local tab = tabs_cache[i]
        tabs[#tabs + 1] = tab.display
        filled_spaces = filled_spaces + tab.width
      end
    end

    tabs[#tabs + 1] = viewport.postfix
    tabs[#tabs + 1] = viewport.endfix

    if sidebar.right then
      local pad = ""
      if not viewport_state.tab_shrink then
        if viewport.total_tabs_width > width then
          if viewport.lo == 1 then
            indicators = viewport.indicator_first_width + compute_right_indicator()
          elseif viewport.hi == #tabs_cache then
            indicators = compute_left_indicator() + viewport.indicator_last_width
          else
            indicators = compute_both_indicators()
          end
        else
          indicators = viewport.indicator_first_width
        end
        local remaining =
          math_max(0, width - viewport.left_reserved - viewport.right_reserved - filled_spaces - indicators)
        pad = make_spaces(cached_pad_tab, sidebar_spaces_tab, remaining)
      end

      tabs[#tabs + 1] = pad .. sidebar_str
    end

    viewport_state.updated = false
    viewport.display = table_concat(tabs)
  end
  return viewport.display
end

function Galfo.prev_tab()
  if sidebar.focus then
    return
  end

  local i = get_current_index()
  if i > 1 then
    nvim_set_current_buf(buf_cache[i - 1])
  end
end

function Galfo.next_tab()
  if sidebar.focus then
    return
  end

  local i = get_current_index()
  if i < #buf_cache then
    nvim_set_current_buf(buf_cache[i + 1])
  end
end

function Galfo.prev_tab_cycle()
  if sidebar.focus then
    return
  end

  local n = #tabs_cache
  local i = ((get_current_index() - 2) % n) + 1
  nvim_set_current_buf(buf_cache[i])
end

function Galfo.next_tab_cycle()
  if sidebar.focus then
    return
  end

  local n = #tabs_cache
  local i = (get_current_index() % n) + 1
  nvim_set_current_buf(buf_cache[i])
end

function Galfo.move_to_begin()
  if sidebar.focus then
    return
  end

  local buf = buf_cache[1]
  nvim_set_current_buf(buf)
end

function Galfo.move_to_end()
  if sidebar.focus then
    return
  end

  local buf = buf_cache[#buf_cache]
  nvim_set_current_buf(buf)
end

local function swap(i, j)
  buf_cache[i], buf_cache[j] = buf_cache[j], buf_cache[i]
  tabs_cache[i], tabs_cache[j] = tabs_cache[j], tabs_cache[i]
  buf_index[buf_cache[i]] = i
  buf_index[buf_cache[j]] = j

  if I.dynamic.index then
    tabs_cache[i].rerender()
    tabs_cache[j].rerender()

    local tab_i_changed = tabs_cache[i].set_new_display()
    local tab_j_changed = tabs_cache[j].set_new_display()

    if tab_i_changed or tab_j_changed then
      viewport_state.tab_width_changed = true
    else
      viewport_state.simple_redraw = true
    end
  end

  viewport.index = j
  viewport_state.updated = true
  redrawtabline()
end

function Galfo.move_tab_left()
  if sidebar.focus then
    return
  end

  local i = get_current_index()
  if i > 1 then
    swap(i, i - 1)
  end
end

function Galfo.move_tab_right()
  if sidebar.focus then
    return
  end

  local i = get_current_index()
  if i < #buf_cache then
    swap(i, i + 1)
  end
end

function Galfo.move_tab_left_cycle()
  if sidebar.focus then
    return
  end

  local i = get_current_index()
  if i > 1 then
    swap(i, i - 1)
  else
    Galfo.move_tab_end()
  end
end

function Galfo.move_tab_right_cycle()
  if sidebar.focus then
    return
  end

  local i = get_current_index()
  if i < #buf_cache then
    swap(i, i + 1)
  else
    Galfo.move_tab_begin()
  end
end

function Galfo.move_tab_begin()
  if sidebar.focus then
    return
  end

  local i = get_current_index()
  if i > 1 then
    local b = table_remove(buf_cache, i)
    table_insert(buf_cache, 1, b)
    local t = table_remove(tabs_cache, i)
    table_insert(tabs_cache, 1, t)
    update_buf_index()

    if I.dynamic.index then
      for index = i, 1, -1 do
        tabs_cache[index].rerender()
        tabs_cache[index].set_new_display()
      end
      viewport_state.tab_width_changed = true
    end

    redrawtabline()
  end
end

function Galfo.move_tab_end()
  if sidebar.focus then
    return
  end

  local i = get_current_index()
  if i < #buf_cache then
    local b = table_remove(buf_cache, i)
    buf_cache[#buf_cache + 1] = b
    local t = table_remove(tabs_cache, i)
    tabs_cache[#tabs_cache + 1] = t
    update_buf_index()

    if I.dynamic.index then
      for index = i, #tabs_cache do
        tabs_cache[index].rerender()
        tabs_cache[index].set_new_display()
      end
      viewport_state.tab_width_changed = true
    end

    redrawtabline()
  end
end

function Galfo.close_tab(bufnr, force)
  bufnr = bufnr == 0 and nvim_get_current_buf() or bufnr
  local index = buf_index[bufnr]
  if not index or tabs_pin_cache[bufnr] then
    return
  end

  if not force and bo[bufnr].modified then
    local choice = fn.confirm("Unsaved changes:", "&Save\n&Discard\n&Cancel", 1)
    if choice == 1 then
      pcall(nvim_buf_call, bufnr, function()
        vim.cmd.write()
      end)
      Galfo.close_tab(bufnr, true)
    elseif choice == 2 then
      Galfo.close_tab(bufnr, true)
    end
    return
  end

  remove_buf_from_tabline(bufnr)

  if nvim_buf_is_valid(bufnr) then
    nvim_buf_delete(bufnr, { force = true })
  end
end

function Galfo.close_tab_left(force)
  local bufnr = buf_cache[viewport.index - 1]
  if not bufnr then
    return
  end

  viewport_state.should_not_focus = true
  Galfo.close_tab(bufnr, force)
  viewport_state.should_not_focus = false
end

function Galfo.close_tab_right(force)
  local bufnr = buf_cache[viewport.index + 1]
  if not bufnr then
    return
  end

  viewport_state.should_not_focus = true
  Galfo.close_tab(bufnr, force)
  viewport_state.should_not_focus = false
end

function Galfo.close_all_tab_left(force)
  for i = viewport.index - 1, 1, -1 do
    local bufnr = buf_cache[i]
    if not bufnr then
      return
    end

    viewport_state.should_not_focus = true
    Galfo.close_tab(bufnr, force)
    viewport_state.should_not_focus = false

    viewport.lo = viewport.index
  end
end

function Galfo.close_all_tab_right(force)
  for i = #tabs_cache, viewport.index + 1, -1 do
    local bufnr = buf_cache[i]
    if not bufnr then
      return
    end

    viewport_state.should_not_focus = true
    Galfo.close_tab(bufnr, force)
    viewport_state.should_not_focus = false

    viewport.hi = viewport.index
  end
end

function Galfo.close_all_tabs(force)
  for i = #tabs_cache, 1, -1 do
    local bufnr = buf_cache[i]
    if not bufnr then
      return
    end

    viewport_state.should_not_focus = true
    Galfo.close_tab(bufnr, force)
    viewport_state.should_not_focus = false
  end
end

function Galfo.toggle_pin(bufnr)
  bufnr = bufnr == 0 and nvim_get_current_buf() or bufnr
  local index = buf_index[bufnr]
  if not index then
    return
  end

  tabs_pin_cache[bufnr] = not tabs_pin_cache[bufnr] and true or nil

  -- If not do this when pinning the first Scratch buffer
  -- the next buffer open, opens in that tab.
  -- Better than spread the logic across autocmds.
  if bo[bufnr].filetype == "" then
    bo[bufnr].modified = true
  end

  local tab = tabs_cache[index]
  tab.rerender()
  local width_changed = tab.set_new_display()

  if viewport.lo <= index and index <= viewport.hi then
    if width_changed then
      viewport_state.tab_width_changed = true
    else
      viewport_state.simple_redraw = true
    end
    redrawtabline()
  end
end

function Galfo.focus_by_index(index)
  local buf = buf_cache[index]
  if buf == nil then
    return
  end

  nvim_set_current_buf(buf_cache[index])
end

local function setup_autocmds()
  api.nvim_create_autocmd({ "BufReadPost" }, {
    callback = function(ev)
      local buf = ev.buf
      if
        not nvim_buf_is_valid(buf)
        or not bo[buf].buflisted
        or buf_index[buf]
        or I.ignore.buftypes[bo[buf].buftype]
        or I.ignore.filetypes[bo[buf].filetype]
        or I.ignore.bufnames[nvim_buf_get_name(buf)]
      then
        return
      end
      insert_buf_into_tabline(buf)
    end,
  })

  api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function(ev)
      if viewport_state.should_not_focus then
        return
      end
      local buf = ev.buf

      if sidebar.enabled and sidebar_filetypes[bo[buf].filetype] then
        sidebar.winnr = nvim_get_current_win()
      else
        sidebar.focus = false
        local index = buf_index[buf]
        if not index then
          return
        end

        viewport.buf = buf
        viewport.index = index
      end

      viewport_state.updated = true
    end,
  })

  api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
    callback = function(ev)
      if viewport_state.should_not_focus then
        return
      end

      local index = buf_index[ev.buf]
      if not index then
        return
      end

      local tab = tabs_cache[index]
      if not tab then
        return
      end

      tab.visibility = STATES.VISIBLE

      if tab.set_new_display() then
        if viewport.lo <= index and index <= viewport.hi then
          viewport_state.tab_width_changed = true
        end
      end
    end,
  })

  api.nvim_create_autocmd("BufDelete", {
    callback = function(ev)
      local bufnr = ev.buf
      local index = buf_index[bufnr]
      if not index or tabs_pin_cache[bufnr] then
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

        ---@type Tab
        local tab = tabs_cache[index]
        local modified = bo[ev.buf].modified and STATES.MODIFIED or 0

        if tab.modified == modified then
          return
        end

        tab.modified = modified

        tab.rerender()
        local width_changed = tab.set_new_display()

        if viewport.lo <= index and index <= viewport.hi then
          if width_changed then
            viewport_state.tab_width_changed = true
          else
            viewport_state.simple_redraw = true
          end
          redrawtabline()
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

        diag_cache[ev.buf] = diagnostic_count(ev.buf, I.diag_filter)

        ---@type Tab
        local tab = tabs_cache[index]
        local new_severity = resolve_severity(diag_cache[ev.buf])
        local old_severity = tab.severity

        local changed = old_severity ~= new_severity

        if next(I.dynamic.diagnostics) ~= nil then
          for state in pairs(I.dynamic.diagnostics) do
            if tab.rendered[state] ~= nil then
              tab.rendered[state] = nil
            end
          end
        end

        if changed then
          tab.severity = new_severity
          tab.update()
          local width_changed = tab.set_new_display()

          if viewport.lo <= index and index <= viewport.hi then
            if width_changed then
              viewport_state.tab_width_changed = true
            else
              viewport_state.simple_redraw = true
            end
            redrawtabline()
          elseif viewport.lo - 1 == index and viewport.left_reserved > 0 then
            viewport_state.partial_left_redraw = true
            viewport_state.updated = true
            redrawtabline()
          elseif viewport.hi + 1 == index and viewport.right_reserved > 0 then
            viewport_state.partial_right_redraw = true
            viewport_state.updated = true
            redrawtabline()
          end
        end
      end,
    })
  end

  api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    callback = function()
      viewport.sidebar_width = render_sidebar()
      viewport.width = vim.o.columns
      viewport_state.size_changed = true
    end,
  })

  api.nvim_create_autocmd("BufFilePost", {
    callback = function(ev)
      resolve_update_tab(ev.buf)
    end,
  })
end

_G.GalfoRender = I.GalfoRender
vim.opt.tabline = "%!v:lua.GalfoRender()"
vim.opt.showtabline = 2

_G.ComponentOnClick = function(id, clicks, button, mods)
  local bufnr = rshift(id, 16)
  local comp_index = band(id, 0xFFFF)
  local fn_handler = click_components_handlers[bufnr] and click_components_handlers[bufnr][comp_index]
  if fn_handler then
    fn_handler(bufnr, clicks, button, mods)
  end
end

_G.TabOnClick = function(bufnr, clicks, button, mods)
  local tab = {
    bufnr = bufnr,
    focus = function()
      nvim_set_current_buf(bufnr)
    end,
    close = function(force)
      Galfo.close_tab(bufnr, force)
    end,
    toggle_pin = function()
      Galfo.toggle_pin(bufnr)
    end,
  }

  local tab_fn_handler = click_tab_handlers[bufnr]
  if tab_fn_handler then
    tab_fn_handler(tab, clicks, button, mods)
  end
end

function Galfo.setup(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(config), opts or {})

  I.diag_filter = config.diagnostics.filter
  I.diag_order = config.diagnostics.order
  I.tab = {}
  I.tab.on_click = config.tab.on_click

  I.tab.force_unix_path_sep = config.force_unix_path_sep
  I.tab.scratch_buffer_name = config.scratch_buffer_name
  I.tab.last_icon_blend = config.last_icon_blend

  I.tabs = config.tabs
  I.base_highlights = config.base_highlights

  I.ignore = { buftypes = {}, filetypes = {}, bufnames = {} }
  I.ignore.terminal = config.ignore.terminal

  for _, buftype in ipairs(config.ignore.buftypes) do
    I.ignore.buftypes[buftype] = true
  end

  for _, filetype in ipairs(config.ignore.filetypes) do
    I.ignore.filetypes[filetype] = true
  end

  for _, bufname in ipairs(config.ignore.bufnames) do
    I.ignore.bufnames[bufname] = true
  end

  if config.icons.enabled then
    I.icons = {}

    local provider = config.icons.provider
    I.icons.provider = require(provider)
    I.get_icon = get_icon_fn[provider]
  end

  sidebar.separator = config.sidebar.separator
  sidebar.separator_width = nvim_strwidth(config.sidebar.separator)

  sidebar.enabled = config.sidebar.enabled

  for _, ft in ipairs(config.sidebar.filetypes) do
    sidebar_filetypes[ft] = true
  end

  if config.sidebar.label_position == "start" then
    I.sidebar_label_position = sidebar_label_start
  elseif config.sidebar.label_position == "mid" then
    I.sidebar_label_position = sidebar_label_mid
  elseif config.sidebar.label_position == "end" then
    I.sidebar_label_position = sidebar_label_end
  else
    I.sidebar_label_position = sidebar_label_mid
  end

  sidebar.label = config.sidebar.label
  sidebar.label_width = nvim_strwidth(sidebar.label)

  if config.focus_on_click then
    I.focus_on_click = config.focus_on_click
  end

  viewport.truncate_left = "%#"
    .. config.indicators.truncate_left.highlight
    .. "#"
    .. config.indicators.truncate_left.text
  viewport.truncate_right = "%#"
    .. config.indicators.truncate_right.highlight
    .. "#"
    .. config.indicators.truncate_right.text

  viewport.truncate_left_width = nvim_strwidth(config.indicators.truncate_left.text)
  viewport.truncate_right_width = nvim_strwidth(config.indicators.truncate_right.text)

  viewport.indicator_first = "%#" .. config.indicators.first.highlight .. "#" .. config.indicators.first.text
  viewport.indicator_last = "%#" .. config.indicators.last.highlight .. "#" .. config.indicators.last.text

  viewport.indicator_first_width = nvim_strwidth(config.indicators.first.text)
  viewport.indicator_last_width = nvim_strwidth(config.indicators.last.text)

  viewport.sidebar_width = render_sidebar()
  viewport.width = vim.o.columns

  I.buf_queue = {}

  I.dynamic = {
    diagnostics = {},
  }

  init_dynamic(config.dynamic)
  init_bufs()
  setup_autocmds()

  if opts and type(opts.on_buf_replaced) == "function" then
    I.on_buf_replaced = opts.on_buf_replaced
  end
end

return Galfo
