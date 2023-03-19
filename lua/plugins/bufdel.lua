return {
	{
		"ojroques/nvim-bufdel",
		event = "VeryLazy",
		config = function()
			local bufdel = require("bufdel")
			bufdel.setup({
				next = "cycle",
				quit = false,
			})
			vim.keymap.set("n", "<c-w>", "<cmd>BufDel<CR>")
		end,
	},
}
