local ok, lsp = pcall(require, "lspconfig")
if not ok then
	return
end
lsp.cssmodules_ls.setup({})

lsp.cssmodules_ls.setup({})

lsp.zls.setup({})

lsp.eslint.setup({})

lsp.tsserver.setup({})

lsp.prismals.setup({})

lsp.sumneko_lua.setup({})

lsp.html.setup({})
