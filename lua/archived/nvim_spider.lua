return {
	{
		"chrisgrieser/nvim-spider",
		-- lazy = true,
		config = function()
			vim.keymap.set(
				{ "n", "v", "o", "x" },
				"w",
				"<cmd>lua require('spider').motion('w')<CR>",
				{ desc = "Spider-w", remap = true }
			)
			vim.keymap.set(
				{ "n", "v", "o", "x" },
				"e",
				"<cmd>lua require('spider').motion('e')<CR>",
				{ desc = "Spider-e", remap = true }
			)
			vim.keymap.set(
				{ "n", "v", "o", "x" },
				"b",
				"<cmd>lua require('spider').motion('b')<CR>",
				{ desc = "Spider-b", remap = true }
			)
			vim.keymap.set(
				{ "n", "o", "x" },
				"ge",
				"<cmd>lua require('spider').motion('ge')<CR>",
				{ desc = "Spider-ge", remap = true }
			)
			require("spider").setup({
				skipInsignificantPunctuation = false,
			})
		end,
	},
}
