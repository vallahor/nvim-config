return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})
			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
			})

			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "<a-d>", vim.diagnostic.open_float)
			vim.keymap.set("n", "<a-,>", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "<a-.>", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<a-n>", vim.lsp.buf.rename)
			vim.keymap.set("n", "<a-a>", vim.lsp.buf.code_action)
			-- vim.keymap.set("n", "<leader>md", vim.lsp.buf.definition)

			-- vim.diagnostic.config({ virtual_text = false })
			-- vim.diagnostic.disable()
		end,
	},
}
