return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.g.neo_tree_remove_legacy_commands = 1

		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			api.config.mappings.default_on_attach(bufnr)

			-- your removals and mappings go here
			vim.keymap.set("n", "<C-t>", api.tree.close, opts("Close"))
		end

		require("nvim-tree").setup({
			on_attach = my_on_attach,
			update_focused_file = {
				enable = true,
				update_cwd = false,
			},
			view = {
				width = 30,
			},
			git = {
				ignore = false,
			},
			filters = {
				dotfiles = false,
				custom = { ".venv", "node_modules", "__pycache__" },
			},
			renderer = {
				icons = {
					show = {
						git = false,
					},
				},
			},
		})

		vim.keymap.set("n", "<c-t>", "<cmd>NvimTreeFocus<cr>")
		vim.keymap.set("n", "<c-b>", "<cmd>NvimTreeClose<cr>")
	end,
}
