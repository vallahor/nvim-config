return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          -- char = "|",
          -- tab_char = "|",
          -- char = "│",
          -- tab_char = "│",
          char = "╎",
          tab_char = "╎",
          smart_indent_cap = true,
        },
        scope = {
          enabled = false,
        },
        exclude = {
          filetypes = {},
          buftypes = { "terminal", "text" },
        },
      })
    end,
  },
  -- {
  --   "nvimdev/indentmini.nvim",
  --   config = function()
  --     require("indentmini").setup({
  --       only_current = false,
  --     })

  --     vim.cmd.highlight("IndentLine guifg=#353135")
  --     vim.cmd.highlight("IndentLineCurrent guifg=#353135")
  --   end,
  -- },
}
