return {
  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
    config = function()
      -- vim.keymap.set("i", "<c-bs>", "<c-g>u<cmd>norm! v<Plug>WordMotion_bc<cr>", { silent = true })
      vim.keymap.set("i", "<c-bs>", "<esc><cmd>norm! v<Plug>WordMotion_b<cr>c", { silent = true })
    end,
  },
}
