local config_global = vim.opt
--local config_global = vim.o
local config_buffer = vim.bo
local config_window = vim.wo

config_global.guifont = { "JetBrains Mono:h11" }

vim.cmd [[ 
let g:neovide_cursor_animation_length=0
let g:neovide_refresh_rate=120
]]

local indent = 2
config_global.shiftwidth = indent
config_global.tabstop = indent

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
config_global.wildmode = 'longest,list:longest,full'
config_global.clipboard = 'unnamedplus'
config_global.encoding = 'utf8'
config_global.updatetime = 100
config_global.pumheight = 10
config_global.switchbuf = 'useopen,split'
config_global.magic = true
config_global.lazyredraw = true
config_global.smartcase = true
config_global.inccommand = 'nosplit'
config_global.backspace = 'indent,eol,start'
config_global.timeoutlen = 2000
config_global.shortmess = 'aoOtTIc'
config_global.mouse = 'a'
config_global.mousefocus = true
config_global.fsync = true
config_global.magic = true
config_global.splitright = true
config_global.splitbelow = true
config_global.cursorline = true

config_window.signcolumn = 'no'
config_window.number = true
--config_window.relativenumber = true
config_window.wrap = true
config_buffer.autoread = true
config_buffer.copyindent = true
config_buffer.grepprg = 'rg'
config_buffer.swapfile = false
config_buffer.undofile = true

vim.cmd [[ 
language en
set nowrap
set iskeyword-=_
set cindent
set cino+=L0,g0,N-s,(0,l1
set nohlsearch 
let g:VM_theme = 'iceblue'
]]
