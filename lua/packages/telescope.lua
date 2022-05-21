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
		file_ignore_patterns = {
			"^node_modules/",
			"^.git/",
			"^zig-cache/",
			"^src/zig-cache/",
			"^lib/tsan",
			"^lib/libc",
			"^stage1/",
			"^stage2/",
		},
		initial_mode = "insert",
		selection_strategy = "reset",
		-- file_sorter = require("telescope.sorters").get_fuzzy_file,
		-- generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "absolute" },
		-- use_less = true,
	},
})
