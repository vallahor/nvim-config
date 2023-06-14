return {
	{ "folke/lazy.nvim", version = "*" },
	{ "tpope/vim-repeat", event = "VeryLazy" },

	{
		dir = "../swap_buffer.lua",
		event = "VeryLazy",
		config = function()
			require("swap_buffer")
			vim.keymap.set("n", "<a-h>", "<cmd>lua Swap_left()<CR>")
			vim.keymap.set("n", "<a-j>", "<cmd>lua Swap_down()<CR>")
			vim.keymap.set("n", "<a-k>", "<cmd>lua Swap_up()<CR>")
			vim.keymap.set("n", "<a-l>", "<cmd>lua Swap_right()<CR>")
		end,
	},
	{
		dir = "../theme.lua",
		init = function()
			local theme = require("theme")
			theme.colorscheme()
		end,
	},
	{ "ziglang/zig.vim", event = "BufEnter *.zig" },
	{ "Tetralux/odin.vim" },
	{
		-- "dense-analysis/ale",
		"hbarcelos/ale", -- hes version works with solc
		config = function()
			vim.cmd([[
	               let g:ale_linters = {
                   \   'solidity': ['solc'],
                   \   'python': ['ruff'],
	               \}
                   let g:ale_solidity_solc_options = '--include-path node_modules/ --base-path .'
	               let g:ale_lint_on_enter = 1
	               let g:ale_lint_on_save = 1
	               let g:ale_lint_on_text_changed = 1
	               let g:ale_lint_on_insert_leave = 1
	               let g:ale_linters_explicit = 1
	               let g:ale_warn_about_trailing_whitespace = 0
	               let g:ale_use_neovim_diagnostics_api = 1
	           ]])
		end,
	},
	{ "ShinKage/idris2-nvim" },
}
