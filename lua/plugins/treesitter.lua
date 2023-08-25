return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{
				"windwp/nvim-ts-autotag",
				config = function()
					require("nvim-ts-autotag").setup({})
				end,
			},
			{ "RRethy/nvim-treesitter-endwise" },
		},
		version = false,
		build = ":TSUpdate",
		event = { "BufRead", "BufEnter" },
		opts = {
			ensure_installed = {
				"bash",
				"lua",
				"vim",
				"c",
				"cpp",
				"zig",
				"rust",
				"go",
				"python",
				"json",
				"typescript",
				"yaml",
			},
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
				disable = { "python", "rust", "cpp", "go", "ocaml" },
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
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			endwise = {
				enable = true,
			},
		},
		autotag = {
			enable = true,
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
