local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

-- SETTINGS --

local indent = 4

vim.opt.guifont = { "JetBrains Mono NL:h13" }
vim.opt.shiftwidth = indent
vim.opt.tabstop = indent
vim.opt.softtabstop = indent
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.shiftround = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.wildmode = "longest,list:longest,full"
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf8"
vim.opt.pumheight = 10
vim.opt.switchbuf = "useopen,split"
vim.opt.magic = true
vim.opt.lazyredraw = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.opt.backspace = "indent,eol,start"
vim.opt.shortmess = "aoOtTIcF"
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.gdefault = true
vim.opt.cindent = true
vim.opt.cino:append("L0,g0,l1,t0,w1,(0,w4,(s,m1")
-- vim.opt.timeoutlen = 200 -- @check why I'm using that timeoutlen (maybe jk kj escaping thing)
vim.opt.updatetime = 100
vim.opt.guicursor = "i-ci:block-iCursor"

vim.wo.signcolumn = "no"
vim.wo.relativenumber = true
-- vim.wo.number = true
vim.wo.wrap = false

vim.bo.autoread = true
vim.bo.copyindent = true
vim.bo.grepprg = "rg"
vim.bo.swapfile = false

vim.g.VM_theme = "iceblue"
vim.g.VM_default_mappings = 0
vim.g.VM_custom_remaps = { ["-"] = "$" }
vim.g.VM_maps = {
	["Find Under"] = "<a-u>",
	["Find Subword Under"] = "<a-u>",
	["Select All"] = "<a-s-u>",
	["Add Cursor Down"] = "<a-j>",
	["Add Cursor Up"] = "<a-k>",
	["Switch Mode"] = "<Tab>",
	["Align"] = "<a-a>",
	["Find Next"] = "<a-l>",
	["Find Prev"] = "<a-h>",
	["Goto Next"] = "<a-.>",
	["Goto Prev"] = "<a-,>",
	["Skip Region"] = "<a-;>",
	["Remove Region"] = "<a-m>",
	["I BS"] = "",
}

vim.g.python_indent = {
	disable_parentheses_indenting = false,
	closed_paren_align_last_line = false,
	searchpair_timeout = 150,
	continue = indent,
	open_paren = indent,
	nested_paren = indent,
}

-- MAPPING --

-- vim.keymap.set("n", "<leader><leader>", "<cmd>nohl<cr><esc>")
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr><esc>")

vim.keymap.set({ "n", "v" }, "<c-enter>", "<cmd>w!<CR><esc>")

-- vim.keymap.set({ "n", "v" }, "<leader>fs", "<cmd>w!<CR><esc>")

vim.keymap.set({ "n", "v" }, "H", "<c-u>zz")
vim.keymap.set({ "n", "v" }, "L", "<c-d>zz")

vim.keymap.set({ "n", "v" }, "<c-p>", "<c-u>zz")
vim.keymap.set({ "n", "v" }, "<c-n>", "<c-d>zz")

vim.keymap.set("n", "<c-\\>", "<cmd>clo<cr>")
vim.keymap.set("n", "<c-=>", "<cmd>vs<cr>")
vim.keymap.set("n", "<c-->", "<cmd>sp<cr>")
vim.keymap.set("n", "<c-0>", "<c-w>o")
vim.keymap.set("n", "<c-9>", "<c-w>r")
vim.keymap.set("n", "|", "<cmd>bd<cr>")

-- vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>")
-- vim.keymap.set("n", "|", "<cmd>clo<cr>")
-- vim.keymap.set("n", "+", "<cmd>vs<cr>")
-- vim.keymap.set("n", "_", "<cmd>sp<cr>")
-- vim.keymap.set("n", ")", "<c-w>o")
-- vim.keymap.set("n", "(", "<c-w>r")

-- vim.keymap.set({ "n", "v" }, "<leader>h", "<c-w>h")
-- vim.keymap.set({ "n", "v" }, "<leader>j", "<c-w>j")
-- vim.keymap.set({ "n", "v" }, "<leader>k", "<c-w>k")
-- vim.keymap.set({ "n", "v" }, "<leader>l", "<c-w>l")

-- resize windows
vim.keymap.set("n", "<a-=>", "<c-w>=")
-- vim.keymap.set("n", "<leader>=", "<c-w>=")

-- vim.keymap.set({ "n", "v" }, "<c-h>", "<c-w>h")
-- vim.keymap.set({ "n", "v" }, "<c-j>", "<c-w>j")
-- vim.keymap.set({ "n", "v" }, "<c-k>", "<c-w>k")
-- vim.keymap.set({ "n", "v" }, "<c-l>", "<c-w>l")

vim.keymap.set({ "n", "v" }, "<c-h>", "<cmd>wincmd h<cr>")
vim.keymap.set({ "n", "v" }, "<c-j>", "<cmd>wincmd j<cr>")
vim.keymap.set({ "n", "v" }, "<c-k>", "<cmd>wincmd k<cr>")
vim.keymap.set({ "n", "v" }, "<c-l>", "<cmd>wincmd l<cr>")

vim.keymap.set("c", "<c-v>", "<c-r>*")

vim.keymap.set("v", "v", "V")

vim.keymap.set({ "i", "c" }, "<c-bs>", "<c-w>")
-- vim.keymap.set({ "i", "c" }, "<c-h>", "<c-w>")

vim.keymap.set("n", "x", '"_x')
vim.keymap.set("v", "x", '"_d')
vim.keymap.set({ "n", "v" }, "c", '"_c')

vim.keymap.set("n", "dx", '"_d') -- delete without copying to register @check working ok with default timeoutlen

vim.keymap.set("n", "*", "*``")
vim.keymap.set("v", "*", '"sy/\\V<c-r>s<cr>``')

local begnning_of_the_line = function()
	local old_pos = vim.fn.col(".")
	vim.fn.setpos(".", { 0, vim.fn.line("."), 0, 0 })
	vim.fn.execute("normal ^")
	if old_pos == vim.fn.col(".") then
		vim.fn.setpos(".", { 0, vim.fn.line("."), 0, 0 })
	end
end

vim.keymap.set({ "n", "v" }, "0", begnning_of_the_line)
vim.keymap.set("n", "-", "$")
vim.keymap.set("v", "-", "$h")

-- vim.keymap.set("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<f4>", "<cmd>:e $MYVIMRC<CR>")
vim.keymap.set("n", "<f5>", "<cmd>so %<CR>")

-- move lines
vim.keymap.set("n", "<", "<<")
vim.keymap.set("n", ">", ">>")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", "<", "<gv")

-- duplicate line and lines
vim.keymap.set("n", "<c-s-j>", '"0yy"0p')
vim.keymap.set("n", "<c-s-k>", '"0yy"0P')
vim.keymap.set("v", "<c-s-j>", '"0ygvo<esc>"0pj')
vim.keymap.set("v", "<c-s-k>", '"0y"0P')

vim.keymap.set("n", "<c-6>", "<C-^>")

vim.keymap.set("n", "<f3>", ":Inspect<CR>")

vim.keymap.set("n", "<c-y>", vim.diagnostic.open_float)
vim.keymap.set("n", "<c-,>", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<c-.>", vim.diagnostic.goto_next)

vim.diagnostic.config({
	update_in_insert = false,
	virtual_text = false,
})

vim.api.nvim_create_autocmd("FocusGained", {
	pattern = "*",
	command = "silent! checktime",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.svelte", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.html", "*.css" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.wrap = true
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.keymap.set({ "n", "v", "x" }, "[", "{", { nowait = true, buffer = true, remap = true })
		vim.keymap.set({ "n", "v", "x" }, "]", "}", { nowait = true, buffer = true, remap = true })
	end,
})

vim.cmd([[
language en_US
filetype on

" @windows: nextjs and sveltkit folder name pattern
set isfname+=(

" move lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

vnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> p 'pgv"'.v:register.'y`>'

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

map <f1> <nop>

augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END

" hi! ErrorBg guibg=#351C1D
" hi! WarningBg guibg=#3A2717
" hi! InfoBg guibg=#2B2627
" hi! HintBg guibg=#2B2627

" " @check: do we really need the number fg highlight?
" hi! ErrorLineBg guifg=#a23343 guibg=#351C1D
" hi! WarningLineBg guifg=#AF7C55 guibg=#3A2717
" hi! InfoLineBg guifg=#A8899C guibg=#2B2627
" hi! HintLineBg guifg=#A98D92 guibg=#2B2627

" " :h diagnostic-signs
" sign define DiagnosticSignError text=E texthl=DiagnosticSignError linehl=ErrorBg numhl=ErrorLineBg
" sign define DiagnosticSignWarn text=W texthl=DiagnosticSignWarn linehl=WarningBg numhl=WarningLineBg
" sign define DiagnosticSignInfo text=I texthl=DiagnosticSignInfo linehl=InforBg numhl=InforLineBg
" sign define DiagnosticSignHint text=H texthl=DiagnosticSignHint linehl=HintBg numhl=HintLineBg

autocmd! BufNewFile,BufRead *.vs,*.fs,*.vert,*.frag set ft=glsl

set pumblend=15

]])
