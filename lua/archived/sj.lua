return {
	{
		"woosaaahh/sj.nvim",
		config = function()
			local sj = require("sj")
			sj.setup({
				separator = ";",
				relative_labels = true,
				-- separator = "",
				-- max_pattern_length = 0,
				keymaps = {
					cancel = "<space>",
					validate = "<cr>",
					delete_prev_word = "<C-bs>",
				},
        -- stylua: ignore
        labels = {
          "a", "s", "d", "f", "g", "h", "j", "k", "l", "w", "r", "t",
          "y", "u", "i", "o", "q", "p", "n", "m", "v", "b", "c", "x",
          "[", "]", "J", "k", "L", "N", "M", "I", "O", "P", "U", "Y",
          "F", "G", "T", "R", "D", "E", "W", "S", 'Q', "A", "V", "C",
          "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "!",
          "B", "X", "Z",
        },
			})
			vim.keymap.set({ "n", "v", "x" }, "s", sj.run)
			vim.keymap.set("n", "<c-p>", sj.prev_match)
			vim.keymap.set("n", "<c-n>", sj.next_match)
			vim.keymap.set("n", "<c-s>", sj.redo)
		end,
	},
}
