return {
	{ "folke/lazy.nvim", version = "*" },
	{ "tpope/vim-repeat", event = "VeryLazy" },

	{
		dir = "../swap_buffer.lua",
		event = "VeryLazy",
		config = function()
			require("swap_buffer")
			vim.keymap.set("n", "<a-H>", "<cmd>lua Swap_left()<CR>")
			vim.keymap.set("n", "<a-J>", "<cmd>lua Swap_down()<CR>")
			vim.keymap.set("n", "<a-K>", "<cmd>lua Swap_up()<CR>")
			vim.keymap.set("n", "<a-L>", "<cmd>lua Swap_right()<CR>")
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
}
