return {
	{
		"chaoren/vim-wordmotion",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("i", "<c-bs>", "<c-g>u<esc>v<Plug>WordMotion_bc", { silent = true })
		end,
	},
}
