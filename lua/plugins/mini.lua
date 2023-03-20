return {
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
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

			require("mini.pairs").setup()

			require("mini.comment").setup({
				hooks = {
					pre = function()
						require("ts_context_commentstring.internal").update_commentstring({})
					end,
				},
				mappings = {
					comment_line = "gc",
				},
			})
			require("mini.indentscope").setup({
				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},
				options = {
					border = "top",
					indent_at_cursor = false,
					try_as_border = true,
				},
				symbol = "│",
			})
			vim.cmd([[
                hi MiniIndentscopeSymbol guisp=none guifg=#493441 guibg=NONE gui=none
            ]])
		end,
	},
}
