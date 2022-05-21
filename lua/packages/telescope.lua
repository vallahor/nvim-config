local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end

local ignored_list = {
	".git",
	"%.o",
	"%.obj",
	"%.exe",
	"%.pdb",
	"zig-cache/",
}

telescope.setup({
	defaults = {
		mappings = {
			n = {
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
		initial_mode = "insert",
		selection_strategy = "reset",
		path_display = { "absolute" },
		borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		file_ignore_patterns = ignored_list,
	},
})
