-- MAPPING --

local map = vim.keymap.set

map("n", "<space>", "<nop>")

vim.g.mapleader = " "

map("n", "<c-w>", "<cmd>BufDel<CR>")

map("n", "<esc>", "<cmd>nohl<cr><esc>")

map("n", "<c-g>", "<cmd>LazyGit<cr>")
map("n", "<c-s>", "<cmd>NvimTreeToggle<cr>")
map("n", "<c-e>", "<cmd>NvimTreeFocus<cr>")

map("c", "<c-v>", '<c-r>"')

map("v", "v", "V")

map({ "i", "c" }, "<c-bs>", "<c-w>")

map("n", "x", '"_x')
map("v", "x", '"_d')
map({ "n", "v" }, "c", '"_c')
map("v", "p", '"_dP')

map("n", "*", "*``")
map("v", "*", '"sy/\\V<c-r>s<cr>``')

map({ "n", "v" }, "-", "$")
map({ "n", "v" }, "<leader>0", "0")
map({ "n", "v" }, "0", "^")

map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

map({ "n", "v" }, "<c-enter>", "<cmd>w!<CR>")
map({ "n", "v" }, "<s-enter>", "<cmd>w!<CR>")

map("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
map("n", "<f5>", "<cmd>so %<CR>")

map("n", "<c-f>", ":e ")
-- map("n", "<c-space>", ":b ")

-- map("n", "<c-c>", "<cmd>!kind %:p<cr>")
map("n", "<c-c>", "<cmd>!kind2 run %:p<cr>")

map({ "n", "v" }, "<c-h>", "<c-w>h")
map({ "n", "v" }, "<c-j>", "<c-w>j")
map({ "n", "v" }, "<c-k>", "<c-w>k")
map({ "n", "v" }, "<c-l>", "<c-w>l")

-- map({ "n", "v" }, "[", "{")
-- map({ "n", "v" }, "]", "}")

-- map({ "n", "v" }, "<c-n>", "}")
-- map({ "n", "v" }, "<c-p>", "{")
--
-- map({ "n", "v" }, "{", "<c-u>")
-- map({ "n", "v" }, "}", "<c-d>")

-- map("n", "H", "<c-u>zz")
-- map("n", "L", "<c-d>zz")

map("n", "<c-t>", "zt")
map("n", "<c-b>", "zb")

map("n", "<c-=>", "<cmd>vs<cr>")
map("n", "<c-->", "<cmd>sp<cr>")
map("n", "<c-]>", "<cmd>clo<cr>")
map("n", "<c-0>", "<c-w>o")
map("n", "<c-9>", "<c-w>r")

map("v", "z", "<Plug>Lightspeed_s")
map("v", "Z", "<Plug>Lightspeed_S")

map("v", "s", "<Plug>VSurround")

map("n", "<c-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<c-f>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<c-\\>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
-- map("n", "<c-space>", "<cmd>lua require('telescope.builtin').buffers()<cr>")

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>")

map({ "n", "v" }, "<a-H>", "<cmd>vertical resize +5<cr>")
map({ "n", "v" }, "<a-L>", "<cmd>vertical resize -5<cr>")

map({ "n", "v" }, "<a-J>", "<cmd>resize +5<cr>")
map({ "n", "v" }, "<a-K>", "<cmd>resize -5<cr>")

map({ "n", "v" }, "<leader>=", "<c-w>=")

-- tab
map("n", "<c-,>", "<cmd>BufferPrevious<CR>")
map("n", "<c-.>", "<cmd>BufferNext<CR>")
-- map("n", "<c-,>", "<cmd>bp<CR>")
-- map("n", "<c-.>", "<cmd>bn<CR>")
-- Re-order to previous/next
map("n", "<a-,>", "<cmd>BufferMovePrevious<CR>")
map("n", "<a-.>", "<cmd>BufferMoveNext<CR>")
-- close
map("n", "<c-w>", "<cmd>BufDel<CR>")
map("n", "<a-w>", "<cmd>BufferCloseAllButCurrent<CR>")
map("n", "<a-<>", "<cmd>BufferCloseBuffersLeft<CR>")
map("n", "<a->>", "<cmd>BufferCloseBuffersRight<CR>")
map("n", "<a-W>", "<cmd>BufferWipeout<CR>")

map("n", "<leader>h", "<cmd>lua Swap_left()<CR>")
map("n", "<leader>j", "<cmd>lua Swap_down()<CR>")
map("n", "<leader>k", "<cmd>lua Swap_up()<CR>")
map("n", "<leader>l", "<cmd>lua Swap_right()<CR>")

map("n", "ci_", '<cmd>set iskeyword-=_<cr>"_diw<cmd>set iskeyword+=_<cr>i')
map("n", "di_", '<cmd>set iskeyword-=_<cr>"_diw<cmd>set iskeyword+=_<cr>i')
map("n", "vi_", "<cmd>set iskeyword-=_<cr>viw<cmd>set iskeyword+=_<cr>")

map("n", "ca_", '<cmd>set iskeyword-=_<cr>"_daw<cmd>set iskeyword+=_<cr>i')
map("n", "da_", '<cmd>set iskeyword-=_<cr>"_daw<cmd>set iskeyword+=_<cr>i')
map("n", "va_", "<cmd>set iskeyword-=_<cr>vaw<cmd>set iskeyword+=_<cr>")

vim.cmd([[
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
let g:lightspeed_last_motion = ''
augroup lightspeed_last_motion
autocmd!
autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
augroup end
map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
map <expr> , g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"
]])
