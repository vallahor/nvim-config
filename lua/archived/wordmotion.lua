return {
	{
		"chaoren/vim-wordmotion",
		event = "VeryLazy",
		config = function()
			vim.keymap.set({ "n", "v" }, "W", "w")
			vim.keymap.set({ "n", "v" }, "B", "b")
			vim.keymap.set({ "n", "v" }, "E", "e")

			vim.keymap.set({ "n", "v" }, "w", "<Plug>WordMotion_w")
			vim.keymap.set({ "n", "v" }, "b", "<Plug>WordMotion_b")
			vim.keymap.set({ "n", "v" }, "e", "<Plug>WordMotion_e")

			vim.keymap.set("i", "<c-bs>", "<esc>v<Plug>WordMotion_bc")
		end,
	},
}
