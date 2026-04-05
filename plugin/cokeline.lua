vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim", "https://github.com/noib3/nvim-cokeline" })

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local cokeline = require("cokeline")
    local get_hex = require("cokeline.hlgroups").get_hl_attr

    local errors_fg = get_hex("DiagnosticError", "fg")
    local warning_fg = get_hex("DiagnosticWarn", "fg")
    local win_sep_fg = get_hex("WinSeparator", "fg")

    local label = "Explorer"
    local label_len = vim.fn.strwidth(label)
    local nvim_tree_view = require("nvim-tree.view")

    cokeline.setup({
      buffers = {
        filter_valid = function(buffer)
          return buffer.filename ~= "cmd.exe"
        end,
      },
      sidebar = {
        components = {
          {
            text = function()
              local winnr = nvim_tree_view.get_winnr() --[[@as integer?]]
              if winnr then
                local sidebar_width = vim.api.nvim_win_get_width(winnr)
                local pad = math.max(0, math.floor((sidebar_width - label_len) / 2))
                return string.rep(" ", pad) .. label
              end
            end,
            fg = get_hex("Normal", "fg"),
            bg = function(buffer)
              if buffer.is_focused then
                return "#3f303f"
              end
              return "#191319"
            end,
          },
        },
      },
      components = {
        {
          text = function(buffer)
            if nvim_tree_view.is_visible() and buffer.is_first then
              return "│"
            end
            return ""
          end,
          fg = function()
            return win_sep_fg
          end,
          bg = function()
            return "#191319"
          end,
        },
        {
          text = " ",
          bg = function(buffer)
            if buffer.is_focused then
              return "#3f303f"
            end
            return "#191319"
          end,
        },
        {
          text = function(buffer)
            return buffer.unique_prefix .. buffer.filename
          end,
          italic = function(buffer)
            return buffer.is_modified
          end,
          fg = function(buffer)
            if buffer.diagnostics.errors > 0 then
              return errors_fg
            elseif buffer.diagnostics.warnings > 0 then
              return warning_fg
            end
            if buffer.is_focused then
              return get_hex("Normal", "fg")
            end
            return "#7e706c"
          end,
          bg = function(buffer)
            if buffer.is_focused then
              return "#3f303f"
            end
            return "#191319"
          end,
        },
        {
          text = " ",
          bg = function(buffer)
            if buffer.is_focused then
              return "#3f303f"
            end
            return "#191319"
          end,
        },
      },
    })

    -- Re-order to previous/next
    -- vim.keymap.set("n", "<c-,>", "<Plug>(cokeline-focus-prev)", { silent = true })
    -- vim.keymap.set("n", "<c-.>", "<Plug>(cokeline-focus-next)", { silent = true })

    -- vim.keymap.set("n", "<c-<>", "<Plug>(cokeline-switch-prev)", { silent = true })
    -- vim.keymap.set("n", "<c->>", "<Plug>(cokeline-switch-next)", { silent = true })

    vim.keymap.set("n", "<home>", "<Plug>(cokeline-focus-prev)", { silent = true })
    vim.keymap.set("n", "<end>", "<Plug>(cokeline-focus-next)", { silent = true })

    vim.keymap.set("n", "<c-home>", "<Plug>(cokeline-switch-prev)", { silent = true })
    vim.keymap.set("n", "<c-end>", "<Plug>(cokeline-switch-next)", { silent = true })
  end,
})
