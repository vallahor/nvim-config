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

vim.opt.guifont = { "JetBrainsMonoNL NFM:h13" }
-- vim.opt.guifont = { "Consolas:h15" }
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
-- vim.opt.fsync = true
vim.opt.magic = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.gdefault = true
-- vim.opt.guicursor = "i-ci:block-iCursor" -- comment when using nvim-qt (new version)
-- vim.opt.guicursor = "a:blinkon100" -- comment when using nvim-qt (new version)
-- vim.opt.completeopt = { "menu", "noinsert", "menuone", "noselect" }
vim.opt.cindent = true
vim.opt.cino:append("L0,g0,l1,t0,w1,(0,w4,(s,m1")
vim.opt.timeoutlen = 200
vim.opt.updatetime = 200

vim.wo.signcolumn = "no"
vim.wo.relativenumber = true
-- vim.wo.number = true
vim.wo.wrap = false

vim.bo.autoread = true
vim.bo.copyindent = true
vim.bo.grepprg = "rg"
vim.bo.swapfile = false

vim.g.user_emmet_install_global = 0

vim.g.VM_theme = "iceblue"
vim.g.VM_default_mappings = 0
vim.g.VM_custom_remaps = { ["-"] = "$" }
vim.g.VM_maps = {
	["Reselect Last"] = "<c-s>",
	["Find Under"] = "<c-u>",
	["Find Subword Under"] = "<c-u>",
	["Select All"] = "<c-s-u>",
	["Add Cursor Down"] = "<m-j>",
	["Add Cursor Up"] = "<m-k>",
	["Switch Mode"] = "v",
	["Align"] = "<c-a>",
	["Find Next"] = "]",
	["Find Prev"] = "[",
	["Goto Next"] = "}",
	["Goto Prev"] = "{",
	["Skip Region"] = "=",
	["Remove Region"] = "+",
	-- ["Add Cursor At Pos"] = "<enter>",
}

-- MAPPING --

vim.keymap.set("n", "<leader><leader>", "<cmd>nohl<cr><esc>")
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr><esc>")

vim.keymap.set("i", "<c-j>", "<esc>")
vim.keymap.set("i", "<c-k>", "<esc>")

vim.keymap.set({ "n", "v", "i" }, "<c-enter>", "<cmd>w!<CR><esc>")

vim.keymap.set("n", "H", "<c-u>zz")
vim.keymap.set("n", "L", "<c-d>zz")

vim.keymap.set({ "n", "v" }, "<c-n>", "}")
vim.keymap.set({ "n", "v" }, "<c-p>", "{")

vim.keymap.set({ "n", "v" }, "<c-.>", "}")
vim.keymap.set({ "n", "v" }, "<c-,>", "{")

vim.keymap.set("n", "<c-\\>", "<cmd>clo<cr>")
vim.keymap.set("n", "<c-=>", "<cmd>vs<cr>")
vim.keymap.set("n", "<c-->", "<cmd>sp<cr>")
vim.keymap.set("n", "<c-0>", "<c-w>o")
vim.keymap.set("n", "<c-9>", "<c-w>r")

vim.keymap.set({ "n", "v" }, "<c-h>", "<c-w>h")
vim.keymap.set({ "n", "v" }, "<c-j>", "<c-w>j")
vim.keymap.set({ "n", "v" }, "<c-k>", "<c-w>k")
vim.keymap.set({ "n", "v" }, "<c-l>", "<c-w>l")

vim.keymap.set("c", "<c-v>", "<c-r>*")

vim.keymap.set("v", "v", "V")

vim.keymap.set({ "i", "c" }, "<c-bs>", "<c-w>")
-- vim.keymap.set("i", "<c-bs>", "<c-o>v<Plug>WordMotion_bx")

vim.keymap.set("n", "x", '"_x')
vim.keymap.set("v", "x", '"_d')
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set("v", "p", '"_dP')

vim.keymap.set("n", "*", "*``")
vim.keymap.set("v", "*", '"sy/\\V<c-r>s<cr>``')

vim.keymap.set({ "n", "v" }, "<leader>0", "0")
vim.keymap.set({ "n", "v" }, "<c-0>", "0")
vim.keymap.set("n", "-", "$")
vim.keymap.set("v", "-", "$h")
vim.keymap.set({ "n", "v" }, "0", "^")

-- vim.keymap.set("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<f4>", "<cmd>:e $MYVIMRC<CR>")
vim.keymap.set("n", "<f5>", "<cmd>so %<CR>")

vim.keymap.set("n", "<F3>", "<cmd>TSHighlightCapturesUnderCursor<cr>")

vim.keymap.set("n", "<c-6>", "<C-^>")
vim.keymap.set("n", "<c-b>", "<C-^>:bd#<cr>")

vim.keymap.set("n", "|", "<cmd>bd<cr>")

vim.api.nvim_create_autocmd("FocusGained", {
	pattern = "*",
	command = "silent! checktime",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.vue", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.html", "*.css" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.py",
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

vim.cmd([[
language en_US
filetype on

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()
]])
