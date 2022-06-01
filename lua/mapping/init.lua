local map = vim.keymap.set

map("n", "<space>", "<nop>")

vim.g.mapleader = " "

map("n", "<esc>", "<cmd>nohl<cr>")

map("n", "<leader>lg", "<cmd>LazyGit<cr>")

map("c", "<c-v>", '<c-r>"')

map("n", "<leader>f", "<cmd>NvimTreeToggle<cr>")

map("n", "<leader><bs>", "<cmd>TSHighlightCapturesUnderCursor<cr>")

map({ "i", "c" }, "<c-bs>", "<c-w>")

map("n", "<Leader><Leader>", "<c-^>")
map("n", "x", '"_x')
map("v", "x", '"_d')
map({ "n", "v" }, "c", '"_c')
map("v", "p", '"_c<C-r>*<Esc> ')

map("v", "s", "<Plug>VSurround")

map("n", "*", "*``")
map("v", "*", '"sy/\\V<c-r>s<cr>``')

map({ "n", "v" }, "-", "$")
map({ "n", "v" }, "<leader>0", "0")
map({ "n", "v" }, "0", "^")

map("n", "<leader>c", "<cmd>lua print(vim.fn.winline())<cr>")

map({ "n", "v" }, "<c-enter>", "<cmd>w!<CR>")
map({ "n", "v" }, "<s-enter>", "<cmd>w!<CR>")

map("n", "<leader><enter>", "<cmd>so %<CR>")

map("n", "<c-f>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<c-/>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<c-\\>", "<cmd>lua require('telescope.builtin').buffers()<cr>")

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")

map({ "n", "v" }, "<c-h>", "<c-w>h")
map({ "n", "v" }, "<c-j>", "<c-w>j")
map({ "n", "v" }, "<c-k>", "<c-w>k")
map({ "n", "v" }, "<c-l>", "<c-w>l")

map({ "n", "v" }, "<c-p>", "{")
map({ "n", "v" }, "<c-n>", "}")

map("n", "H", "<c-u>zz")
map("n", "L", "<c-d>zz")

map("n", "<c-t>", "zt")
map("n", "<c-b>", "zb")

map("n", "<c-=>", "<cmd>vs<cr>")
map("n", "<c-->", "<cmd>sp<cr>")
map("n", "<c-]>", "<cmd>clo<cr>")
map("n", "<c-0>", "<c-w>o")
map("n", "<c-9>", "<c-w>r")

-- tab
map("n", "<c-,>", "<cmd>BufferPrevious<CR>")
map("n", "<c-.>", "<cmd>BufferNext<CR>")
-- Re-order to previous/next
map("n", "<a-,>", "<cmd>BufferMovePrevious<CR>")
map("n", "<a-.>", "<cmd>BufferMoveNext<CR>")
-- close
map("n", "<c-w>", "<cmd>BufDel<CR>")
map("n", "<a-w>", "<cmd>BufferCloseAllButCurrent<CR>")
map("n", "<a-<>", "<cmd>BufferCloseBuffersLeft<CR>")
map("n", "<a->>", "<cmd>BufferCloseBuffersRight<CR>")
map("n", "<a-W>", "<cmd>BufferWipeout<CR>")

map("v", "z", "<Plug>Lightspeed_s")
map("v", "Z", "<Plug>Lightspeed_S")

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
