return {
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    config = function()
      vim.keymap.set({ "n", "v" }, "<a-s>", "<Plug>(VM-Reselect-Last)")
    end,
  },
}
