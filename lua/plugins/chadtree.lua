return {
	{
		"ms-jpq/chadtree",
		branch = "chad",
		build = ":CHADdeps",
		-- keys = {
		-- 	{ "<C-t>", "<cmd>CHADopen<cr>", mode = "n" },
		-- },
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
			vim.keymap.set("n", "<c-t>", "<cmd>CHADopen<cr>")
			vim.keymap.set("n", "T", "<cmd>CHADopen<cr>")
		end,
	},
}
