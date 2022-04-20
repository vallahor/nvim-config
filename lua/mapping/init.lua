local map = vim.keymap.set

local opts = { noremap = true, silent = true }
local global = vim.g
local command = vim.cmd

map('n', '<space>', '<nop>', {})
map('n', '<c-]>', '<nop>', {})
map('n', '<c-[>', '<nop>', {})

vim.g.mapleader = " "

global['wordmotion_spaces'] = { '\\w\\@<=-\\w\\@=', '\\.' }

map({ 'n', 'v' }, 'w', '<Plug>WordMotion_w', { noremap = true })
map({ 'n', 'v' }, 'b', '<Plug>WordMotion_b', { noremap = true })
map({ 'n', 'v' }, 'e', '<Plug>WordMotion_e', { noremap = true })

map('n', '<c-f>', '<cmd>Neogit<cr>', opts)

map('c', '<c-v>', '<c-r>"', opts)

map('n', '<c-t>', '<cmd>CHADopen<cr>', opts)
map('n', '<c-0>', '<cmd>CHADopen<cr>', opts)

map('n', '<c-1>', '<cmd>call emmet#toggleComment()<cr>', {})
map('v', '<c-2>', '<cmd>call emmet#expandAbbr(2,"")<cr>', {})
map('n', '<c-3>', '<cmd>call emmet#removeTag()<cr>', {})

map('n', '<F3>', '<cmd>TSHighlightCapturesUnderCursor<cr>', {})

map({ 'i', 'c' }, '<c-bs>', '<c-w>', opts)

map('n', 'm', '<c-w>w', opts)
map('n', '(', '<c-w>r', opts)

map('n', '<Leader><Leader>', '<c-^>', opts)
map('n', 'x', '"_x', { noremap = true })
map('v', 'x', '"_d', opts)

map('n', '*', '*``', opts)
map('v', '*', '"sy/\\V<c-r>s<cr>``', opts)

map('v', 'v', 'V', {})

map({ 'n', 'v' }, '-', '$', { silent = true })
map({ 'n', 'v' }, '<c-9>', '0', opts)
map({ 'n', 'v' }, '0', '^', opts)

map({ 'n', 'v' }, '<c-k>', '{', { silent = true })
map({ 'n', 'v' }, '<c-j>', '}', { silent = true })

map('n', '{', '<c-u>', { nowait = true })
map('n', '}', '<c-d>', { nowait = true })

map({ 'n', 'v' }, '<c-enter>', '<cmd>w!<CR>', opts)
map({ 'n', 'v' }, '<s-enter>', '<cmd>w!<CR>', opts)

map('n', '<F4>', '<cmd>e $MYVIMRC<CR>', opts)
map('n', '<F5>', '<cmd>luafile %<CR>', opts)
map('n', '<F6>', '<cmd>luafile $MYVIMRC<CR>', opts)

map('n', '<c-p>', '<cmd>lua require(\'telescope.builtin\').find_files()<cr>', opts)
map('n', '<tab>', '<cmd>lua require(\'telescope.builtin\').buffers()<cr>', opts)
map('n', '<c-s>', '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>', opts)

map('n', '|', '<cmd>bp<cr>:bd #<cr>', { silent = true })

map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--map('n', '<Leader>d', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
map('n', '<c-h>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
map('n', '<c-4>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
map('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
map('n', '<C-s-n>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)

map({ 'n', 'v' }, 'f', '<Plug>Sneak_f', opts)
map({ 'n', 'v' }, 'F', '<Plug>Sneak_F', opts)
map({ 'n', 'v' }, 't', '<Plug>Sneak_t', opts)
map({ 'n', 'v' }, 'T', '<Plug>Sneak_T', opts)

command [[
let g:sneak#use_ic_scs = 1 

highlight Sneak guifg=none guibg=none ctermfg=none ctermbg=none
highlight SneakScope guifg=none guibg=none ctermfg=none ctermbg=none
]]

command [[
let g:VM_default_mappings = 0
let g:VM_maps = {}
let g:VM_maps['Find Under'] = "<C-\'>"
let g:VM_maps['Find Subword Under'] = "<C-\'>"      
let g:VM_maps["Add Cursor Down"] = '<C-.>'
let g:VM_maps["Add Cursor Up"] = '<C-,>'
let g:VM_maps["Select All"] = '<c-s-;>'

let g:VM_custom_remaps = {'-': '$'}

let g:VM_maps["Switch Mode"] = '<Tab>'

let g:VM_maps["Align"] = '<c-\\>'

let g:VM_maps["Find Next"] = "<c-\'>"
let g:VM_maps["Find Prev"] = '<c-;>'

let g:VM_maps["Seek Next"] = '<C-;>'
let g:VM_maps["Seek Prev"] = '<C-,>'

let g:VM_maps["Skip Region"] = '>'
let g:VM_maps["Remove Region"] = '<'
]]

-- show current token
vim.cmd [[
nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
    \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
    \ . ">"<CR>
]]
