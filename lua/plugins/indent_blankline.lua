return {
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			-- vim.opt.list = true
			-- vim.opt.listchars:append("space:·")
			-- vim.opt.listchars:append("trail:·")
			-- vim.opt.listchars:append("tab:··")
			require("indent_blankline").setup({
				show_trailing_blankline_indent = false,
			})
		end,
	},
}
