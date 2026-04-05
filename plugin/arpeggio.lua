vim.pack.add({

  "https://github.com/kana/vim-arpeggio.git",
}, { load = true })
vim.g.arpeggio_timeoutlen = 100
vim.cmd("call arpeggio#load()")
vim.cmd("call arpeggio#map('i', '', 0, 'jk', '<Esc>')")
vim.cmd("call arpeggio#map('i', '', 0, 'kj', '<Esc>')")
