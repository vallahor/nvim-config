return {
	{
		"woosaaahh/sj.nvim",
		config = function()
			local sj = require("sj")
			sj.setup({
				separator = ";",
				-- separator = "",
				-- max_pattern_length = 0,
				keymaps = {
					cancel = "<c-space>",
					validate = "<space>",
				},
        -- stylua: ignore
        labels = {
          "a", "s", "d", "f", "g", "h", "j", "k", "l", "w", "r", "t",
          "y", "u", "i", "o",
          -- "s", "t", "u", "v", "w", "x", "y", "z",
        },
			})
			vim.keymap.set({ "n", "v", "x" }, "f", sj.run)
			-- vim.keymap.set("n", "s", sj.run)
			-- vim.keymap.set({ "v", "x" }, "z", sj.run)
			vim.keymap.set("n", "<c-p>", sj.prev_match)
			vim.keymap.set("n", "<c-n>", sj.next_match)
			vim.keymap.set("n", "<c-s>", sj.redo)
		end,
	},
}
