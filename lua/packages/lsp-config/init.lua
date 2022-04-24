local on_attach = function(client, bufnr)
	if client.name == "sumneko_lua" then
		client.resolved_capabilities.document_formatting = false
	end
end

require("lspconfig").cssmodules_ls.setup({})

require("lspconfig").eslint.setup({})

require("lspconfig").tsserver.setup({})

require("lspconfig").prismals.setup({})

require("lspconfig").sumneko_lua.setup({
	on_attach = on_attach,
})

require("lspconfig").html.setup({})

local format_buffer = function(pattern)
	vim.api.nvim_create_autocmd("BufWritePre", { pattern = pattern, command = "lua vim.lsp.buf.formatting_sync()" })
end

format_buffer({ "*.lua" })
format_buffer({ "*.html" })
format_buffer({ "*.css", "*.scss" })
format_buffer({ "*.ts", "*.tsx", "*.js", "*.jsx" })
