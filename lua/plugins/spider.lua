return {
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    config = function()
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { silent = true })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { silent = true })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { silent = true })
      vim.keymap.set("i", "<c-bs>", "<c-o>v<cmd>lua require('spider').motion('b')<CR>d", { silent = true })
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "UIEnter",
    config = function()
      require("various-textobjs").setup({
        useDefaultKeymaps = false,
        notifyNotFound = false,
      })
      vim.keymap.set({ "o", "x" }, "au", "aw", { silent = true })
      vim.keymap.set({ "o", "x" }, "iu", "iw", { silent = true })
      vim.keymap.set({ "o", "x" }, "aw", '<cmd>lua require("various-textobjs").subword("outer")<CR>', { silent = true })
      vim.keymap.set({ "o", "x" }, "iw", '<cmd>lua require("various-textobjs").subword("inner")<CR>', { silent = true })
    end,
  },
}
