return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})
			-- lspconfig.lua_ls.setup({
			-- 	capabilities = capabilities,
			-- })
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})
			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})
			-- lspconfig.zls.setup({
			-- 	capabilities = capabilities,
			-- })
			-- check how to make it work properly
			-- lspconfig.clangd.setup({
			-- 	capabilities = capabilities,
			-- })

			-- local util = require("lspconfig.util")
			-- local function get_typescript_server_path(root_dir)
			-- 	local global_ts = "C:/Users/Vallahor/AppData/Roaming/npm/node_modules/typescript/lib"
			-- 	local found_ts = ""
			-- 	local function check_dir(path)
			-- 		found_ts = util.path.join(path, "node_modules", "typescript", "lib")
			-- 		if util.path.exists(found_ts) then
			-- 			return path
			-- 		end
			-- 	end
			-- 	if util.search_ancestors(root_dir, check_dir) then
			-- 		return found_ts
			-- 	else
			-- 		return global_ts
			-- 	end
			-- end
			--
			-- lspconfig.volar.setup({
			-- 	capabilities = capabilities,
			-- 	on_new_config = function(new_config, new_root_dir)
			-- 		new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
			-- 	end,
			-- })
			--
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "<a-d>", vim.diagnostic.open_float)
			vim.keymap.set("n", "<a-,>", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "<a-.>", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<a-n>", vim.lsp.buf.rename)
			vim.keymap.set("n", "<a-a>", vim.lsp.buf.code_action)
			-- vim.keymap.set("n", "<leader>md", vim.lsp.buf.definition)
			vim.diagnostic.config({ virtual_text = false })
			-- vim.diagnostic.disable()
		end,
	},
}
