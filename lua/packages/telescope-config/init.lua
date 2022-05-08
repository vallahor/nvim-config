local ok, nvim_telescope = pcall(require, "telescope")
if not ok then
	return
end
nvim_telescope.setup({
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
