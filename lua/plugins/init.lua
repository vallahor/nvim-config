return {
  { "folke/lazy.nvim", version = "*" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    -- dir = "../close_other_window.lua",
    "../close_other_window.lua",
    virtual = true,
    config = function()
      local cow = require("close_other_window")
      vim.keymap.set({ "n", "v" }, "<c-left>", cow.left)
      vim.keymap.set({ "n", "v" }, "<c-down>", cow.down)
      vim.keymap.set({ "n", "v" }, "<c-up>", cow.up)
      vim.keymap.set({ "n", "v" }, "<c-right>", cow.right)
    end,
  },
  {
    "habamax/vim-godot",
    config = function()
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter", "BufWinEnter" }, {
        pattern = "*.gd",
        callback = function()
          vim.opt_local.expandtab = false
        end,
      })

      vim.cmd([[
              setlocal tabstop=4
              setlocal shiftwidth=4
          setlocal indentexpr=
            ]])
    end,
  },
  {
    "ricardoramirezr/blade-nav.nvim",
    dependencies = {
      "saghen/blink.cmp",
    },
    ft = { "blade", "php" }, -- optional, improves startup time
    opts = {
      close_tag_on_complete = true, -- default: true
    },
  },
}
