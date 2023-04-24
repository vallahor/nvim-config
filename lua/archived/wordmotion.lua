return {
	{
		"chaoren/vim-wordmotion",
		event = "VeryLazy",
		config = function()
			-- vim.g.wordmotion_spaces = {
			-- "w@<=-w@=",
			-- "w@<.-w@.",
			-- "w@<,-w@,",
			-- "w@<;-w@;",
			-- "w@<:-w@:",
			-- "w@<(-w@)",
			-- "w@<{-w@}",
			-- "w@<[-w@]",
			-- "w@<<-w@>",
			-- }
			vim.keymap.set({ "n", "v" }, "w", "<Plug>WordMotion_w")
			vim.keymap.set({ "n", "v" }, "b", "<Plug>WordMotion_b")
			vim.keymap.set({ "n", "v" }, "e", "<Plug>WordMotion_e")
		end,
	},
}
