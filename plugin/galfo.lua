-- vim.opt.runtimepath:prepend("C:/projects/galfo")
vim.pack.add({ "https://github.com/vallahor/galfo" })

local cursor_line_active = "CursorLine:CursorLine,CursorLineNr:CursorLineNr"
local cursor_line_inactive = "CursorLine:CursorLineInative,CursorLineNr:CursorLineNrInative"

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local galfo = require("galfo")
    local focused = galfo.get_hex("TablineFocused")
    local fill = galfo.get_hex("TablineFill")
    local diag_error = galfo.get_hex("DiagnosticError")
    local diag_warn = galfo.get_hex("DiagnosticWarn")

    local focused_modified = galfo.derive_hl("TablineFocused", { italic = true })
    local visible_modified = galfo.derive_hl("TablineVisible", { italic = true })
    local sidebar_focused_label = galfo.derive_hl("TablineFocused", {})
    local sidebar_visible_label = galfo.derive_hl("TablineVisible", { fg = focused.fg })
    local sidebar_sep = galfo.derive_hl("WinSeparator", { bg = fill.bg })
    local indicator_sep = galfo.derive_hl("TablineVisible", { bg = fill.bg })
    local focused_separator = galfo.derive_hl("TablineFocused", { fg = fill.bg })
    local visible_separator = galfo.derive_hl("TablineVisible", { fg = fill.bg })
    local focused_diag_error = galfo.derive_hl("TablineFocused", { fg = diag_error.fg })
    local visible_diag_error = galfo.derive_hl("TablineVisible", { fg = diag_error.fg })
    local focused_diag_warn = galfo.derive_hl("TablineFocused", { fg = diag_warn.fg })
    local visible_diag_warn = galfo.derive_hl("TablineVisible", { fg = diag_warn.fg })
    local focused_diag_mod_error = galfo.derive_hl("TablineFocused", { fg = diag_error.fg, italic = true })
    local visible_diag_mod_error = galfo.derive_hl("TablineVisible", { fg = diag_error.fg, italic = true })
    local focused_diag_mod_warn = galfo.derive_hl("TablineFocused", { fg = diag_warn.fg, italic = true })
    local visible_diag_mod_warn = galfo.derive_hl("TablineVisible", { fg = diag_warn.fg, italic = true })

    galfo.setup({
      base_highlights = {
        visible = { default = "TablineVisible", modified = visible_modified },
        focused = { default = "TablineFocused", modified = focused_modified },
      },
      indicators = {
        first = { text = "", highlight = indicator_sep },
        last = { text = "", highlight = indicator_sep },
        -- truncate_left = { text = "…", highlight = indicator_sep },
        -- truncate_right = { text = "…", highlight = indicator_sep },
        truncate_left = { text = " 󰁍 ", highlight = indicator_sep },
        truncate_right = { text = " 󰁔 ", highlight = indicator_sep },
      },
      sidebar = {
        highlights = {
          label = { focused = sidebar_focused_label, visible = sidebar_visible_label },
          sep = sidebar_sep,
        },
      },
      icons = {
        enabled = true,
        provider = "nvim-web-devicons.aeho",
      },
      last_icon_blend = false,
      -- dynamic = { diagnostics = true, focused = { diagnostics = false }, visible = { diagnostics = true } },
      dynamic = { index = false, diagnostics = false },
      -- tabs = {
      --   {
      --     -- static = " ",
      --     static = " ",
      --     highlights = {
      --       visible = { default = visible_separator, modified = visible_separator },
      --       -- visible = { default = focused_diag_warn, modified = focused_diag_warn },
      --       focused = { default = focused_separator, modified = focused_separator },
      --     },
      --   },
      --   {
      --     icon = function(icon, _tab)
      --       return _tab.is_pinned and "󰐃" or icon
      --       -- return icon
      --     end,
      --     on_click = function(buf)
      --       galfo.toggle_pin(buf)
      --     end,
      --     -- highlights = {
      --     --   focused = { default = focused_diag_error, modified = focused_diag_mod_error },
      --     --   visible = { default = visible_diag_error, modified = visible_diag_mod_error },
      --     -- },
      --   },
      --   { static = " " },
      --   {
      --     text = function(tab)
      --       -- tab.unique_prefix:gsub("/", "\\") -- windows way
      --       return tab.unique_prefix .. tab.name
      --       -- return tab.index
      --       --   .. ": "
      --       --   .. tab.unique_prefix
      --       --   .. tab.name
      --       --   .. (tab.is_modified and string.rep(" ", math.floor(#tab.name * 2)) or "")
      --       -- .. (tab.is_focused and string.rep(" ", #tab.name) or "")
      --       -- .. (not tab.is_focused and "               " or "")
      --       -- return tab.unique_prefix .. tab.name
      --     end,
      --     highlights = {
      --       diagnostics = {
      --         error = {
      --           focused = { default = focused_diag_error, modified = focused_diag_mod_error },
      --           visible = { default = visible_diag_error, modified = visible_diag_mod_error },
      --         },
      --         warn = {
      --           focused = { default = focused_diag_warn, modified = focused_diag_mod_warn },
      --           visible = { default = visible_diag_warn, modified = visible_diag_mod_warn },
      --         },
      --       },
      --     },
      --   },
      --   { static = " " },
      --   -- {
      --   --   text = function(info)
      --   --     return info.diagnostics[vim.diagnostic.severity.ERROR]
      --   --         and info.diagnostics[vim.diagnostic.severity.ERROR] .. " E"
      --   --       or ""
      --   --   end,
      --   --   highlights = {
      --   --     diagnostics = {
      --   --       error = {
      --   --         focused = { default = focused_diag_error, modified = focused_diag_mod_error },
      --   --         visible = { default = visible_diag_error, modified = visible_diag_mod_error },
      --   --       },
      --   --     },
      --   --   },
      --   -- },
      --   -- { static = " " },
      --   -- {
      --   --   text = function(info)
      --   --     return info.diagnostics[vim.diagnostic.severity.WARN]
      --   --         and info.diagnostics[vim.diagnostic.severity.WARN] .. " W"
      --   --       or ""
      --   --   end,
      --   --   highlights = {
      --   --     diagnostics = {
      --   --       warn = {
      --   --         focused = { default = focused_diag_warn, modified = focused_diag_mod_warn },
      --   --         visible = { default = visible_diag_warn, modified = visible_diag_mod_warn },
      --   --       },
      --   --     },
      --   --   },
      --   -- },
      --   -- { static = " " },
      --   {
      --     icon_custom = function()
      --       return "󰅖"
      --     end,
      --     on_click = function(bufnr, clicks, button, mods)
      --       galfo.close_tab(bufnr, false)
      --     end,
      --   },
      --   {
      --     static = " ",
      --     -- static = " ",
      --     -- text = function(tab)
      --     --   return not tab.is_focused and " |" or " "
      --     -- end,
      --     highlights = {
      --       visible = { default = visible_separator, modified = visible_separator },
      --       -- visible = { default = focused_diag_warn, modified = focused_diag_warn },
      --       focused = { default = focused_separator, modified = focused_separator },
      --       -- visible = { default = visible_separator, modified = visible_separator },
      --       -- focused = { default = focused_separator, modified = focused_separator },
      --     },
      --   },
      -- },
      on_buf_replaced = function(cur_win, win)
        local hl = cur_win == win and cursor_line_active or cursor_line_inactive
        vim.api.nvim_set_option_value("winhighlight", hl, { win = win })
      end,
    })

    local map = vim.keymap.set
    -- map("n", "<home>", tabline.prev_tab_cycle, { silent = true })
    -- map("n", "<end>", tabline.next_tab_cycle, { silent = true })
    map("n", "<home>", galfo.prev_tab, { silent = true })
    map("n", "<end>", galfo.next_tab, { silent = true })
    map("n", "<s-home>", galfo.move_to_begin, { silent = true })
    map("n", "<s-end>", galfo.move_to_end, { silent = true })
    -- map("n", "<c-home>", tabline.move_tab_left_cycle, { silent = true })
    -- map("n", "<c-end>", tabline.move_tab_right_cycle, { silent = true })
    map("n", "<c-home>", galfo.move_tab_left, { silent = true })
    map("n", "<c-end>", galfo.move_tab_right, { silent = true })
    map("n", "<c-s-home>", galfo.move_tab_begin, { silent = true })
    map("n", "<c-s-end>", galfo.move_tab_end, { silent = true })
    map("n", "<c-w>", function()
      galfo.close_tab(0, false)
    end, { silent = true, nowait = true })
    map("n", "<s-bs>", function()
      galfo.close_tab_left(false)
    end, { silent = true, nowait = true })
    map("n", "<s-del>", function()
      galfo.close_tab_right(false)
    end, { silent = true, nowait = true })
    map("n", "<c-s-bs>", function()
      galfo.close_all_tab_left(false)
    end, { silent = true, nowait = true })
    map("n", "<c-s-del>", function()
      galfo.close_all_tab_right(false)
    end, { silent = true, nowait = true })
    map("n", "<c-x>", function()
      galfo.close_tab(0, true)
    end, { silent = true, nowait = true })
    map("n", "<c-s-x>", function()
      galfo.close_all_tabs(false)
    end, { silent = true, nowait = true })
    map("n", "<c-s-n>", function()
      galfo.toggle_pin(0)
    end, { silent = true, nowait = true })
    map("n", "<f7>", function()
      galfo.save_session()
    end, { silent = true, nowait = true })
    map("n", "<f9>", function()
      galfo.load_session()
    end, { silent = true, nowait = true })
    -- map("n", "<c-1>", function()
    --   tabline.focus_by_index(1)
    -- end, { silent = true, nowait = true })
    -- map("n", "<c-2>", function()
    --   tabline.focus_by_index(2)
    -- end, { silent = true, nowait = true })
    -- map("n", "<c-3>", function()
    --   tabline.focus_by_index(3)
    -- end, { silent = true, nowait = true })
  end,
})
