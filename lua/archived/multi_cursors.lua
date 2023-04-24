return {
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("v", "<c-s>", "<Plug>(VM-Reselect-Last)")
		end,
	},
}
