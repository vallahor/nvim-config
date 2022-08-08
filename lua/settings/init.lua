local config_global = vim.opt
local config_buffer = vim.bo
local config_window = vim.wo

-- config_global.guifont = { "JetBrains Mono:h11" }

local indent = 4
config_global.shiftwidth = indent
config_global.tabstop = indent
config_global.softtabstop = indent

config_global.expandtab = true
config_global.smartindent = true
config_global.autoindent = true
config_global.completeopt = { "menu", "noinsert", "menuone", "noselect" }
config_global.hidden = true
config_global.ignorecase = true
config_global.joinspaces = false
config_global.shiftround = true
config_global.splitright = true
config_global.splitbelow = true
config_global.termguicolors = true
config_global.wildmode = "longest,list:longest,full"
config_global.clipboard = "unnamedplus"
config_global.encoding = "utf8"
config_global.updatetime = 100
config_global.pumheight = 10
config_global.switchbuf = "useopen,split"
config_global.magic = true
config_global.lazyredraw = true
config_global.smartcase = true
config_global.inccommand = "nosplit"
config_global.backspace = "indent,eol,start"
config_global.timeoutlen = 0
-- config_global.timeoutlen = 2000
config_global.shortmess = "aoOtTIc"
config_global.mouse = "a"
config_global.mousefocus = true
config_global.fsync = true
config_global.magic = true
config_global.cursorline = true
config_global.scrolloff = 3
config_global.backup = false
-- config_global.guicursor = "i:block-iCursor"
-- config_global.showtabline = 2
config_global.gdefault = true
-- config_global.laststatus = 0
-- config_global.cmdheight = 0
-- config_global.winbar = " %f %m%=%l "

config_window.signcolumn = "no"
config_window.number = true
-- config_window.relativenumber = true
config_window.wrap = true
config_buffer.autoread = true
config_buffer.copyindent = true
config_buffer.grepprg = "rg"
config_buffer.swapfile = false

vim.cmd([[
set iskeyword-=_
set cindent
"set cino+=L0,g0,N-s,(0,l1

let g:wordmotion_spaces = [ "\\w\\@<=-\\w\\@=", "\\." ]

" au BufEnter *.scm set filetype=query
" au UiEnter * GuiFont! JetBrains Mono:h11
" au UiEnter * GuiTabline 0
" au UiEnter * GuiPopupmenu 0

autocmd FileType python setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType json setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 expandtab

" Highlight extra whitespace.
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=lightred guibg=lightred
" Show trailing whitespace and spaces before a tab:
match ExtraWhitespace /\s\+$\| \+\ze\t/
]])

-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

