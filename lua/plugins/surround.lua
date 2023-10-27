return {
  {
    "tpope/vim-surround",
    event = "VeryLazy",
    dependencies = {
      { "tpope/vim-repeat" },
    },
    config = function()
      vim.keymap.set("v", "s", "<Plug>VSurround", { silent = true })
      vim.keymap.set("v", "S", "<Plug>VSurround", { silent = true })
    end,
  },
}
