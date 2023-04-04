return {
	{
		"ms-jpq/chadtree",
		branch = "chad",
		build = ":CHADdeps",
		keys = {
			{ "<C-t>", "<cmd>CHADopen<cr>", mode = "n" },
		},
		config = function()
			local chadtree_settings = {
				view = {
					width = 30,
				},
				keymap = {
					primary = { "o" },
					open_sys = { "O" },
				},
				["theme.text_colour_set"] = "env",
				["theme.icon_glyph_set"] = "ascii_hollow",
			}

			vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
		end,
	},
}
