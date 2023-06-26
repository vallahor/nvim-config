return {
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.move").setup({
				mappings = {
					left = "<",
					right = ">",
					down = "J",
					up = "K",
					line_left = ">",
					line_right = "<",
					line_down = "",
					line_up = "",
				},
			})

			require("mini.comment").setup({
				options = {
					ignore_blank_line = true,
				},
				hooks = {
					pre = function()
						require("ts_context_commentstring.internal").update_commentstring({})
					end,
				},
				mappings = {
					comment = "gc",
					comment_line = "gc",
				},
			})

			vim.cmd([[
                autocmd FileType solidity setlocal commentstring=//\ %s
            ]])

			require("mini.bufremove").setup()

			vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>")
			vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")

			require("mini.cursorword").setup({
				delay = 0,
			})
			vim.cmd([[
			             " hi MiniCursorword        guisp=none guifg=none guibg=#222022 gui=none
			             " hi MiniCursorword        guisp=none guifg=none guibg=#24141E gui=none
			             " hi MiniCursorword        guisp=none guifg=none guibg=#2D1625 gui=none

			             " hi MiniCursorword        guisp=none guifg=none guibg=#35172B gui=none
			             " hi MiniCursorwordCurrent guisp=none guifg=none guibg=#35172B gui=none

			             hi MiniCursorword        guisp=none guifg=none guibg=#1c212f gui=none
			             hi MiniCursorwordCurrent guisp=none guifg=none guibg=#1c212f gui=none
			         ]])
		end,
	},
}
