local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		dir = "./lua/swap_buffer.lua",
		evet = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>h", "<cmd>lua Swap_left()<CR>")
			vim.keymap.set("n", "<leader>j", "<cmd>lua Swap_down()<CR>")
			vim.keymap.set("n", "<leader>k", "<cmd>lua Swap_up()<CR>")
			vim.keymap.set("n", "<leader>l", "<cmd>lua Swap_right()<CR>")
		end,
	},
	{
		dir = "./lua/theme.lua",
		init = function()
			local ok, theme = pcall(require, "theme")
			if ok then
				theme.colorscheme()
			end
		end,
	},

	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		config = function()
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
						-- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
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

			-- vim.keymap.set("n", "<c-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
			vim.keymap.set("n", "<c-f>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
			vim.keymap.set("n", "<c-/>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
			vim.keymap.set("n", "<c-space>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufRead", "BufEnter" },
		dependencies = {
			{
				"windwp/nvim-ts-autotag",
				config = function()
					local ok, autotag = pcall(require, "nvim-ts-autotag")
					if ok then
						autotag.setup({})
					end
				end,
			},
			{ "RRethy/nvim-treesitter-endwise" },
			{ "nvim-treesitter/playground", module = true },
			{ "JoosepAlviste/nvim-ts-context-commentstring" },
		},
		config = function()
			local ok, nvim_treesitter = pcall(require, "nvim-treesitter.configs")
			if ok then
				require("nvim-treesitter.install").compilers = { "clang" }
				nvim_treesitter.setup({
					ensure_installed = {
						"lua",
                        "vim",
						"c",
						"cpp",
						"zig",
						"query",
						"python",
						"json",
						"glsl",
						"vue",
						"javascript",
						"tsx",
						"typescript",
						"prisma",
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
					endwise = {
						enable = true,
					},
					context_commentstring = {
						enable = true,
						config = {
							typescript = { __default = "// %s", __multiline = "/* %s */" },
							javascript = { __default = "// %s", __multiline = "/* %s */" },
						},
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

				vim.cmd([[
                    autocmd BufRead *.scm set filetype=query
                ]])
			end
		end,
	},

	{
		"ggandor/lightspeed.nvim",
		event = "VeryLazy",
		config = function()
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
				-- vim.keymap.set("v", "s", "<Plug>Lightspeed_s")
				-- vim.keymap.set("v", "S", "<Plug>Lightspeed_S")

				vim.keymap.set("v", "n", "<Plug>Lightspeed_s")
				vim.keymap.set("v", "N", "<Plug>Lightspeed_S")
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
		end,
	},

	{
		"ms-jpq/chadtree",
		branch = "chad",
		build = ":CHADdeps",
		keys = {
			{ "<C-t>", "<cmd>CHADopen<cr>", mode = "n" },
		},
		config = function()
			local chadtree_settings = {
				view = {
					width = 30,
				},
				keymap = {
					primary = { "o" },
					open_sys = { "O" },
				},
				["theme.text_colour_set"] = "env",
				-- ["theme.icon_glyph_set"] = "ascii_hollow",
			}

			vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
		end,
	},

	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			local ok, nvim_comment = pcall(require, "Comment")
			if ok then
				vim.keymap.set({ "n", "v" }, "gc", "<nop>")
				vim.keymap.set({ "n", "v" }, "gb", "<nop>")
				nvim_comment.setup({
					toggler = {
						line = "gc",
						block = "gb",
					},
				})
			end
		end,
	},

	{
		"tpope/vim-surround",
		event = "VeryLazy",
		dependencies = {
			{ "tpope/vim-repeat" },
		},
		config = function()
			vim.keymap.set("v", "s", "<Plug>VSurround")

			vim.keymap.set("v", "(", "<Plug>VSurround)")
			vim.keymap.set("v", ")", "<Plug>VSurround)")

			vim.keymap.set("v", "[", "<nop>")
			vim.keymap.set("v", "]", "<nop>")

			vim.keymap.set("v", "[", "<Plug>VSurround]")
			vim.keymap.set("v", "]", "<Plug>VSurround]")

			vim.keymap.set("v", "{", "<Plug>VSurround}")
			vim.keymap.set("v", "}", "<Plug>VSurround}")

			vim.keymap.set("v", "'", "<Plug>VSurround'")
			vim.keymap.set("v", "`", "<Plug>VSurround`")
			vim.keymap.set("v", '"', '<Plug>VSurround"')
		end,
	},

	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("v", "<c-s>", "<Plug>(VM-Reselect-Last)")
		end,
	},

	{
		"noib3/nvim-cokeline",
		config = function()
			local ok, cokeline = pcall(require, "cokeline")
			if ok then
				local utils = require("cokeline/utils")
				local get_hex = require("cokeline/utils").get_hex
				local yellow = vim.g.terminal_color_3
				cokeline.setup({
					sidebar = {
						filetype = "CHADTree",
						components = {
							{
								text = "  CHADTree",
								fg = yellow,
								bg = get_hex("Normal", "bg"),
								style = "bold",
							},
						},
					},
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

			vim.keymap.set("n", "<c-,>", "<Plug>(cokeline-focus-prev)")
			vim.keymap.set("n", "<c-.>", "<Plug>(cokeline-focus-next)")
			-- Re-order to previous/next
			vim.keymap.set("n", "<a-,>", "<Plug>(cokeline-switch-prev)")
			vim.keymap.set("n", "<a-.>", "<Plug>(cokeline-switch-next)")
		end,
	},
	{
		"ojroques/nvim-bufdel",
		event = "VeryLazy",
		config = function()
			local ok, bufdel = pcall(require, "bufdel")
			if ok then
				bufdel.setup({
					next = "cycle",
					quit = false,
				})
			end
			vim.keymap.set("n", "<c-w>", "<cmd>BufDel<CR>")
		end,
	},

	{
		"kana/vim-arpeggio",
		config = function()
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
		end,
	},

	{
		"sbdchd/neoformat",
		event = "BufWritePre",
		config = function()
			vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.vue", "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
				-- command = ":Neoformat prettier",
				command = ":Neoformat prettierd",
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local ok, lspconfig = pcall(require, "lspconfig")
			if ok then
				lspconfig.pylsp.setup({})
				lspconfig.tsserver.setup({})
				lspconfig.jsonls.setup({})
				lspconfig.prismals.setup({})
				-- lspconfig.tailwindcss.setup({})
				lspconfig.tailwindcss.setup({
					performance = {
						trigger_debounce_time = 500,
						throttle = 550,
						fetching_timeout = 80,
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
								["output.compactBoolean"] = true,
							},
						},
					},
				})

				local util = require("lspconfig.util")
				local function get_typescript_server_path(root_dir)
					local global_ts = "C:/Users/Vallahor/AppData/Roaming/npm/node_modules/typescript/lib"
					local found_ts = ""
					local function check_dir(path)
						found_ts = util.path.join(path, "node_modules", "typescript", "lib")
						if util.path.exists(found_ts) then
							return path
						end
					end
					if util.search_ancestors(root_dir, check_dir) then
						return found_ts
					else
						return global_ts
					end
				end

				lspconfig.volar.setup({
					on_new_config = function(new_config, new_root_dir)
						new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
					end,
				})
				-- lspconfig.volar.setup({
				-- 	-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
				-- 	init_options = {
				-- 		typescript = {
				-- 			tsdk = "C:/Users/Vallahor/AppData/Roaming/npm/node_modules/typescript/lib",
				-- 		},
				-- 	},
				-- })
			end

			-- close
			vim.keymap.set("n", "<c-b>", "<c-o><cmd>bdel #<CR>")
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "<a-n>", vim.lsp.buf.rename)
			vim.keymap.set("n", "<a-a>", vim.lsp.buf.code_action)
		end,
	},

	{ "kdheepak/lazygit.nvim", keys = {
		{ "<c-g>", "<cmd>LazyGit<cr>", mode = "n" },
	} },

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline", event = "VeryLazy" },
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			local ok, cmp = pcall(require, "cmp")
			if ok then
				cmp.setup({
					sources = {
						{ name = "nvim_lsp", max_item_count = 200 },
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
						end, { "i", "s", "c" }),

						["<c-k>"] = cmp.mapping(function()
							if cmp.visible() then
								cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert, select = false })
							end
						end, { "i", "s", "c" }),
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

				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "path" },
					}, {
						{ name = "cmdline" },
					}),
				})
			end
		end,
	},

	{
		"chaoren/vim-wordmotion",
		event = "VeryLazy",
		config = function()
			vim.keymap.set({ "n", "v" }, "w", "<Plug>WordMotion_w")
			vim.keymap.set({ "n", "v" }, "b", "<Plug>WordMotion_b")
			vim.keymap.set({ "n", "v" }, "e", "<Plug>WordMotion_e")
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "VeryLazy",
		config = function()
			local ok, autopairs = pcall(require, "nvim-autopairs")
			if ok then
				autopairs.setup({
					disable_filetype = { "TelescopePrompt" },
				})
			end
		end,
	},

	{
		"echasnovski/mini.nvim",
		config = function()
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
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
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
		end,
	},
	{ "Vimjas/vim-python-pep8-indent", event = "BufEnter *.py" },
}
require("lazy").setup(plugins, opts)

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
vim.opt.shortmess = "aoOtTIcF"
vim.opt.mouse = "a"
vim.opt.mousefocus = true
-- vim.opt.fsync = true
vim.opt.magic = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.gdefault = true
-- vim.opt.colorcolumn = "80"
-- vim.opt.cmdheight = 0
-- vim.opt.guicursor = "i-ci:block-iCursor" -- comment when using nvim-qt (new version)
-- vim.opt.guicursor = "a:blinkon100" -- comment when using nvim-qt (new version)
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.completeopt = { "menu", "noinsert", "menuone", "noselect" }
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
vim.g.neoformat_only_msg_on_error = 1

-- MAPPING --

vim.g.mapleader = " "

vim.keymap.set("n", "<leader><leader>", "<cmd>nohl<cr><esc>")
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr><esc>")

vim.keymap.set("i", "<c-j>", "<esc>")
vim.keymap.set("i", "<c-k>", "<esc>")

vim.keymap.set({ "n", "v", "i" }, "<c-enter>", "<cmd>w!<CR><esc>")

vim.keymap.set("n", "H", "<c-u>zz")
vim.keymap.set("n", "L", "<c-d>zz")

vim.keymap.set({ "n", "v" }, "<c-n>", "}")
vim.keymap.set({ "n", "v" }, "<c-p>", "{")

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
vim.keymap.set("n", "^", "<C-^>:bd#<cr>")

-- tab

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
"
]])
