return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
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
			lspconfig.ruff_lsp.setup({
				capabilities = capabilities,
			})
			-- check how to make it work properly
			-- lspconfig.clangd.setup({
			-- 	capabilities = capabilities,
			-- })

			local util = require("lspconfig.util")
			local function get_typescript_server_path(root_dir)
				local global_ts = "C:/Users/Vallahor/AppData/Roaming/npm/node_modules/typescript/lib"
				local found_ts = ""
				local function check_dir(path)
					found_ts = util.path.join(path, "node_modules", "typescript", "lib")
					if util.path.exists(found_ts) then
						return path
					end
				end
				if util.search_ancestors(root_dir, check_dir) then
					return found_ts
				else
					return global_ts
				end
			end

			lspconfig.volar.setup({
				capabilities = capabilities,
				on_new_config = function(new_config, new_root_dir)
					new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
				end,
			})

			-- vim.keymap.set("n", "<c-b>", "<c-o><cmd>bdel #<CR>")
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "<a-d>", vim.diagnostic.open_float)
			vim.keymap.set("n", "{", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "}", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<a-n>", vim.lsp.buf.rename)
			vim.keymap.set("n", "<a-a>", vim.lsp.buf.code_action)
			-- vim.keymap.set("n", "<leader>md", vim.lsp.buf.definition)
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.black,
					nls.builtins.formatting.prettierd,
					nls.builtins.formatting.goimports,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			}
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"lua_ls",
				"jsonls",
				"volar",
				"tsserver",
				"gopls",
				"pyright",
				"ruff_lsp",
			},
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"stylua",
				"black",
				"prettierd",
				"goimports",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
}
