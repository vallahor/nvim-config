vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", command = ":Neoformat yapf" })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
	command = ":Neoformat prettier",
})

vim.g.neoformat_only_msg_on_error = 1
