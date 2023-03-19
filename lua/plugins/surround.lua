return {
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
}
