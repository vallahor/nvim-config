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

    local hl_colors = {
      Normal = get_hex("Normal", "fg"),
      WinSeparator = get_hex("WinSeparator", "fg"),
      DiagnosticError = get_hex("DiagnosticError", "fg"),
      DiagnosticWarn = get_hex("DiagnosticWarn", "fg"),
      dim_fg = "#7e706c",
      focused_bg = "#3f303f",
      hidden_bg = "#191319",
    }

    local hl_defs = {
      { "MiniTablineCurrent", { fg = hl_colors.Normal, bg = hl_colors.focused_bg } },
      { "MiniTablineVisible", { fg = hl_colors.dim_fg, bg = hl_colors.hidden_bg } },
      { "MiniTablineHidden", { fg = hl_colors.dim_fg, bg = hl_colors.hidden_bg } },
      { "MiniTablineModifiedCurrent", { fg = hl_colors.Normal, bg = hl_colors.focused_bg, italic = true } },
      { "MiniTablineModifiedVisible", { fg = hl_colors.dim_fg, bg = hl_colors.hidden_bg, italic = true } },
      { "MiniTablineModifiedHidden", { fg = hl_colors.dim_fg, bg = hl_colors.hidden_bg, italic = true } },
      { "MiniTablineFill", { bg = hl_colors.hidden_bg } },
      { "MiniTablineSidebarLabelFocused", { fg = hl_colors.Normal, bg = hl_colors.focused_bg } },
      { "MiniTablineSidebarLabelHidden", { fg = hl_colors.Normal, bg = hl_colors.hidden_bg } },
      { "MiniTablineSidebarSep", { fg = hl_colors.WinSeparator, bg = hl_colors.hidden_bg } },
      { "MiniTablineDiagError", { fg = hl_colors.DiagnosticError, bg = hl_colors.focused_bg } },
      { "MiniTablineDiagErrorHid", { fg = hl_colors.DiagnosticError, bg = hl_colors.hidden_bg } },
      { "MiniTablineDiagWarn", { fg = hl_colors.DiagnosticWarn, bg = hl_colors.focused_bg } },
      { "MiniTablineDiagWarnHid", { fg = hl_colors.DiagnosticWarn, bg = hl_colors.hidden_bg } },
      { "MiniTablineDiagModifiedError", { fg = hl_colors.DiagnosticError, bg = hl_colors.focused_bg, italic = true } },
      {
        "MiniTablineDiagModifiedErrorHid",
        { fg = hl_colors.DiagnosticError, bg = hl_colors.hidden_bg, italic = true },
      },
      { "MiniTablineDiagModifiedWarn", { fg = hl_colors.DiagnosticWarn, bg = hl_colors.focused_bg, italic = true } },
      { "MiniTablineDiagModifiedWarnHid", { fg = hl_colors.DiagnosticWarn, bg = hl_colors.hidden_bg, italic = true } },
    }

    local function set_hls()
      for _, v in ipairs(hl_defs) do
        api.nvim_set_hl(0, v[1], v[2])
      end
    end
    set_hls()
    api.nvim_create_autocmd("ColorScheme", { callback = set_hls })

    local buf_order = {}
    local buf_lookup = {}

    local function rebuild_buf_order()
      buf_order = {}
      buf_lookup = {}
      for _, b in ipairs(api.nvim_list_bufs()) do
        if bo[b].buflisted and api.nvim_buf_get_name(b) ~= "[No Name]" then
          buf_order[#buf_order + 1] = b
          buf_lookup[b] = true
        end
      end
      if #buf_order == 0 then
        local b = api.nvim_create_buf(true, false)
        api.nvim_buf_set_name(b, "[No Name]")
        buf_order[1] = b
        buf_lookup[b] = true
        api.nvim_set_current_buf(b)
      end
    end

    rebuild_buf_order()
    local last_focus_buf = buf_order[1]

    api.nvim_create_autocmd({ "BufDelete" }, {
      callback = function(args)
        local deleted = tonumber(args.buf)
        if buf_lookup[deleted] then
          buf_lookup[deleted] = nil
          for i, b in ipairs(buf_order) do
            if b == deleted then
              table.remove(buf_order, i)
              break
            end
          end
        end
        if last_focus_buf == deleted and #buf_order > 0 then
          last_focus_buf = buf_order[1]
          api.nvim_set_current_buf(last_focus_buf)
        end
        vim.cmd("redrawtabline")
      end,
    })

    api.nvim_create_autocmd({ "BufAdd" }, {
      callback = function(args)
        local added = tonumber(args.buf)
        if not bo[added].buflisted then
          return
        end
        if buf_lookup[added] then
          return
        end

        buf_order[#buf_order + 1] = added
        buf_lookup[added] = true
        vim.cmd("redrawtabline")
      end,
    })

    -- ======== TABLINE ========
    local nvim_tree_view = require("nvim-tree.view")
    local explorer_label = "Explorer"
    local explorer_label_len = strwidth(explorer_label)

    local function make_tabline()
      local cur_win = api.nvim_get_current_win()
      local cur_buf = api.nvim_get_current_buf()
      -- if not bo[cur_buf].buflisted then
      --   cur_buf = last_focus_buf
      -- else
      --   last_focus_buf = cur_buf
      -- end

      -- Sidebar
      local sidebar, sidebar_width = "", 0
      local tree_winnr = nvim_tree_view.get_winnr()
      if tree_winnr then
        sidebar_width = api.nvim_win_get_width(tree_winnr)
        local pad = floor((sidebar_width - explorer_label_len) / 2)
        pad = math.max(0, pad)
        local right_pad = math.max(0, sidebar_width - explorer_label_len - 2 * pad - 1)
        local spaces = string.rep(" ", pad)
        local sidebar_hl = (cur_win == tree_winnr) and "MiniTablineSidebarLabelFocused"
          or "MiniTablineSidebarLabelHidden"
        sidebar = "%#"
          .. sidebar_hl
          .. "#"
          .. spaces
          .. explorer_label
          .. spaces
          .. string.rep(" ", right_pad)
          .. "%#MiniTablineSidebarSep#│"
      end

      -- Tabs
      local tabs, total_w, visible_bufs = {}, 0, {}
      for _, w in ipairs(api.nvim_list_wins()) do
        visible_bufs[api.nvim_win_get_buf(w)] = true
      end

      for _, b in ipairs(buf_order) do
        local name = api.nvim_buf_get_name(b)
        if name == "" then
          name = "[No Name]"
        end
        local label = " " .. fnamemodify(name, ":t") .. " "
        local focused = b == cur_buf
        local visible = visible_bufs[b] and not focused
        local modified = api.nvim_get_option_value("modified", { buf = b })
        local hl = modified
            and (focused and "%#MiniTablineModifiedCurrent#" or visible and "%#MiniTablineModifiedVisible#" or "%#MiniTablineModifiedHidden#")
          or (focused and "%#MiniTablineCurrent#" or visible and "%#MiniTablineVisible#" or "%#MiniTablineHidden#")
        tabs[#tabs + 1] = { str = hl .. label, w = strwidth(label), focused = focused }
        total_w = total_w + strwidth(label)
      end

      local avail = vim.o.columns - sidebar_width
      local focus_idx = 1
      for i, t in ipairs(tabs) do
        if t.focused then
          focus_idx = i
          break
        end
      end

      local result_tabs = tabs
      if total_w > avail then
        local kept, w = { tabs[focus_idx] }, tabs[focus_idx].w
        local lo, hi = focus_idx - 1, focus_idx + 1
        while true do
          local added = false
          if hi <= #tabs and w + tabs[hi].w <= avail - 1 then
            w = w + tabs[hi].w
            kept[#kept + 1] = tabs[hi]
            hi = hi + 1
            added = true
          end
          if lo >= 1 and w + tabs[lo].w <= avail - 1 then
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

      return sidebar
        .. table.concat(vim.tbl_map(function(t)
          return t.str
        end, result_tabs))
        .. "%#MiniTablineFill#"
    end

    require("mini.tabline").setup({ show_icons = false })
    _G.MiniTabline.make_tabline_string = make_tabline
    vim.opt.tabline = "%!v:lua.MiniTabline.make_tabline_string()"
    vim.opt.showtabline = 2

    local function is_nvim_tree()
      local w = api.nvim_get_current_win()
      local tree_winnr = nvim_tree_view.get_winnr()
      return w == tree_winnr
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

    local function next_tab()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i < #buf_order then
        api.nvim_set_current_buf(buf_order[i + 1])
      end
    end

    local function prev_tab()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i > 1 then
        api.nvim_set_current_buf(buf_order[i - 1])
      end
    end

    local function move_to_begin()
      if is_nvim_tree() then
        return
      end
      api.nvim_set_current_buf(buf_order[1])
    end

    local function move_to_end()
      if is_nvim_tree() then
        return
      end
      api.nvim_set_current_buf(buf_order[#buf_order])
    end

    local function swap(i, j)
      buf_order[i], buf_order[j] = buf_order[j], buf_order[i]
      vim.cmd("redrawtabline")
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
        local b = buf_order[i]
        table.remove(buf_order, i)
        table.insert(buf_order, 1, b)
        vim.cmd("redrawtabline")
      end
    end

    local function move_tab_end()
      if is_nvim_tree() then
        return
      end
      local i = get_current_index()
      if i < #buf_order then
        local b = buf_order[i]
        table.remove(buf_order, i)
        table.insert(buf_order, b)
        vim.cmd("redrawtabline")
      end
    end

    -- Keymaps
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
