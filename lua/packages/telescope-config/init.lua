local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end
telescope.setup({
	defaults = {
		previewer = false,
		mappings = {
			n = {
				["d"] = require("telescope.actions").delete_buffer,
				["<c-j>"] = "move_selection_next",
				["<c-k>"] = "move_selection_previous",
			},
			i = {
				["<C-bs>"] = function()
					vim.api.nvim_input("<c-s-w>")
				end,
				["<c-j>"] = "move_selection_next",
				["<c-k>"] = "move_selection_previous",
			},
		},

		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--no-ignore",
			"--smart-case",
			"--hidden",
		},
		prompt_prefix = "     ",
		selection_caret = "  ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { "node_modules", ".git/", "dist/", "android", "ios", "zig-cache", "src/zig-cache" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "absolute" },
		color_devicons = true,
		use_less = true,
	},
})
