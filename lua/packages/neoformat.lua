vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", command = ":Neoformat autopep8" })
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.nix", command = ":Neoformat" })
-- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.go", command = ":Neoformat gofmt" })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
	command = ":Neoformat prettier",
})

vim.g.neoformat_only_msg_on_error = 1
