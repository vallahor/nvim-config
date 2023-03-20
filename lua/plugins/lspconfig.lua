return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.pylsp.setup({})
			lspconfig.tsserver.setup({})
			lspconfig.jsonls.setup({})
			lspconfig.prismals.setup({})
			-- lspconfig.tailwindcss.setup({})
			lspconfig.tailwindcss.setup({
				performance = {
					trigger_debounce_time = 500,
					throttle = 550,
					fetching_timeout = 80,
				},
			})

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
				on_new_config = function(new_config, new_root_dir)
					new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
				end,
			})

			vim.keymap.set("n", "<c-b>", "<c-o><cmd>bdel #<CR>")
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "<a-n>", vim.lsp.buf.rename)
			vim.keymap.set("n", "<a-a>", vim.lsp.buf.code_action)
		end,
	},
}
