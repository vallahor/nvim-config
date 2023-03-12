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
	use({ "ms-jpq/chadtree", tag = "chad", run = ":CHADdeps" })
	use({ "numToStr/Comment.nvim" })

	use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })

	use({ "mg979/vim-visual-multi" })

	use({ "noib3/nvim-cokeline" })
	use({ "ojroques/nvim-bufdel" })

	use({ "kana/vim-arpeggio" })

	use({ "sbdchd/neoformat" })

	use({ "rebelot/heirline.nvim" })
	use({ "lewis6991/gitsigns.nvim" })

	use({ "neovim/nvim-lspconfig" })

	use({ "kdheepak/lazygit.nvim" })

	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/nvim-cmp" })

	use({ "chaoren/vim-wordmotion" })

	use({ "windwp/nvim-ts-autotag" })
	use({ "RRethy/nvim-treesitter-endwise" })

	use({ "windwp/nvim-autopairs" })

	use({ "glepnir/lspsaga.nvim" })

	use({ "echasnovski/mini.nvim" })

	use({ "lukas-reineke/indent-blankline.nvim" })

	use({ "Vimjas/vim-python-pep8-indent" })

	use({ "s1n7ax/nvim-terminal" })

	use({ "aca/emmet-ls" })

	use({
		"L3MON4D3/LuaSnip",
		tag = "v<CurrentMajor>.*",
		run = "make install_jsregexp",
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- SETTINGS --

local indent = 4

vim.opt.guifont = { "JetBrainsMonoNL NFM:h13" }
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
-- vim.opt.fsync = true
vim.opt.magic = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.gdefault = true
-- vim.opt.colorcolumn = "80"
vim.opt.cmdheight = 0
-- vim.opt.guicursor = "i-ci:block-iCursor" -- comment when using nvim-qt (new version)
-- vim.opt.guicursor = "a:blinkon100" -- comment when using nvim-qt (new version)
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.completeopt = { "menu", "noinsert", "menuone", "noselect" }
vim.opt.cindent = true
vim.opt.cino:append("L0,g0,l1,t0,w1,(0,w4,(s,m1")

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

vim.g.wordmotion_spaces = { "w@<=-w@=", ".", ",", ";", ":", "w@<(-w@)", "w@<{-w@}", "w@<[-w@]", "w@<<-w@>" }

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
	vim.cmd([[
        let g:lightspeed_last_motion = ''
        augroup lightspeed_last_motion
        autocmd!
        autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
        autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
        augroup end
        map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
        map <expr> , g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"
    ]])
end

local ok, nvim_tree = pcall(require, "nvim-tree")
if ok then
	nvim_tree.setup({
		renderer = {
			icons = {
				webdev_colors = false,
				show = {
					folder = true,
					file = true,
					folder_arrow = true,
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

local ok, terminal = pcall(require, "nvim-terminal")
if ok then
	terminal.setup({
		window = {
			-- Do `:h :botright` for more information
			-- NOTE: width or height may not be applied in some "pos"
			position = "botright",

			-- Do `:h split` for more information
			split = "sp",

			-- Width of the terminal
			width = 50,

			-- Height of the terminal
			height = 15,
		},

		-- keymap to disable all the default keymaps
		disable_default_keymaps = false,

		-- keymap to toggle open and close terminal window
		toggle_keymap = "<c-;>",

		-- increase the window height by when you hit the keymap
		window_height_change_amount = 2,

		-- increase the window width by when you hit the keymap
		window_width_change_amount = 2,

		-- keymap to increase the window width
		increase_width_keymap = "<m-=>",

		-- keymap to decrease the window width
		decrease_width_keymap = "<m-->",

		-- keymap to increase the window height
		increase_height_keymap = "<m-+>",

		-- keymap to decrease the window height
		decrease_height_keymap = "<m-_>",

		terminals = {
			-- keymaps to open nth terminal
			{ keymap = "<c-1>" },
			{ keymap = "<c-2>" },
			{ keymap = "<c-3>" },
			{ keymap = "<c-4>" },
			{ keymap = "<c-5>" },
		},
	})
end

local ok, nvim_comment = pcall(require, "Comment")
if ok then
	nvim_comment.setup()
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
			"json",
			"glsl",
			"vue",
			"javascript",
			"typescript",
			"html",
			"css",
			"markdown",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
			disable = { "python", "rust", "cpp", "html" },
		},
		autotag = {
			enable = true,
			filetype = {
				"htmldjango",
			},
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "m",
				node_incremental = "m",
				node_decremental = "M",
				scope_incremental = "<c-/>",
			},
		},
	})

	require("nvim-treesitter.configs").setup({
		endwise = {
			enable = true,
		},
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

	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

	vim.cmd([[
        autocmd BufRead *.scm set filetype=query
    ]])
end

local ok, cokeline = pcall(require, "cokeline")
if ok then
	local utils = require("cokeline/utils")
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
					return buffer.is_focused and nil
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

-- neoformat
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.vue", "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
	command = ":Neoformat prettier",
})
vim.g.neoformat_only_msg_on_error = 1

local ok, autotag = pcall(require, "nvim-ts-autotag")
if ok then
	autotag.setup({})
end

local ok, gitsigns = pcall(require, "gitsigns")
if ok then
	gitsigns.setup()
end

local ok, mini_cursorword = pcall(require, "mini.cursorword")
if ok then
	mini_cursorword.setup()
	vim.cmd([[
        hi MiniCursorword        guisp=none guifg=none guibg=#222022 gui=none
        hi MiniCursorwordCurrent guisp=none guifg=none guibg=none gui=none
    ]])
end

local ok, mini_move = pcall(require, "mini.move")
if ok then
	mini_move.setup({
		mappings = {
			left = "<",
			right = ">",
			down = "J",
			up = "K",

			line_left = "<",
			line_right = ">",
			line_down = "",
			line_up = "",
		},
	})
end

local ok, autopairs = pcall(require, "nvim-autopairs")
if ok then
	autopairs.setup({
		disable_filetype = { "TelescopePrompt" },
	})
end

local ok, indent_blankline = pcall(require, "indent_blankline")
if ok then
	-- vim.opt.list = true
	-- vim.opt.listchars:append("space:·")
	-- vim.opt.listchars:append("trail:·")
	-- vim.opt.listchars:append("tab:··")
	indent_blankline.setup({
		show_trailing_blankline_indent = false,
	})
end

require("heirline_config")

if not (vim.g.arpeggio_timeoutlen ~= nil) then
	vim.cmd([[
        let g:arpeggio_timeoutlen = 80
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
        call arpeggio#map('t', '', 0, 'jk', '<C-\><C-n>')
        call arpeggio#map('t', '', 0, 'kj', '<C-\><C-n>')

        call arpeggio#map('i', '', 0, 'fd', '<Esc>')
        call arpeggio#map('i', '', 0, 'df', '<Esc>')
        call arpeggio#map('v', '', 0, 'fd', '<Esc>')
        call arpeggio#map('v', '', 0, 'df', '<Esc>')
        call arpeggio#map('s', '', 0, 'fd', '<Esc>')
        call arpeggio#map('s', '', 0, 'df', '<Esc>')
        call arpeggio#map('x', '', 0, 'fd', '<Esc>')
        call arpeggio#map('x', '', 0, 'df', '<Esc>')
        call arpeggio#map('c', '', 0, 'fd', '<c-c>')
        call arpeggio#map('c', '', 0, 'df', '<c-c>')
        call arpeggio#map('o', '', 0, 'fd', '<Esc>')
        call arpeggio#map('o', '', 0, 'df', '<Esc>')
        call arpeggio#map('l', '', 0, 'fd', '<Esc>')
        call arpeggio#map('l', '', 0, 'df', '<Esc>')
        call arpeggio#map('t', '', 0, 'fd', '<C-\><C-n>')
        call arpeggio#map('t', '', 0, 'df', '<C-\><C-n>')

        call arpeggio#map('i', '', 0, 'JK', '<Esc>')
        call arpeggio#map('i', '', 0, 'KJ', '<Esc>')
        call arpeggio#map('c', '', 0, 'JK', '<c-c>')
        call arpeggio#map('c', '', 0, 'KJ', '<c-c>')
        call arpeggio#map('o', '', 0, 'JK', '<Esc>')
        call arpeggio#map('o', '', 0, 'KJ', '<Esc>')
        call arpeggio#map('l', '', 0, 'JK', '<Esc>')
        call arpeggio#map('l', '', 0, 'KJ', '<Esc>')
        call arpeggio#map('t', '', 0, 'JK', '<C-\><C-n>')
        call arpeggio#map('t', '', 0, 'KJ', '<C-\><C-n>')
    ]])
end

local ok, lspconfig = pcall(require, "lspconfig")
if ok then
	lspconfig.eslint.setup({})
	-- lspconfig.tsserver.setup({})
	lspconfig.pylsp.setup({})
	require("lspconfig").volar.setup({
		init_options = {
			typescript = {
				tsdk = "C:/Users/Vallahor/AppData/Roaming/npm",
			},
		},
	})
	local configs = require("lspconfig/configs")
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	lspconfig.emmet_ls.setup({
		capabilities = capabilities,
		filetypes = { "vue", "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
		init_options = {
			html = {
				options = {
					-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
					["bem.enabled"] = true,
				},
			},
		},
	})
end

local ok, cmp = pcall(require, "cmp")
if ok then
	cmp.setup({
		sources = {
			{ name = "nvim_lsp" },
			{ name = "path" },
			{ name = "buffer" },
		},
		snippet = {
			expand = function(args)
				local ok, luasnip = pcall(require, "luasnip")
				if ok then
					luasnip.lsp_expand(args.body) -- For `luasnip` users.
				end
			end,
		},
		mapping = {
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-q>"] = cmp.mapping.close(),
			["<c-j>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert, select = false })
				end
			end, { "i", "s" }),

			["<c-k>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert, select = false })
				end
			end, { "i", "s" }),
			["<tab>"] = cmp.mapping.confirm({
				select = true,
				behavior = cmp.ConfirmBehavior.Replace,
			}),
			["<CR>"] = cmp.mapping.confirm({
				select = false,
			}),
			["<c-e>"] = cmp.mapping.abort(),
		},
	})
end

-- MAPPING --

vim.g.mapleader = " "

vim.keymap.set("n", "<leader><leader>", "<cmd>nohl<cr><esc>")
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr><esc>")

vim.keymap.set({ "i", "c" }, "<c-j>", "<esc>")
vim.keymap.set({ "i", "c" }, "<c-k>", "<esc>")

vim.keymap.set("n", "<c-g>", "<cmd>LazyGit<cr>")
-- vim.keymap.set("n", "<C-f>", "<cmd>CHADopen<cr>")
vim.keymap.set("n", "<C-f>", "<cmd>NvimTreeToggle<cr>")
-- vim.keymap.set("n", "<c-;>", "<cmd>NvimTreeFocus<cr>")

vim.keymap.set("n", "<c-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
vim.keymap.set("n", "<c-/>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
vim.keymap.set("n", "<c-space>", "<cmd>lua require('telescope.builtin').buffers()<cr>")

vim.keymap.set({ "n", "v" }, "<c-enter>", "<cmd>w!<CR><esc>")

vim.keymap.set("n", "H", "<c-u>zz")
vim.keymap.set("n", "L", "<c-d>zz")

-- vim.keymap.set({ "n", "v" }, "<c-j>", "}")
-- vim.keymap.set({ "n", "v" }, "<c-k>", "{")

vim.keymap.set("v", "<c-s>", "<Plug>(VM-Reselect-Last)")

vim.keymap.set("n", "<c-\\>", "<cmd>clo<cr>")
vim.keymap.set("n", "<c-=>", "<cmd>vs<cr>")
vim.keymap.set("n", "<c-->", "<cmd>sp<cr>")
vim.keymap.set("n", "<c-0>", "<c-w>o")
vim.keymap.set("n", "<c-9>", "<c-w>r")
vim.keymap.set("n", "<c-w>", "<cmd>BufDel<CR>")

vim.keymap.set("i", "<c-s-enter>", "<c-o>O")
vim.keymap.set("i", "<c-enter>", "<c-o>o")
vim.keymap.set("i", "<c-;>", "<cmd>call setline('.', getline('.') . nr2char(getchar()))<cr>")

vim.keymap.set({ "n", "v" }, "<c-h>", "<c-w>h")
vim.keymap.set({ "n", "v" }, "<c-j>", "<c-w>j")
vim.keymap.set({ "n", "v" }, "<c-k>", "<c-w>k")
vim.keymap.set({ "n", "v" }, "<c-l>", "<c-w>l")

vim.keymap.set("c", "<c-v>", "<c-r>*")

vim.keymap.set("v", "v", "V")

-- vim.keymap.set({ "i", "c" }, "<c-bs>", "<c-w>")

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

-- vim.keymap.set("n", "j", "v:count ? 'j^' : 'gj'", { expr = true })
-- vim.keymap.set("n", "k", "v:count ? 'k^' : 'gk'", { expr = true })

-- vim.keymap.set("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<f4>", "<cmd>:e $MYVIMRC<CR>")
vim.keymap.set("n", "<f5>", "<cmd>so %<CR>")

vim.keymap.set("v", "s", "<Plug>Lightspeed_s")
vim.keymap.set("v", "S", "<Plug>Lightspeed_S")

vim.keymap.set("v", "z", "<Plug>VSurround")

vim.keymap.set("n", "<F3>", "<cmd>TSHighlightCapturesUnderCursor<cr>")

vim.keymap.set("n", "<c-6>", "<C-^>")

-- tab

vim.keymap.set("n", "<c-,>", "<Plug>(cokeline-focus-prev)")
vim.keymap.set("n", "<c-.>", "<Plug>(cokeline-focus-next)")
-- Re-order to previous/next
vim.keymap.set("n", "<a-,>", "<Plug>(cokeline-switch-prev)")
vim.keymap.set("n", "<a-.>", "<Plug>(cokeline-switch-next)")
-- close
vim.keymap.set("n", "<a-w>", "<c-o><cmd>bdel #<CR>")

-- MAPPING LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<f2>", vim.lsp.buf.rename)
-- -- vim.keymap.set("n", "<c-;>", vim.lsp.buf.code_action)
--
vim.keymap.set({ "n", "v" }, "w", "<Plug>WordMotion_w")
vim.keymap.set({ "n", "v" }, "b", "<Plug>WordMotion_b")
vim.keymap.set({ "n", "v" }, "e", "<Plug>WordMotion_e")

-- vim.keymap.set("c", "<c-bs>", "<c-w>")
vim.keymap.set("i", "<c-bs>", "<c-o>v<Plug>WordMotion_bx")

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

" vnoremap J :m '>+1<CR>gv=gv
" vnoremap K :m '<-2<CR>gv=gv

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

]])
local ok, theme = pcall(require, "theme")
if ok then
	theme.colorscheme()
end
