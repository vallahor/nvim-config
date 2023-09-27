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
			vim.g.indent_blankline_use_treesitter = true
			vim.g.indent_blankline_char = "¦"

			vim.api.nvim_create_autocmd(
				"FileType",
				{ pattern = { "python" }, command = ":lua vim.b.indent_blankline_use_treesitter=false" }
			)
		end,
	},
}
