local ok, lsp = pcall(require, "lspconfig")
if not ok then
	return
end

-- lsp.sumneko_lua.setup({})
lsp.tsserver.setup({})
lsp.html.setup({})
lsp.eslint.setup({})
