return {
  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
    config = function()
      -- vim.keymap.set("i", "<c-bs>", "<c-g>u<cmd>norm! v<Plug>WordMotion_bc<cr>", { silent = true })
    end,
  },
}
