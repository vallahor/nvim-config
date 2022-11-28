local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({ "nvim-lua/plenary.nvim" })
	use({ "nvim-telescope/telescope.nvim" })

	use({ "nvim-treesitter/playground" })
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	use({ "ggandor/lightspeed.nvim" })

	use({ "kyazdani42/nvim-tree.lua", tag = "nightly" })
	use({ "numToStr/Comment.nvim" })

	use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })

	use({ "mg979/vim-visual-multi" })

	use({ "noib3/nvim-cokeline" })
	use({ "ojroques/nvim-bufdel" })

	use({ "norcalli/nvim-colorizer.lua" })

	use({ "kana/vim-arpeggio" })

	use({
		"TimUntersberger/neogit",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "sindrets/diffview.nvim" },
		},
	})

	use({ "sbdchd/neoformat" })
	use({ "rebelot/heirline.nvim" })
	use({ "lewis6991/gitsigns.nvim", tag = "release" })

	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- SETTINGS --

local indent = 4

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
vim.opt.shortmess = "aoOtTIc"
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.fsync = true
vim.opt.magic = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.gdefault = true
vim.opt.colorcolumn = "80"
-- vim.opt.cmdheight = 0
vim.opt.guicursor = "i-ci:block-iCursor" -- comment when using nvim-qt (new version)
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.opt.completeopt = { "menu", "noinsert", "menuone", "noselect" }
vim.opt.cindent = true
vim.opt.cino:append("L0,g0,l1,t0,w1,w4,(s,m1")

--
vim.o.timeoutlen = 250
-- vim.o.ttimeoutlen = 100

vim.wo.signcolumn = "no"
vim.wo.relativenumber = true
-- vim.wo.number = true
vim.wo.wrap = true

vim.bo.autoread = true
vim.bo.copyindent = true
vim.bo.grepprg = "rg"
vim.bo.swapfile = false

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
	["Add Cursor At Pos"] = "<enter>",
}

-- PLUGINS

local ok, lightspeed = pcall(require, "lightspeed")
if ok then
	-- vim.g.lightspeed_no_default_keymaps = true
	lightspeed.setup({
		exit_after_idle_msecs = { unlabeled = 300, labeled = nil },
		--- s/x ---
		jump_to_unique_chars = { safety_timeout = 300 },
		ignore_case = true,
		repeat_ft_with_target_char = true,
	})
end

local ok, nvim_tree = pcall(require, "nvim-tree")
if ok then
	nvim_tree.setup({
		renderer = {
			indent_markers = {
				enable = true,
				icons = {
					corner = "└ ",
					edge = "│ ",
					none = "  ",
				},
			},
			icons = {
				webdev_colors = false,
				show = {
					folder = true,
					file = false,
					folder_arrow = false,
				},
			},
		},
		git = {
			enable = false,
			ignore = false,
			timeout = 400,
		},
	})
end

local ok, nvim_comment = pcall(require, "Comment")
if ok then
	nvim_comment.setup({
		padding = true,
		sticky = true,
		ignore = nil,
		toggler = {
			line = "gcc",
			block = "gcb",
		},
		opleader = {
			line = "gc",
			block = "gb",
		},
		mappings = {
			basic = true,
			extra = true,
		},
	})
end

local ok, bufdel = pcall(require, "bufdel")
if ok then
	bufdel.setup({
		next = "cycle",
		quit = false,
	})
end

local ok, telescope = pcall(require, "telescope")
if ok then
	local actions = require("telescope.actions")
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-bs>"] = function()
						vim.api.nvim_input("<c-s-w>")
					end,
					["<c-k>"] = "move_selection_previous",
					["<c-j>"] = "move_selection_next",
					-- ["<esc>"] = actions.close,
					["jk"] = actions.close,
					["kj"] = actions.close,
				},
			},
			initial_mode = "insert",
			path_display = { "smart" },
			borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			border = false,
			layout_strategy = "bottom_pane",
			layout_config = {
				height = 10,
				prompt_position = "bottom",
			},
			preview = false,
		},
	})
end

local ok, nvim_treesitter = pcall(require, "nvim-treesitter.configs")
if ok then
	nvim_treesitter.setup({
		ensure_installed = {
			"lua",
			"c",
			"cpp",
			"zig",
			"query",
			"python",
			"typescript",
			"javascript",
			"tsx",
			"rust",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = false,
		},
	})

	require("nvim-treesitter.configs").setup({
		playground = {
			enable = true,
			disable = {},
			updatetime = 25,
			persist_queries = false,
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
	})
end

local ok, cokeline = pcall(require, "cokeline")
if ok then
	cokeline.setup({
		components = {
			{
				text = "   ",
			},
			{
				text = function(buffer)
					return buffer.filename .. " "
				end,
				style = function(buffer)
					return buffer.is_focused and "bold" or nil
				end,
			},
			{
				text = function(buffer)
					if buffer.is_modified then
						return "●"
					end
					return " "
				end,
			},
			{
				text = " ",
			},
		},
	})
end

local ok, neogit = pcall(require, "neogit")
if ok then
	neogit.setup({
		disable_signs = false,
		disable_hint = false,
		disable_context_highlighting = false,
		disable_commit_confirmation = false,
		auto_refresh = true,
		disable_builtin_notifications = false,
		use_magit_keybindings = true,
		kind = "replace",
		commit_popup = {
			kind = "split",
		},
		popup = {
			kind = "split",
		},
		signs = {
			section = { ">", "v" },
			item = { ">", "v" },
			hunk = { "", "" },
		},
	})
end

-- neoformat
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
	command = ":Neoformat prettier",
})

vim.g.neoformat_only_msg_on_error = 1

local ok, gitsigns = pcall(require, "gitsigns")
if ok then
	gitsigns.setup()
end

local ok, heirline = pcall(require, "heirline")
if not ok then
	return
end

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local Align = { provider = "%=" }
local Space = { provider = " " }

local FileNameBlock = {
	-- let's first set up some attributes needed by this component and it's children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}

local FileName = {
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ":.")
		if filename == "" then
			return "[No Name]"
		end
		if not conditions.width_percent_below(#filename, 0.25) then
			filename = vim.fn.pathshorten(filename)
		end
		return filename
	end,
}

local FileFlags = {
	{
		provider = function()
			if vim.bo.modified then
				return "[+]"
			end
		end,
	},
	{
		provider = function()
			if not vim.bo.modifiable or vim.bo.readonly then
				return "[RO]"
			end
		end,
	},
}

local FileType = {
	provider = function()
		local filetype = vim.bo.filetype
		if filetype ~= "" then
			return " [" .. string.upper(vim.bo.filetype) .. "]"
		else
			return ""
		end
	end,
}

local FileFormat = {
	provider = function()
		local fmt = vim.bo.fileformat
		return " [" .. fmt:upper() .. "]"
	end,
}

FileNameBlock = utils.insert(
	FileNameBlock,
	Space,
	utils.insert(FileName), -- a new table where FileName is a child of FileNameModifier
	Space,
	{ provider = "%<" }
)

local Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	{ -- git branch name
		provider = function(self)
			if self.status_dict.head == nil then
				return " [" .. self.status_dict.head .. "]"
			else
				return ""
			end
		end,
	},
}

local viMode = {
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
		if not self.once then
			vim.api.nvim_create_autocmd("ModeChanged", { command = "redrawstatus" })
			self.once = true
		end
	end,
	static = {
		mode_names = {
			n = "N",
			no = "N?",
			nov = "N?",
			noV = "N?",
			["no\22"] = "N?",
			niI = "Ni",
			niR = "Nr",
			niV = "Nv",
			nt = "Nt",
			v = "V",
			vs = "Vs",
			V = "V_",
			Vs = "Vs",
			["\22"] = "^V",
			["\22s"] = "^V",
			s = "S",
			S = "S_",
			["\19"] = "^S",
			i = "I",
			ic = "Ic",
			ix = "Ix",
			R = "R",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "C",
			cv = "Ex",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = "T",
		},
	},
	provider = function(self)
		return "[" .. self.mode_names[self.mode] .. "]"
	end,
	update = "ModeChanged",
}

local Ruler = {
	-- %l = current line number
	-- %L = number of lines in the buffer
	-- provider = "%7(%l/%3L%)",
	provider = "%7(%l/%L%)",
}

local statusline = {
	viMode,
	Git,
	FileNameBlock,
	FileFlags,
	{ provider = "%=" },
	Ruler,
	FileType,
	FileFormat,
}

heirline.setup(statusline)

if not (vim.g.arpeggio_timeoutlen ~= nil) then
	vim.cmd([[
  call arpeggio#map('i', '', 0, 'jk', '<Esc>')
  call arpeggio#map('i', '', 0, 'kj', '<Esc>')
  call arpeggio#map('v', '', 0, 'jk', '<Esc>')
  call arpeggio#map('v', '', 0, 'kj', '<Esc>')
  call arpeggio#map('s', '', 0, 'jk', '<Esc>')
  call arpeggio#map('s', '', 0, 'kj', '<Esc>')
  call arpeggio#map('x', '', 0, 'jk', '<Esc>')
  call arpeggio#map('x', '', 0, 'kj', '<Esc>')
  call arpeggio#map('c', '', 0, 'jk', '<c-c>')
  call arpeggio#map('c', '', 0, 'kj', '<c-c>')
  call arpeggio#map('o', '', 0, 'jk', '<Esc>')
  call arpeggio#map('o', '', 0, 'kj', '<Esc>')
  call arpeggio#map('l', '', 0, 'jk', '<Esc>')
  call arpeggio#map('l', '', 0, 'kj', '<Esc>')
  call arpeggio#map('t', '', 0, 'kj', '<Esc>')
  call arpeggio#map('t', '', 0, 'kj', '<Esc>')
  ]])
end

require("colorizer").setup()

-- MAPPING --

local map = vim.keymap.set

-- map("n", "<space>", "<nop>")

vim.g.mapleader = " "

map("n", "<esc>", "<cmd>nohl<cr><esc>")
map("n", "<leader><leader>", "<cmd>nohl<cr><esc>")

map("n", "<c-g>", "<cmd>Neogit<cr>")
map("n", "<leader>ft", "<cmd>NvimTreeToggle<cr>")
-- map("n", "<c-;>", "<cmd>NvimTreeFocus<cr>")

map("n", "<c-f>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<c-s>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")

map("c", "<c-v>", "<c-r>*")

map("v", "v", "V")

map({ "i", "c" }, "<c-bs>", "<c-w>")

map("n", "x", '"_x')
map("v", "x", '"_d')
map({ "n", "v" }, "c", '"_c')
map("v", "p", '"_dP')

map("n", "*", "*``")
map("v", "*", '"sy/\\V<c-r>s<cr>``')

map({ "n", "v" }, "<leader>0", "0")
map({ "n", "v" }, "-", "$")
map({ "n", "v" }, "0", "^")

map("n", "j", "v:count ? 'j^' : 'gj'", { expr = true })
map("n", "k", "v:count ? 'k^' : 'gk'", { expr = true })

map({ "n", "v" }, "<c-enter>", "<cmd>w!<CR><esc>")

-- map("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
map("n", "<f4>", "<cmd>:e $MYVIMRC<CR>")
map("n", "<f5>", "<cmd>so %<CR>")

map({ "n", "v" }, "<leader>h", "<c-w>h")
map({ "n", "v" }, "<leader>j", "<c-w>j")
map({ "n", "v" }, "<leader>k", "<c-w>k")
map({ "n", "v" }, "<leader>l", "<c-w>l")

map("n", "<c-p>", "<c-u>zz")
map("n", "<c-n>", "<c-d>zz")

map("n", "|", "<cmd>clo<cr>")
map("n", "+", "<cmd>vs<cr>")
map("n", "_", "<cmd>sp<cr>")
map("n", ")", "<c-w>o")
map("n", "(", "<c-w>r")

-- map("n", "<c-\\>", "<cmd>clo<cr>")
-- map("n", "<c-=>", "<cmd>vs<cr>")
-- map("n", "<c-->", "<cmd>sp<cr>")
-- map("n", "<c-0>", "<c-w>o")
-- map("n", "<c-9>", "<c-w>r")
--
map("v", "s", "<Plug>Lightspeed_s")
map("v", "S", "<Plug>Lightspeed_S")

map("v", "<c-s>", "<Plug>(VM-Reselect-Last)")

map("v", "z", "<Plug>VSurround")

map("n", "<F3>", "<cmd>TSHighlightCapturesUnderCursor<cr>")

map("n", "<c-6>", "<C-^>")
map("n", "^", "<C-^>")

map("n", "ci_", '<cmd>set iskeyword-=_<cr>"_ciw<cmd>set iskeyword+=_<cr>')
map("n", "di_", '<cmd>set iskeyword-=_<cr>"_diw<cmd>set iskeyword+=_<cr>')
map("n", "vi_", "<cmd>set iskeyword-=_<cr>viw<cmd>set iskeyword+=_<cr>")

map("n", "ca_", '<cmd>set iskeyword-=_<cr>"_caw<cmd>set iskeyword+=_<cr>')
map("n", "da_", '<cmd>set iskeyword-=_<cr>"_daw<cmd>set iskeyword+=_<cr>')
map("n", "va_", "<cmd>set iskeyword-=_<cr>vaw<cmd>set iskeyword+=_<cr>")

-- tab
map("n", "<c-,>", "<Plug>(cokeline-focus-prev)")
map("n", "<c-.>", "<Plug>(cokeline-focus-next)")

-- neovide not recognize the other keybindings
map("n", "<leader>,", "<Plug>(cokeline-focus-prev)")
map("n", "<leader>.", "<Plug>(cokeline-focus-next)")

-- Re-order to previous/next
map("n", "<a-,>", "<Plug>(cokeline-switch-prev)")
map("n", "<a-.>", "<Plug>(cokeline-switch-next)")
-- close
map("n", "<c-w>", "<cmd>BufDel<CR>")

map("n", "<leader>dm", ":delmarks ")

if vim.g.neovide then
	vim.opt.guifont = "JetBrains Mono NL:h12"
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_remember_window_position = true
	vim.g.neovide_cursor_antialiasing = true
end

if not vim.fn.has("gui_running") and not vim.g.neovide then
	vim.api.nvim_create_autocmd("VimEnter", {
		pattern = "*",
		command = "GuiFont! JetBrains Mono NL:h13",
	})
end

vim.api.nvim_create_autocmd("FocusGained", {
	pattern = "*",
	command = "silent! checktime",
})

vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	command = "delmarks 0-9",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.html" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

vim.cmd([[
language en_US
filetype on

" colorscheme gruvball-ish

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

autocmd BufRead *.scm set filetype=query

fun! TrimWhitespace()
let l:save = winsaveview()
keeppatterns %s/\s\+$//e
call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

noremap <silent> <expr> ' "'".toupper(nr2char(getchar()))
noremap <silent> <expr> m "m".toupper(nr2char(getchar()))
sunmap '
sunmap m
]])

local ok, theme = pcall(require, "theme")
if ok then
	theme.colorscheme()
end
