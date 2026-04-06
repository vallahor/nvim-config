vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })
-- Statusline

-- https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/statusline.lua#L557
local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

local modes = setmetatable({
  ["n"] = { short = "N", hl = "MiniStatuslineModeNormal" },
  ["v"] = { short = "V", hl = "MiniStatuslineModeVisual" },
  ["V"] = { short = "V-L", hl = "MiniStatuslineModeVisual" },
  [CTRL_V] = { short = "V-B", hl = "MiniStatuslineModeVisual" },
  ["s"] = { short = "S", hl = "MiniStatuslineModeVisual" },
  ["S"] = { short = "S-L", hl = "MiniStatuslineModeVisual" },
  [CTRL_S] = { short = "S-B", hl = "MiniStatuslineModeVisual" },
  ["i"] = { short = "I", hl = "MiniStatuslineModeInsert" },
  ["R"] = { short = "R", hl = "MiniStatuslineModeReplace" },
  ["c"] = { short = "C", hl = "MiniStatuslineModeCommand" },
  ["r"] = { short = "P", hl = "MiniStatuslineModeOther" },
  ["!"] = { short = "Sh", hl = "MiniStatuslineModeOther" },
  ["t"] = { short = "T", hl = "MiniStatuslineModeOther" },
  ["no"] = { short = "O", hl = "MiniStatuslineModeOther" },
}, {
  __index = function()
    return { short = "U", hl = "MiniStatuslineModeOther" }
  end,
})

local MiniStatusline = require("mini.statusline")
local location = "L%l/%L C%c"
local get_filename = function()
  if vim.bo.buftype == "terminal" then
    return "%t"
  end
  local fname = vim.fn.expand("%:.")
  return (fname ~= "" and fname .. " " or "") .. "%m%r"
end
MiniStatusline.setup({
  use_icons = false,
  content = {
    active = function()
      local mode_info = modes[vim.api.nvim_get_mode().mode]
      local mode, mode_hl = mode_info.short, mode_info.hl

      local filename = get_filename()

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { strings = { "%S" } },
        { strings = { vim.bo.filetype } },
        { hl = mode_hl, strings = { location } },
      })
    end,
    inactive = function()
      local filename = get_filename()
      return MiniStatusline.combine_groups({
        { hl = "MiniStatuslineModeNormal", strings = { "-" } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { strings = { "%S" } },
        { strings = { vim.bo.filetype } },
        { strings = { location } },
      })
    end,
  },
})

-- Buf Remove
local bufremove = require("mini.bufremove")
bufremove.setup()

vim.keymap.set("n", "<c-w>", function()
  _G.MiniBufremove.delete(0, false)
end)
vim.keymap.set("n", "<c-x>", function()
  _G.MiniBufremove.delete(0, true)
end)

-- closes the current window and buffer
-- to close the current buffer and not the window use <c-w>
vim.keymap.set("n", "<c-s-x>", vim.cmd.bdelete()) -- close current buffer and window -- not work with ghostty (combination in use)

-- Cursor Word
require("mini.cursorword").setup({
  delay = 0,
})

vim.api.nvim_set_hl(0, "MiniCursorword", {
  sp = "none",
  fg = "none",
  bg = "#2D2829",
})
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {
  sp = "none",
  fg = "none",
  bg = "#2D2829",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "neo-tree", "SidebarNvim" },
  callback = function()
    vim.b.ministatusline_disable = true
    vim.b.minicursorword_disable = true
  end,
})

local MiniIcons = require("mini.icons")
MiniIcons.setup()
MiniIcons.mock_nvim_web_devicons()

vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = "#51a0cf" })
vim.api.nvim_set_hl(0, "MiniIconsBlue", { fg = "#51a0cf" })
vim.api.nvim_set_hl(0, "MiniIconsCyan", { fg = "#00bfff" })
vim.api.nvim_set_hl(0, "MiniIconsGreen", { fg = "#8fbc8f" })
vim.api.nvim_set_hl(0, "MiniIconsGrey", { fg = "#9e9e9e" })
vim.api.nvim_set_hl(0, "MiniIconsOrange", { fg = "#d18b5f" })
vim.api.nvim_set_hl(0, "MiniIconsPurple", { fg = "#9b59b6" })
vim.api.nvim_set_hl(0, "MiniIconsRed", { fg = "#cc6666" })
vim.api.nvim_set_hl(0, "MiniIconsWhite", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = "#f0c674" })

local devicons = require("nvim-web-devicons")
local _get_icon = devicons.get_icon
devicons.get_icon = function(name, ext, opts)
  local icon, hl = _get_icon(name, ext, opts)
  if icon then
    return icon, hl
  end
  local dir_icon, dir_hl = MiniIcons.get("directory", name or "")
  return dir_icon, dir_hl
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local api, fn, bo = vim.api, vim.fn, vim.bo
    local floor, strwidth, fnamemodify = math.floor, fn.strwidth, fn.fnamemodify

    local function get_hex(group, attr)
      local ok, val = pcall(api.nvim_get_hl, 0, { name = group, link = false })
      if not ok or not val then
        return
      end
      local n = (attr == "fg") and val.fg or val.bg
      return n and string.format("#%06x", n)
    end

    local dim_fg = "#7e706c"
    local focused_bg = "#3f303f"
    local hidden_bg = "#191319"

    local function set_hls()
      local normal_fg = get_hex("Normal", "fg")
      local win_sep_fg = get_hex("WinSeparator", "fg")
      local errors_fg = get_hex("DiagnosticError", "fg")
      local warning_fg = get_hex("DiagnosticWarn", "fg")
      local hl = api.nvim_set_hl
      hl(0, "MiniTablineCurrent", { fg = normal_fg, bg = focused_bg })
      hl(0, "MiniTablineVisible", { fg = dim_fg, bg = hidden_bg })
      hl(0, "MiniTablineHidden", { fg = dim_fg, bg = hidden_bg })
      hl(0, "MiniTablineModifiedCurrent", { fg = normal_fg, bg = focused_bg, italic = true })
      hl(0, "MiniTablineModifiedVisible", { fg = dim_fg, bg = hidden_bg, italic = true })
      hl(0, "MiniTablineModifiedHidden", { fg = dim_fg, bg = hidden_bg, italic = true })
      hl(0, "MiniTablineFill", { bg = hidden_bg })
      hl(0, "MiniTablineSidebarLabelFocused", { fg = normal_fg, bg = focused_bg })
      hl(0, "MiniTablineSidebarLabelHidden", { fg = normal_fg, bg = hidden_bg })
      hl(0, "MiniTablineSidebarSep", { fg = win_sep_fg, bg = hidden_bg })
      hl(0, "MiniTablineDiagError", { fg = errors_fg, bg = focused_bg })
      hl(0, "MiniTablineDiagErrorHid", { fg = errors_fg, bg = hidden_bg })
      hl(0, "MiniTablineDiagWarn", { fg = warning_fg, bg = focused_bg })
      hl(0, "MiniTablineDiagWarnHid", { fg = warning_fg, bg = hidden_bg })
      hl(0, "MiniTablineDiagModifiedError", { fg = errors_fg, bg = focused_bg, italic = true })
      hl(0, "MiniTablineDiagModifiedErrorHid", { fg = errors_fg, bg = hidden_bg, italic = true })
      hl(0, "MiniTablineDiagModifiedWarn", { fg = warning_fg, bg = focused_bg, italic = true })
      hl(0, "MiniTablineDiagModifiedWarnHid", { fg = warning_fg, bg = hidden_bg, italic = true })
    end

    set_hls()
    api.nvim_create_autocmd("ColorScheme", { callback = set_hls })

    local buf_order = {}
    local buf_lookup = {}

    local function rebuild_buf_order()
      buf_order = {}
      buf_lookup = {}
      for _, b in ipairs(api.nvim_list_bufs()) do
        if bo[b].buflisted then
          buf_order[#buf_order + 1] = b
          buf_lookup[b] = true
        end
      end
    end

    rebuild_buf_order()

    local last_focus_buf = buf_order[1] or api.nvim_get_current_buf()

    api.nvim_create_autocmd("BufEnter", {
      callback = function()
        local b = api.nvim_get_current_buf()
        if bo[b].buflisted then
          last_focus_buf = b
          if not buf_lookup[b] then
            buf_order[#buf_order + 1] = b
            buf_lookup[b] = true
            vim.cmd.redrawtabline()
          end
        end
      end,
    })

    api.nvim_create_autocmd("BufDelete", {
      callback = function(args)
        local deleted = tonumber(args.buf) --[[@as integer]]
        if not buf_lookup[deleted] then
          return
        end
        buf_lookup[deleted] = nil
        local idx
        for i, b in ipairs(buf_order) do
          if b == deleted then
            idx = i
            table.remove(buf_order, i)
            break
          end
        end
        if last_focus_buf == deleted then
          local next_idx = math.min(idx or 1, #buf_order)
          last_focus_buf = buf_order[next_idx] or api.nvim_get_current_buf()
        end
        vim.cmd.redrawtabline()
      end,
    })

    -- make unique names (add parent dir to differ equal filenames)
    local function make_unique(namemap)
      local counts = {}
      for _, n in pairs(namemap) do
        counts[n] = (counts[n] or 0) + 1
      end
      for b, n in pairs(namemap) do
        if counts[n] > 1 then
          namemap[b] = fnamemodify(api.nvim_buf_get_name(b), ":~:."):gsub("^%./", "")
        end
      end
    end

    -- nvim_tree
    local nvim_tree_view = require("nvim-tree.view")
    local explorer_label = "Explorer"
    local explorer_label_len = strwidth(explorer_label)

    -- tabline
    local function make_tabline()
      local cur_win = api.nvim_get_current_win()
      local tree_winnr = nvim_tree_view.get_winnr() --[[@as integer?]]
      local in_tree = tree_winnr ~= nil and cur_win == tree_winnr
      local cur_buf = in_tree and -1 or api.nvim_get_current_buf()

      -- Sidebar
      local sidebar = ""
      local sidebar_width = 0
      if tree_winnr then
        sidebar_width = api.nvim_win_get_width(tree_winnr)
        local pad = math.max(0, floor((sidebar_width - explorer_label_len) / 2))
        local sidebar_hl = in_tree and "%#MiniTablineSidebarLabelFocused#" or "%#MiniTablineSidebarLabelHidden#"
        local spaces = string.rep(" ", pad)
        sidebar = sidebar_hl .. spaces .. explorer_label .. spaces .. "%#MiniTablineSidebarSep#│"
      end

      -- Names
      local names = {}
      for _, b in ipairs(buf_order) do
        local name = api.nvim_buf_get_name(b)
        names[b] = name ~= "" and fnamemodify(name, ":t") or "[No Name]"
      end
      make_unique(names)

      -- Visible windows
      local visible_bufs = {}
      for _, w in ipairs(api.nvim_list_wins()) do
        visible_bufs[api.nvim_win_get_buf(w)] = true
      end

      local avail = vim.o.columns - sidebar_width - (tree_winnr and 1 or 0)
      local tabs = {}
      local total_w = 0

      for _, b in ipairs(buf_order) do
        local label = " " .. names[b] .. " "
        local w = strwidth(label)
        local focused = b == cur_buf
        local visible = visible_bufs[b] and not focused
        local modified = api.nvim_get_option_value("modified", { buf = b })

        local diags = vim.diagnostic.get(b)
        local errors, warnings = 0, 0
        for _, d in ipairs(diags) do
          if d.severity == 1 then
            errors = errors + 1
          elseif d.severity == 2 then
            warnings = warnings + 1
          end
        end

        local hl
        if errors > 0 then
          hl = modified and (focused and "%#MiniTablineDiagModifiedError#" or "%#MiniTablineDiagModifiedErrorHid#")
            or (focused and "%#MiniTablineDiagError#" or "%#MiniTablineDiagErrorHid#")
        elseif warnings > 0 then
          hl = modified and (focused and "%#MiniTablineDiagModifiedWarn#" or "%#MiniTablineDiagModifiedWarnHid#")
            or (focused and "%#MiniTablineDiagWarn#" or "%#MiniTablineDiagWarnHid#")
        elseif modified then
          hl = focused and "%#MiniTablineModifiedCurrent#"
            or visible and "%#MiniTablineModifiedVisible#"
            or "%#MiniTablineModifiedHidden#"
        else
          hl = focused and "%#MiniTablineCurrent#" or visible and "%#MiniTablineVisible#" or "%#MiniTablineHidden#"
        end

        tabs[#tabs + 1] = { str = hl .. label, w = w, focused = focused }
        total_w = total_w + w
      end

      -- Centered truncation
      local focus_idx = 1
      for i, t in ipairs(tabs) do
        if t.focused then
          focus_idx = i
          break
        end
      end

      local result_tabs = tabs
      if total_w > avail then
        local kept = { tabs[focus_idx] }
        local w = tabs[focus_idx].w
        local lo, hi = focus_idx - 1, focus_idx + 1
        while true do
          local added = false
          if hi <= #tabs and w + tabs[hi].w <= avail then
            w = w + tabs[hi].w
            kept[#kept + 1] = tabs[hi]
            hi = hi + 1
            added = true
          end
          if lo >= 1 and w + tabs[lo].w <= avail then
            w = w + tabs[lo].w
            table.insert(kept, 1, tabs[lo])
            lo = lo - 1
            added = true
          end
          if not added then
            break
          end
        end
        result_tabs = kept
      end

      local parts = { sidebar }
      for _, t in ipairs(result_tabs) do
        parts[#parts + 1] = t.str
      end
      parts[#parts + 1] = "%#MiniTablineFill#"
      return table.concat(parts)
    end

    require("mini.tabline").setup({ show_icons = false })
    _G.MiniTabline.make_tabline_string = make_tabline
    vim.opt.tabline = "%!v:lua.MiniTabline.make_tabline_string()"
    vim.opt.showtabline = 2

    -- navigation
    local function is_nvim_tree()
      return api.nvim_get_current_win() == nvim_tree_view.get_winnr()
    end

    local function get_current_index()
      local cur = api.nvim_get_current_buf()
      for i, b in ipairs(buf_order) do
        if b == cur then
          return i
        end
      end
      return 1
    end

    local function prev_tab()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i > 1 then
        api.nvim_set_current_buf(buf_order[i - 1] --[[@as integer]])
      end
    end

    local function next_tab()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i < #buf_order then
        api.nvim_set_current_buf(buf_order[i + 1] --[[@as integer]])
      end
    end

    local function move_to_begin()
      if is_nvim_tree() then
        return
      end
      api.nvim_set_current_buf(buf_order[1] --[[@as integer]])
    end

    local function move_to_end()
      if is_nvim_tree() then
        return
      end
      api.nvim_set_current_buf(buf_order[#buf_order] --[[@as integer]])
    end

    local function swap(i, j)
      buf_order[i], buf_order[j] = buf_order[j], buf_order[i]
      vim.cmd.redrawtabline()
    end

    local function move_tab_left()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i > 1 then
        swap(i, i - 1)
      end
    end

    local function move_tab_right()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i < #buf_order then
        swap(i, i + 1)
      end
    end

    local function move_tab_begin()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i > 1 then
        local b = table.remove(buf_order, i)
        table.insert(buf_order, 1, b)
        vim.cmd.redrawtabline()
      end
    end

    local function move_tab_end()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i < #buf_order then
        local b = table.remove(buf_order, i)
        buf_order[#buf_order + 1] = b
        vim.cmd.redrawtabline()
      end
    end

    vim.keymap.set("n", "<home>", prev_tab, { silent = true })
    vim.keymap.set("n", "<end>", next_tab, { silent = true })
    vim.keymap.set("n", "<s-home>", move_to_begin, { silent = true })
    vim.keymap.set("n", "<s-end>", move_to_end, { silent = true })
    vim.keymap.set("n", "<c-home>", move_tab_left, { silent = true })
    vim.keymap.set("n", "<c-end>", move_tab_right, { silent = true })
    vim.keymap.set("n", "<c-s-home>", move_tab_begin, { silent = true })
    vim.keymap.set("n", "<c-s-end>", move_tab_end, { silent = true })
  end,
})
