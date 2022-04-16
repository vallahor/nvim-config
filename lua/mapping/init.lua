local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local global = vim.g
local command = vim.cmd

map('n', '<space>', '<nop>', {})

command 'let mapleader = "<Space>"'
--vim.g.mapleader = " "

global['wordmotion_spaces'] = { '\\w\\@<=-\\w\\@=', '\\.' }

map('n', 'w', '<Plug>WordMotion_w', { noremap = true })
map('n', 'b', '<Plug>WordMotion_b', { noremap = true })
map('n', 'e', '<Plug>WordMotion_e', { noremap = true })

map('v', 'w', '<Plug>WordMotion_w', { noremap = true })
map('v', 'b', '<Plug>WordMotion_b', { noremap = true })
map('v', 'e', '<Plug>WordMotion_e', { noremap = true })

map('c', '<c-v>', '<c-r>"', { noremap = true, silent = true })

map('n', '<c-1>', '<cmd>call emmet#toggleComment()<cr>', {})
map('v', '<c-2>', '<cmd>call emmet#expandAbbr(2,"")<cr>', {})
map('n', '<c-4>', '<cmd>call emmet#removeTag()<cr>', {})

map('i', '<c-bs>', '<c-w>', { noremap = true, silent = true })
map('c', '<c-bs>', '<c-w>', { noremap = true, silent = true })

map('n', 'm', '<c-w>w', { noremap = true, silent = true })
map('n', '(', '<c-w>r', { noremap = true, silent = true })

map('n', '<Leader><Leader>', '<c-^>', { noremap = true, silent = true })
map('n', 'x', '"_x', { noremap = true })
map('v', 'x', '"_d', { noremap = true, silent = true })
map('n', 'Y', 'y$', { noremap = true, silent = true })

map('n', '*', '*``', { noremap = true, silent = true })
map('v', '*', '"sy/\\V<c-r>s<cr>``', { noremap = true, silent = true })

map('v', 'v', '<Plug>(expand_region_expand)', {})
map('v', 'V', '<Plug>(expand_region_shrink)', {})

map('n', '-', '$', { silent = true })
map('n', '0', '^', { noremap = true, silent = true })

map('n', '[', '{', { nowait = true, noremap = true })
map('n', ']', '}', { nowait = true, noremap = true })

map('v', '[', '{', { nowait = true, noremap = true })
map('v', ']', '}', { nowait = true, noremap = true })

map('n', '{', '<c-u>', { nowait = true })
map('n', '}', '<c-d>', { nowait = true })

map('n', '<c-enter>', '<cmd>w!<CR>', { noremap = true, silent = true })
map('n', '<s-enter>', '<cmd>w!<CR>', { noremap = true, silent = true })

map('n', '<F4>', '<cmd>e $MYVIMRC<CR>', { noremap = true, silent = true })
map('n', '<F5>', '<cmd>luafile %<CR>', { noremap = true, silent = true })

map('n', '<c-p>', '<cmd>lua require(\'telescope.builtin\').find_files()<cr>', { noremap = true, silent = true })
map('n', '<tab>', '<cmd>lua require(\'telescope.builtin\').buffers()<cr>', { noremap = true, silent = true })
map('n', '<c-/>', '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>', { noremap = true, silent = true })

map('n', '|', '<cmd>bp<cr>:bd #<cr>', { silent = true })

map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
map('n', '<Leader>d', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
map('n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
map('n', '<Leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
map('n', '<C-j>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
map('n', '<C-k>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })

command [[ map f <Plug>Sneak_f ]]
command [[ map F <Plug>Sneak_F ]]
command [[ map t <Plug>Sneak_t ]]
command [[ map T <Plug>Sneak_T ]]
command [[ let g:sneak#use_ic_scs = 1 ]]
