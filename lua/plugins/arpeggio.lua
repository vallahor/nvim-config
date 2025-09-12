return {
  {
    "kana/vim-arpeggio",
    config = function()
      vim.cmd([[
        let g:arpeggio_timeoutlen = 100

        call arpeggio#map('i', '', 0, 'jk', '<esc>')
        call arpeggio#map('i', '', 0, 'kj', '<esc>')
      ]])
    end,
  },
}
