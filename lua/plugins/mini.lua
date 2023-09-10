return {
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- -- Move
			-- require("mini.move").setup({
			-- 	mappings = {
			-- 		left = "<",
			-- 		right = ">",
			-- 		down = "J",
			-- 		up = "K",
			-- 		line_left = ">",
			-- 		line_right = "<",
			-- 		line_down = "",
			-- 		line_up = "",
			-- 	},
			-- })

			-- Comment
			require("mini.comment").setup({
				options = {
					ignore_blank_line = true,
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring()
							or vim.bo.commentstring
					end,
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

			-- vim.cmd([[
			--              autocmd FileType solidity setlocal commentstring=//\ %s
			--              autocmd FileType c setlocal commentstring=//\ %s
			--              autocmd FileType cpp setlocal commentstring=//\ %s
			--          ]])

			-- Statusline
			require("mini.statusline").setup({
				use_icons = false,
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local location = MiniStatusline.section_location({ trunc_width = 75 })

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{ hl = mode_hl, strings = { location } },
						})
					end,
					inactive = function()
						local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local location = MiniStatusline.section_location({ trunc_width = 75 })

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{ hl = mode_hl, strings = { location } },
						})
					end,
				},
			})

			vim.cmd([[
                hi MiniStatuslineModeVisual guisp=none guifg=none guibg=#471A37 gui=none
            ]])

			-- -- Indent Scope
			-- require("mini.indentscope").setup({
			-- 	draw = {
			-- 		delay = 0,
			-- 		animation = require("mini.indentscope").gen_animation.none(),
			-- 	},
			-- 	options = {
			-- 		border = "both",
			-- 		indent_at_cursor = false,
			-- 		try_as_border = true,
			-- 	},
			-- 	symbol = "│",
			-- })

			-- vim.api.nvim_create_autocmd(
			-- 	"FileType",
			-- 	{ pattern = { "NvimTree", "python" }, command = ":lua vim.b.miniindentscope_disable=true" }
			-- )

			-- Buf Remove
			require("mini.bufremove").setup()

			vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>")
			vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")

			-- -- Cursor Word
			-- require("mini.cursorword").setup({
			-- 	delay = 0,
			-- })

			-- vim.api.nvim_create_autocmd(
			-- 	"FileType",
			-- 	{ pattern = { "NvimTree" }, command = ":lua vim.b.minicursorword_disable=true" }
			-- )

			-- vim.cmd([[
			--              " hi MiniCursorword        guisp=none guifg=none guibg=#222022 gui=none
			--              " hi MiniCursorword        guisp=none guifg=none guibg=#24141E gui=none
			--              " hi MiniCursorword        guisp=none guifg=none guibg=#2D1625 gui=none

			--              " hi MiniCursorword        guisp=none guifg=none guibg=#35172B gui=none
			--              " hi MiniCursorwordCurrent guisp=none guifg=none guibg=#35172B gui=none

			--              hi MiniCursorword        guisp=none guifg=none guibg=#1c212f gui=none
			--              hi MiniCursorwordCurrent guisp=none guifg=none guibg=#1c212f gui=none
			--          ]])
		end,
	},
}
