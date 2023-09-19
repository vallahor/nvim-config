return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-bs>"] = function()
								vim.api.nvim_input("<c-s-w>")
							end,
							["<c-k>"] = "move_selection_previous",
							["<c-j>"] = "move_selection_next",
							-- ["<esc>"] = actions.close,
							-- ["<c-space>"] = actions.close,
							["jk"] = actions.close,
							["kj"] = actions.close,
							-- ["fd"] = actions.close,
							-- ["df"] = actions.close,
							["<c-d>"] = actions.delete_buffer,
						},
						n = {
							["<esc>"] = actions.close,
							["<c-space>"] = actions.close,
							["jk"] = actions.close,
							["kj"] = actions.close,
							-- ["fd"] = actions.close,
							-- ["df"] = actions.close,
							["d"] = actions.delete_buffer,
						},
					},
					initial_mode = "insert",
					path_display = { "smart" },
					border = false,
					layout_strategy = "bottom_pane",
					layout_config = {
						height = 10,
						prompt_position = "bottom",
					},
					preview = false,
					file_ignore_patterns = { "node_modules", ".venv" },
				},
			})

			vim.keymap.set("n", "<c-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
			vim.keymap.set("n", "<c-f>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
			vim.keymap.set("n", "<c-/>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
			vim.keymap.set("n", "<c-space>", "<cmd>lua require('telescope.builtin').buffers()<cr>")

			-- vim.keymap.set("n", "<leader>f", "<cmd>lua require('telescope.builtin').find_files()<cr>")
			-- vim.keymap.set("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
			-- vim.keymap.set("n", "<leader>o", "<cmd>lua require('telescope.builtin').find_files()<cr>")
			-- vim.keymap.set("n", "<leader>/", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
			-- vim.keymap.set("n", "<leader><leader>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
		end,
	},
}
