return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		inlay_hints = {
			enabled = true,

			-- this not work, that's not here @check just a reminder
			variableTypes = true,
			functionReturnTypes = true,
			callArgumentNames = true,
		},
	},
	config = function()
		local on_attach = function(client, bufnr)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>zt", { buffer = bufnr, silent = true })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
			vim.keymap.set("n", "<c-a>", vim.lsp.buf.code_action, { buffer = bufnr })

			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr })
			-- vim.keymap.set("n", "<c-3>", "<cmd>lua require('telescope.builtin').lsp_references()<cr>")
			-- vim.keymap.set("n", "<c-1>", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>")

			-- vim.diagnostic.config({
			-- 	virtual_text = {
			-- 		prefix = "",
			-- 		-- format = function(diagnostic)
			-- 		-- 	if
			-- 		-- 		diagnostic.severity == vim.diagnostic.severity.INFO
			-- 		-- 		or diagnostic.severity == vim.diagnostic.severity.HINT
			-- 		-- 	then
			-- 		-- 		return ""
			-- 		-- 	end
			-- 		-- 	return diagnostic.message
			-- 		-- end,
			-- 	},
			-- })

			client.server_capabilities.semanticTokensProvider = nil
		end

		local lspconfig = require("lspconfig")
		lspconfig.lua_ls.setup({
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								},
							},
						},
					})

					client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				end
				return true
			end,
		})

		lspconfig.pyright.setup({
			on_attach = on_attach,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "off",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						-- diagnosticMode = "openFilesOnly",
					},
				},
			},
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

		-- @check how to make it work with htmldjango
		local tailwind_filetypes = lspconfig.tailwindcss.document_config.default_config.filetypes
		table.insert(tailwind_filetypes, "htmldjango")

		lspconfig.tailwindcss.setup({
			on_attach = on_attach,
			filetypes = tailwind_filetypes,
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

		lspconfig.elixirls.setup({
			cmd = { "C:/apps/elixir-lsp/language_server.bat" },
			settings = {
				elixirLS = {
					-- I choose to disable dialyzer for personal reasons, but
					-- I would suggest you also disable it unless you are well
					-- acquainted with dialzyer and know how to use it.
					dialyzerEnabled = false,
					-- I also choose to turn off the auto dep fetching feature.
					-- It often get's into a weird state that requires deleting
					-- the .elixir_ls directory and restarting your editor.
					fetchDeps = false,
				},
			},
		})
	end,
}
