local ok, lsp = pcall(require, "lspconfig")
if not ok then
	return
end

lsp.zls.setup({})
lsp.sumneko_lua.setup({})
lsp.pylsp.setup({})
