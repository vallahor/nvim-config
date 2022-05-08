local ok, nvim_lsp = pcall(require, "lspconfig")
if not ok then
	return
end
nvim_lsp.cssmodules_ls.setup({})

nvim_lsp.cssmodules_ls.setup({})

nvim_lsp.zls.setup({})

nvim_lsp.eslint.setup({})

nvim_lsp.tsserver.setup({})

nvim_lsp.prismals.setup({})

nvim_lsp.sumneko_lua.setup({})

nvim_lsp.html.setup({})
