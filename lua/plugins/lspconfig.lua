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
			lspconfig.gopls.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})
			lspconfig.tsserver.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})
			lspconfig.jsonls.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.clangd.setup({
				on_attach = on_attach,
				-- capabilities = capabilities,
			})

			lspconfig.gdscript.setup({
				-- capabilities = capabilities,
				cmd = { "ncat", "localhost", "6005" },
			})

			lspconfig.rust_analyzer.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- local configs = require("lspconfig.configs")

			-- configs.solidity = {
			-- 	default_config = {
			-- 		cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
			-- 		filetypes = { "solidity" },
			-- 		single_file_support = true,
			-- 	},
			-- }
			-- configs.solang = {
			-- 	default_config = {
			-- 		cmd = {
			-- 			"solang",
			-- 			"language-server",
			-- 			"--target",
			-- 			"evm",
			-- 			-- "--importmap=hardhat=node_modules/hardhat/",
			-- 			"--importmap=@openzeppelin=node_modules/@openzeppelin",
			-- 		},
			-- 		filetypes = { "solidity" },
			-- 		single_file_support = true,
			-- 	},
			-- }

			-- lspconfig.solidity.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	root_dir = function(fname)
			-- 		return vim.fn.getcwd()
			-- 	end,
			-- })

			-- lspconfig.solang.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	root_dir = function(fname)
			-- 		return vim.fn.getcwd()
			-- 	end,
			-- })

			-- root_dir = lspconfig.util.root_pattern(
			-- 	".git/",
			-- 	"hardhat.config.js",
			-- 	"hardhat.config.ts",
			-- 	"truffle-config.js",
			-- 	"truffle.js",
			-- 	"foundry.toml",
			-- 	"ape-config.yaml"
			-- ),

			-- vim.diagnostic.config({ virtual_text = false })
			-- vim.diagnostic.config({ update_in_insert = true })
			-- vim.diagnostic.disable()
		end,
	},
}
