return {
	{
		"chaoren/vim-wordmotion",
		event = "VeryLazy",
		config = function()
			-- @check if works correctely
			vim.keymap.set("i", "<c-bs>", "<esc>v<Plug>WordMotion_bc")
		end,
	},
}
