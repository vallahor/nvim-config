local map = vim.api.nvim_set_keymap

local opts = {
  noremap = true, silent = true }
local global = vim.g
local command = vim.cmd

map('n', '<space>', '<nop>', {})

vim.g.mapleader = " "

global['wordmotion_spaces'] = { '\\w\\@<=-\\w\\@=', '\\.' }

map('n', 'w', '<Plug>WordMotion_w', { noremap = true })
map('n', 'b', '<Plug>WordMotion_b', { noremap = true })
map('n', 'e', '<Plug>WordMotion_e', { noremap = true })

map('v', 'w', '<Plug>WordMotion_w', { noremap = true })
map('v', 'b', '<Plug>WordMotion_b', { noremap = true })
map('v', 'e', '<Plug>WordMotion_e', { noremap = true })

map('n', '<leader>g', '<cmd>Neogit<cr>', opts)

map('c', '<c-v>', '<c-r>"', opts)

map('n', '<c-t>', '<cmd>CHADopen<cr>', opts)

map('n', '<c-1>', '<cmd>call emmet#toggleComment()<cr>', {})
map('v', '<c-2>', '<cmd>call emmet#expandAbbr(2,"")<cr>', {})
map('n', '<c-4>', '<cmd>call emmet#removeTag()<cr>', {})

map('n', '<F3>', '<cmd>TSHighlightCapturesUnderCursor<cr>', {})

map('i', '<c-bs>', '<c-w>', opts)
map('c', '<c-bs>', '<c-w>', opts)

map('n', 'm', '<c-w>w', opts)
map('n', '(', '<c-w>r', opts)

map('n', '<Leader><Leader>', '<c-^>', opts)
map('n', 'x', '"_x', { noremap = true })
map('v', 'x', '"_d', opts)
map('n', 'Y', 'y$', opts)

map('n', '*', '*``', opts)
map('v', '*', '"sy/\\V<c-r>s<cr>``', opts)

map('v', 'v', '<Plug>(expand_region_expand)', {})
map('v', 'V', '<Plug>(expand_region_shrink)', {})

map('n', '-', '$', { silent = true })
map('n', '0', '^', opts)

map('v', '-', '$', { silent = true })
map('v', '0', '^', opts)

map('n', '[', '{', { nowait = true, noremap = true })
map('n', ']', '}', { nowait = true, noremap = true })

map('v', '[', '{', { nowait = true, noremap = true })
map('v', ']', '}', { nowait = true, noremap = true })

map('n', '{', '<c-u>', { nowait = true })
map('n', '}', '<c-d>', { nowait = true })

map('n', '<c-enter>', '<cmd>w!<CR>', opts)
map('n', '<s-enter>', '<cmd>w!<CR>', opts)

map('n', '<F4>', '<cmd>e $MYVIMRC<CR>', opts)
map('n', '<F5>', '<cmd>luafile %<CR>', opts)
map('n', '<F6>', '<cmd>luafile $MYVIMRC<CR>', opts)

map('n', '<c-p>', '<cmd>lua require(\'telescope.builtin\').find_files()<cr>', opts)
map('n', '<tab>', '<cmd>lua require(\'telescope.builtin\').buffers()<cr>', opts)
map('n', '<c-/>', '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>', opts)

map('n', '|', '<cmd>bp<cr>:bd #<cr>', { silent = true })

map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', '<Leader>d', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
map('n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
map('n', '<Leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
map('n', '<C-j>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
map('n', '<C-k>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)

command [[ map f <Plug>Sneak_f ]]
command [[ map F <Plug>Sneak_F ]]
command [[ map t <Plug>Sneak_t ]]
command [[ map T <Plug>Sneak_T ]]
command [[ let g:sneak#use_ic_scs = 1 ]]

command [[
let g:VM_default_mappings = 0
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-;>'
let g:VM_maps['Find Subword Under'] = '<C-;>'      
let g:VM_maps["Add Cursor Down"] = '<C-=>'
let g:VM_maps["Add Cursor Up"] = '<C-->'
let g:VM_maps["Select All"] = '<c-s-;>'

let g:VM_maps["Switch Mode"] = '<Tab>'

let g:VM_maps["Find Next"] = '<c-;>'
let g:VM_maps["Find Prev"] = '<c-,>'
let g:VM_maps["Skip Region"] = '<'
let g:VM_maps["Remove Region"] = '>'
]]
