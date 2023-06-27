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
}
