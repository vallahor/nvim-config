return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufRead", "BufEnter" },
		dependencies = {
			{ "nvim-treesitter/playground", module = true },
			{
				"windwp/nvim-ts-autotag",
				config = function()
					require("nvim-ts-autotag").setup({})
				end,
			},
			{ "RRethy/nvim-treesitter-endwise" },
		},
		opts = {
			ensure_installed = {
				"bash",
				"lua",
				"vim",
				"help",
				"c",
				"cpp",
				"zig",
				"rust",
				"query",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"python",
				"json",
				"glsl",
				"vue",
				"javascript",
				"tsx",
				"typescript",
				"sql",
				"html",
				"yaml",
				"css",
				"regex",
				"markdown",
			},
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
				disable = { "python", "rust", "cpp", "go" },
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
					scope_incremental = "<nop>",
				},
			},
			endwise = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
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
		},
		config = function(_, opts)
			require("nvim-treesitter.install").compilers = { "clang" }
			require("nvim-treesitter.configs").setup(opts)

			vim.cmd([[
        autocmd BufRead *.scm set filetype=query
      ]])
		end,
	},
}
