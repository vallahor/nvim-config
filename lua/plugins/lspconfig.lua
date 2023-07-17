return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local on_attach = function(_, bufnr)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })

				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })

				vim.keymap.set("n", "<c-2>", vim.lsp.buf.rename, { buffer = bufnr })
				vim.keymap.set("n", "<c-3>", "<cmd>lua require('telescope.builtin').lsp_references()<cr>")
				vim.keymap.set("n", "<c-1>", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>")

				client.server_capabilities.semanticTokensProvider = nil
			end

			-- vim.keymap.set("n", "<c-;>", vim.diagnostic.open_float)
			-- vim.keymap.set("n", "<c-,>", vim.diagnostic.goto_prev)
			-- vim.keymap.set("n", "<c-.>", vim.diagnostic.goto_next)

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local lspconfig = require("lspconfig")
			-- lspconfig.pyright.setup({
			-- 	on_attach = on_attach,
			-- 	-- capabilities = capabilities,
			-- })

			lspconfig.pyright.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			-- lspconfig.ruff_lsp.setup({
			-- 	on_attach = on_attach,
			-- 	-- capabilities = capabilities,
			-- })

			lspconfig.gopls.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			-- lspconfig.tsserver.setup({
			-- on_attach = on_attach,
			-- capabilities = capabilities,
			-- })

			-- lspconfig.jsonls.setup({
			-- on_attach = on_attach,
			-- capabilities = capabilities,
			-- })

			lspconfig.clangd.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.rust_analyzer.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,
	},
}
