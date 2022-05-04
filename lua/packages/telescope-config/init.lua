require("telescope").setup({
	defaults = {
		mappings = {
			n = {
				["d"] = require("telescope.actions").delete_buffer,
			},
			i = {
				["<C-bs>"] = function()
					vim.api.nvim_input("<c-s-w>")
				end,
			},
		},
		file_ignore_patterns = { "android", "ios", "zig-cache" },
	},
})
