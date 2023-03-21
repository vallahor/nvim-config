return {
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.cursorword").setup()

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
			require("mini.bufremove").setup()

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
					border = "both",
					indent_at_cursor = false,
					try_as_border = true,
				},
				symbol = "│",
			})

			vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>")
			vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")

			vim.api.nvim_create_autocmd(
				"FileType",
				{ pattern = { "CHADTree", "python" }, command = ":lua vim.b.miniindentscope_disable=true" }
			)

			vim.cmd([[
                hi MiniCursorword        guisp=none guifg=none guibg=#222022 gui=none
                hi MiniCursorwordCurrent guisp=none guifg=none guibg=none gui=none
                hi MiniIndentscopeSymbol guisp=none guifg=#493441 guibg=NONE gui=none
                hi MiniIndentscopeSymbolOff guisp=none guifg=none guibg=NONE gui=none
            ]])
		end,
	},
}
