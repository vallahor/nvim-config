return {
  {
    "kana/vim-arpeggio",
    config = function()
      vim.cmd([[
                let g:arpeggio_timeoutlen = 80

                call arpeggio#map('n', '', 0, 'jk', ':<c-u>silent! noh<cr><Esc>')
                call arpeggio#map('n', '', 0, 'kj', ':<c-u>silent! noh<cr><Esc>')

                call arpeggio#map('i', '', 0, 'jk', '<Esc>')
                call arpeggio#map('v', '', 0, 'jk', '<Esc>')
                call arpeggio#map('s', '', 0, 'jk', '<Esc>')
                call arpeggio#map('x', '', 0, 'jk', '<Esc>')
                call arpeggio#map('c', '', 0, 'jk', '<c-c>')
                call arpeggio#map('l', '', 0, 'jk', '<Esc>')
                call arpeggio#map('t', '', 0, 'jk', '<C-\><C-n>')
                call arpeggio#map('o', '', 0, 'jk', '<Esc>')

                call arpeggio#map('i', '', 0, 'kj', '<Esc>')
                call arpeggio#map('v', '', 0, 'kj', '<Esc>')
                call arpeggio#map('s', '', 0, 'kj', '<Esc>')
                call arpeggio#map('x', '', 0, 'kj', '<Esc>')
                call arpeggio#map('c', '', 0, 'kj', '<c-c>')
                call arpeggio#map('l', '', 0, 'kj', '<Esc>')
                call arpeggio#map('t', '', 0, 'kj', '<C-\><C-n>')
                call arpeggio#map('o', '', 0, 'kj', '<Esc>')

                call arpeggio#map('i', '', 0, 'JK', '<Esc>')
                call arpeggio#map('c', '', 0, 'JK', '<c-c>')
                call arpeggio#map('o', '', 0, 'JK', '<Esc>')
                call arpeggio#map('l', '', 0, 'JK', '<Esc>')
                call arpeggio#map('t', '', 0, 'JK', '<C-\><C-n>')

                call arpeggio#map('i', '', 0, 'KJ', '<Esc>')
                call arpeggio#map('c', '', 0, 'KJ', '<c-c>')
                call arpeggio#map('o', '', 0, 'KJ', '<Esc>')
                call arpeggio#map('l', '', 0, 'KJ', '<Esc>')
                call arpeggio#map('t', '', 0, 'KJ', '<C-\><C-n>')

                call arpeggio#map('i', '', 0, 'jK', '<Esc>')
                call arpeggio#map('c', '', 0, 'jK', '<c-c>')
                call arpeggio#map('o', '', 0, 'jK', '<Esc>')
                call arpeggio#map('l', '', 0, 'jK', '<Esc>')
                call arpeggio#map('t', '', 0, 'jK', '<C-\><C-n>')

                call arpeggio#map('i', '', 0, 'Kj', '<Esc>')
                call arpeggio#map('c', '', 0, 'Kj', '<c-c>')
                call arpeggio#map('o', '', 0, 'Kj', '<Esc>')
                call arpeggio#map('l', '', 0, 'Kj', '<Esc>')
                call arpeggio#map('t', '', 0, 'Kj', '<C-\><C-n>')

                call arpeggio#map('i', '', 0, 'Jk', '<Esc>')
                call arpeggio#map('c', '', 0, 'Jk', '<c-c>')
                call arpeggio#map('o', '', 0, 'Jk', '<Esc>')
                call arpeggio#map('l', '', 0, 'Jk', '<Esc>')
                call arpeggio#map('t', '', 0, 'Jk', '<C-\><C-n>')

                call arpeggio#map('i', '', 0, 'kJ', '<Esc>')
                call arpeggio#map('c', '', 0, 'kJ', '<c-c>')
                call arpeggio#map('o', '', 0, 'kJ', '<Esc>')
                call arpeggio#map('l', '', 0, 'kJ', '<Esc>')
                call arpeggio#map('t', '', 0, 'kJ', '<C-\><C-n>')
                ]])
    end,
  },
}
