return {
	{ "folke/lazy.nvim", version = "*" },
	{ "tpope/vim-repeat", event = "VeryLazy" },

	{
		dir = "../swap_buffer.lua",
		event = "VeryLazy",
		config = function()
			require("swap_buffer")
			vim.keymap.set("n", "<leader>h", "<cmd>lua Swap_left()<CR>")
			vim.keymap.set("n", "<leader>j", "<cmd>lua Swap_down()<CR>")
			vim.keymap.set("n", "<leader>k", "<cmd>lua Swap_up()<CR>")
			vim.keymap.set("n", "<leader>l", "<cmd>lua Swap_right()<CR>")
		end,
	},
	{
		dir = "../theme.lua",
		init = function()
			local theme = require("theme")
			theme.colorscheme()
		end,
	},
	{
		"habamax/vim-godot",
		event = "BufEnter *.gd",
		config = function()
			vim.cmd([[
                let g:godot_executable = 'C:/apps/godot/Godot_v4.1.1-stable_mono_win64.exe'
                setlocal foldmethod=expr
                setlocal tabstop=4
                setlocal shiftwidth=4
                setlocal indentexpr=
            ]])
		end,
	},
	{
		"mattn/emmet-vim",
		config = function()
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = { "*.svelte", "*.vue", "*.tsx", "*.jsx", "*.html" },
				command = ":EmmetInstall",
			})
			vim.keymap.set("i", "<c-y>", "<nop>")
			vim.keymap.set("i", "<c-y>", "<Plug>(emmet-expand-abbr)", { nowait = true })

			vim.keymap.set("n", "<leader>gc", "<cmd>call emmet#toggleComment()<cr>", {})
			vim.keymap.set("v", "<leader>a", '<cmd>call emmet#expandAbbr(2,"")<cr>', {})
			vim.keymap.set("n", "<leader>d", "<cmd>call emmet#removeTag()<cr>", {})
		end,
	},
}
