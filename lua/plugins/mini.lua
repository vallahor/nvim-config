return {
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.cursorword").setup()
			vim.cmd([[
                hi MiniCursorword        guisp=none guifg=none guibg=#222022 gui=none
                hi MiniCursorwordCurrent guisp=none guifg=none guibg=none gui=none
            ]])

			require("mini.move").setup({
				mappings = {
					left = "<",
					right = ">",
					down = "J",
					up = "K",

					line_left = "<",
					line_right = ">",
					line_down = "",
					line_up = "",
				},
			})
		end,
	},
}
