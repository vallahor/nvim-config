require('settings')
require('packages.packer-config')
require('packages.treesitter-config')
require('packages.theme-config')
require('packages.lsp-config')
require('packages.coq-config')
require('mapping')

vim.cmd [[ 
language en
set iskeyword-=_
set cindent
set cino+=L0,g0,N-s,(0,l1
set nohlsearch 
let g:VM_theme = 'iceblue'
]]

vim.cmd [[ au BufWritePre *.lua lua vim.lsp.buf.formatting_sync()]]
vim.cmd [[ au BufWritePre *.html lua vim.lsp.buf.formatting_sync()]]
vim.cmd [[ au BufWritePre *.css,*.scss lua vim.lsp.buf.formatting_sync()]]
vim.cmd [[ au BufWritePre *.tsx,*.ts,*.jsx,*.js lua vim.lsp.buf.formatting_sync()]]

vim.cmd [[colorscheme gruvball]]

vim.cmd [[
nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
    \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
    \ . ">"<CR>
]]
