return {
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Comment
      require("mini.comment").setup({
        options = {
          ignore_blank_line = true,
          custom_commentstring = function()
            return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
          end,
        },
        hooks = {
          pre = function()
            require("ts_context_commentstring.internal").update_commentstring({})
          end,
        },
        mappings = {
          comment = "gc",
          comment_line = "gc",
          comment_visual = "gc",
        },
      })

      vim.cmd([[
          autocmd FileType gdscript setlocal commentstring=#\ %s
          autocmd FileType c setlocal commentstring=//\ %s
          autocmd FileType cs setlocal commentstring=//\ %s
          autocmd FileType cpp setlocal commentstring=//\ %s
          autocmd FileType odin setlocal commentstring=//\ %s
      ]])

      if not vim.g.skeletyl then
        require("mini.move").setup({
          mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = "",
            right = "",
            down = "J",
            up = "K",

            -- Move current line in Normal mode
            line_left = "",
            line_right = "",
            line_down = "",
            line_up = "",
          },
        })
      else
        require("mini.move").setup({
          mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = "",
            right = "",
            down = "<down>",
            up = "<up>",

            -- Move current line in Normal mode
            line_left = "",
            line_right = "",
            line_down = "",
            line_up = "",
          },
        })
      end

      -- Statusline
      local MiniStatusline = require("mini.statusline")
      local location = " L%l/%L C%c "
      MiniStatusline.setup({
        use_icons = false,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })

            local filename = MiniStatusline.section_filename({ trunc_width = 200 })

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              -- { hl = mode_hl, strings = { mode:sub(1, 1) } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { strings = { "%S" } },
              { strings = { vim.bo.filetype } },
              { hl = mode_hl, strings = { location } },
            })
          end,
          inactive = function()
            local filename = MiniStatusline.section_filename({ trunc_width = 200 })

            return MiniStatusline.combine_groups({
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { strings = { location } },
            })
          end,
        },
      })

      -- Buf Remove
      require("mini.bufremove").setup()

      if vim.g.skeletyl then
        vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>")
        vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")
        vim.keymap.set("n", "<c-x>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")
      else
        vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>")
        vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")
      end

      -- Cursor Word
      require("mini.cursorword").setup({
        delay = 0,
      })

      vim.api.nvim_create_autocmd(
        "FileType",
        { pattern = { "NvimTree" }, command = "lua vim.b.minicursorword_disable=true" }
      )

      -- vim.cmd([[
      -- " hi MiniCursorword        guisp=none guifg=none guibg=#1c212f gui=none
      -- " hi MiniCursorwordCurrent guisp=none guifg=none guibg=#1c212f gui=none
      -- " hi MiniCursorword        guisp=none guifg=none guibg=#2D2829 gui=none
      -- " hi MiniCursorwordCurrent guisp=none guifg=none guibg=#2D2829 gui=none
      -- " hi MiniCursorword        guisp=#87787b guifg=none guibg=none gui=underline
      -- " hi MiniCursorwordCurrent guisp=#87787b guifg=none guibg=none gui=underline
      -- " hi MiniCursorword        guisp=#312531 guifg=none guibg=none gui=none
      -- " hi MiniCursorwordCurrent guisp=#312531 guifg=none guibg=none gui=none
      -- ]])

      require("mini.icons").setup()
      local MiniIcons = require("mini.icons")
      MiniIcons.mock_nvim_web_devicons()

      require("mini.notify").setup()
    end,
  },
}
