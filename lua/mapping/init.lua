local map = vim.keymap.set

local global = vim.g

map("n", "<space>", "<nop>")
map("n", "<c-]>", "<nop>")
map("n", "<c-[>", "<nop>")

vim.g.mapleader = " "

global["wordmotion_spaces"] = { "\\w\\@<=-\\w\\@=", "\\." }

map({ "n", "v" }, "w", "<Plug>WordMotion_w")
map({ "n", "v" }, "b", "<Plug>WordMotion_b")
map({ "n", "v" }, "e", "<Plug>WordMotion_e")

map("n", "<leader>g", "<cmd>Neogit<cr>")
map("n", "gs", "<cmd>LazyGit<cr>")

map("c", "<c-v>", '<c-r>"')

map("n", "<c-f>", "<cmd>NvimTreeToggle<cr>")

map("n", "<", "<cmd>BufferLineCyclePrev<cr>")
map("n", ">", "<cmd>BufferLineCycleNext<cr>")

map("n", "<F3>", "<cmd>TSHighlightCapturesUnderCursor<cr>")

map({ "i", "c" }, "<c-bs>", "<c-w>")

map("n", "<Leader><Leader>", "<c-^>")
map("n", "x", '"_x')
map("v", "x", '"_d')
map({ "n", "v" }, "c", '"_c')
map("n", "D", '"_D')
map("v", "p", '"_c<C-r>*<Esc> ')

map("v", "s", "<Plug>VSurround")

map("n", "*", "*``")
map("v", "*", '"sy/\\V<c-r>s<cr>``')

map("v", "v", "V")

map({ "n", "v" }, "-", "$")
map({ "n", "v" }, "_", "0")
map({ "n", "v" }, "0", "^")

map("n", "H", "<c-u>")
map("n", "L", "<c-d>")

map({ "n", "v" }, "<c-enter>", "<cmd>w!<CR>")
map({ "n", "v" }, "<s-enter>", "<cmd>w!<CR>")
map({ "n", "v" }, "<leader>fs", "<cmd>w!<CR>")

map("n", "<F4>", "<cmd>e $MYVIMRC<CR>")
map("n", "<F5>", "<cmd>luafile %<CR>")

map("n", "<c-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<tab>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "<c-s>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")

map("n", "|", "<cmd>bp<cr><cmd>bd #<cr>")

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "<Leader>d", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>")

map({ "n", "v" }, "f", "<Plug>Sneak_f")
map({ "n", "v" }, "F", "<Plug>Sneak_F")
map({ "n", "v" }, "t", "<Plug>Sneak_t")
map({ "n", "v" }, "T", "<Plug>Sneak_T")

map({ "n", "v" }, "<c-h>", "<c-w>h")
map({ "n", "v" }, "<c-j>", "<c-w>j")
map({ "n", "v" }, "<c-k>", "<c-w>k")
map({ "n", "v" }, "<c-l>", "<c-w>l")

map({ "n", "v" }, "gj", "G")
map({ "n", "v" }, "gk", "gg")

map("n", ")", "<c-w>o")
map("n", "(", "<c-w>r")

map("n", "<leader>=", "<cmd>vs<cr>")
map("n", "<leader>-", "<cmd>sp<cr>")
map("n", "<c-]>", "<cmd>clo<cr>")

-- sneak
vim.cmd([[
let g:sneak#use_ic_scs = 1 

highlight Sneak guifg=none guibg=none ctermfg=none ctermbg=none
highlight SneakScope guifg=none guibg=none ctermfg=none ctermbg=none
]])

-- show current token
vim.cmd([[
nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
    \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
    \ . ">"<CR>
]])

vim.cmd([[
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
]])
