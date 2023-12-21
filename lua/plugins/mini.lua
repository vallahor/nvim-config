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

      -- Statusline
      local MiniStatusline = require("mini.statusline")
      local location = " L%l/%L C%c "
      MiniStatusline.setup({
        use_icons = false,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local venn_enabled = vim.inspect(vim.b.venn_enabled)
            local venn_mode = ""
            if venn_enabled ~= "nil" then
              venn_mode = "Venn Active"
            end

            local filename = MiniStatusline.section_filename({ trunc_width = 140 })

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { strings = { "%S" } },
              { strings = { venn_mode } },
              { strings = { vim.bo.filetype } },
              { hl = mode_hl, strings = { location } },
            })
          end,
          inactive = function()
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })

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

      vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>", { silent = true })
      vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>", { silent = true })

      -- Cursor Word
      require("mini.cursorword").setup({
        delay = 0,
      })

      vim.api.nvim_create_autocmd(
        "FileType",
        { pattern = { "NvimTree" }, command = ":lua vim.b.minicursorword_disable=true" }
      )

      vim.cmd([[
                hi MiniCursorword        guisp=none guifg=none guibg=#1c212f gui=none
                hi MiniCursorwordCurrent guisp=none guifg=none guibg=#1c212f gui=none
			 ]])
    end,
  },
}
