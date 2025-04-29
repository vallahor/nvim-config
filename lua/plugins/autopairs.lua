return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        disable_filetype = { "TelescopePrompt", "vim" },
        enable_check_bracket_line = true,
        enable_afterquote = false,
      })
      -- autopairs.add_rules(require("nvim-autopairs.rules.endwise-elixir"))
      -- autopairs.remove_rule("'")
      -- or
      autopairs.get_rules("'")[1].not_filetypes = { "scheme", "lisp", "rust" }
    end,
  },
  -- {
  --   "m4xshen/autoclose.nvim",
  --   event = "InsertEnter",
  --   config = function()
  --     require("autoclose").setup({
  --       options = {
  --         disabled_filetypes = { "text", "terminal" },
  --         disable_when_touch = true,
  --         disable_command_mode = true,
  --       },
  --       keys = {
  --         ["'"] = { escape = false, close = false, pair = "''", disabled_filetypes = { "rust" } },
  --       },
  --     })
  --   end,
  -- },
}
