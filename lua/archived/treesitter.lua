return {
	{
		"nvim-treesitter/nvim-treesitter",
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
				"glsl",
				"java",
				"smali",
				"javascript",
				"typescript",
				"sql",
				-- "tsx",
				-- "vue",
				-- "html",
				-- "yaml",
				-- "css",
			},
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
				disable = { "python", "rust", "cpp", "go" },
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
