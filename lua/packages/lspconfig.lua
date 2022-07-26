local ok, lsp = pcall(require, "lspconfig")
if not ok then
	return
end

lsp.zls.setup({})
lsp.sumneko_lua.setup({})
lsp.pylsp.setup({})
lsp.gopls.setup({})
lsp.csharp_ls.setup({})
lsp.tsserver.setup({})
lsp.clangd.setup({})
