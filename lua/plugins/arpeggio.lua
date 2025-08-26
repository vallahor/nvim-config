return {
  {
    "kana/vim-arpeggio",
    config = function()
      vim.cmd([[
          let g:arpeggio_timeoutlen = 100

          call arpeggio#map('i', '', 0, 'jk', '<Esc>')
          call arpeggio#map('i', '', 0, 'kj', '<Esc>')
        ]])
    end,
  },
}
