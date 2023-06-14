return {
	{
		"sbdchd/neoformat",
		config = function()
			vim.g.neoformat_only_msg_on_error = 1
			vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", command = ":Neoformat black" })
			vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.go", command = ":Neoformat goimport" })
			vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.vue", "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
				-- command = ":Neoformat prettier",
				command = ":Neoformat prettierd",
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.sol" },
				command = ":Neoformat prettier",
			})
		end,
	},
}
