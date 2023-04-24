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
	-- {
	-- 	"chama-chomo/grail",
	-- 	version = false,
	-- 	lazy = false,
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	-- Optional; default configuration will be used if setup isn't called.
	-- 	config = function()
	-- 		require("grail").setup({
	-- 			italics = false,
	-- 		})
	-- 		vim.cmd([[
	--            colorscheme grail
	--            ]])
	-- 	end,
	-- },
	{ "Vimjas/vim-python-pep8-indent", event = "BufEnter *.py" },
	{ "ziglang/zig.vim", event = "BufEnter *.zig" },
	{ "Tetralux/odin.vim", event = "BufEnter *.odin" },
}
