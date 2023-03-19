return {
	{
		"sbdchd/neoformat",
		config = function()
			vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.vue", "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
				-- command = ":Neoformat prettier",
				command = ":Neoformat prettierd",
			})
		end,
	},
}
