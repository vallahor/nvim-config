return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local on_attach = function(_, bufnr)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })

				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
				vim.keymap.set("n", "<c-;>", vim.lsp.buf.code_action, { buffer = bufnr })

				vim.keymap.set("n", "<c-2>", vim.lsp.buf.rename, { buffer = bufnr })
				vim.keymap.set("n", "<c-3>", "<cmd>lua require('telescope.builtin').lsp_references()<cr>")
				vim.keymap.set("n", "<c-1>", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>")

				vim.keymap.set("n", "<c-y>", vim.diagnostic.open_float)
				vim.keymap.set("n", "<c-,>", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "<c-.>", vim.diagnostic.goto_next)

				client.server_capabilities.semanticTokensProvider = nil
				-- vim.g.inlay_hints_visible = true
			end

			vim.diagnostic.config({
				signs = true,
				update_in_insert = false,
				virtual_text = {
					prefix = "",
					-- format = function(diagnostic)
					-- 	if
					-- 		diagnostic.severity == vim.diagnostic.severity.INFO
					-- 		or diagnostic.severity == vim.diagnostic.severity.HINT
					-- 	then
					-- 		return ""
					-- 	end
					-- 	return diagnostic.message
					-- end,
				},
			})

			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local lspconfig = require("lspconfig")
			lspconfig.pyright.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.gopls.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.tsserver.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})
			lspconfig.svelte.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
			})

			lspconfig.sqlls.setup({
				on_attach = on_attach,
			})

			lspconfig.jsonls.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.clangd.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.rust_analyzer.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.zls.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.gdscript.setup({
				on_attach = on_attach,
				cmd = { "nc", "localhost", "6005" },
			})
		end,
	},
}
