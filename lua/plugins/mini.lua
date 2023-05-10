return {
	-- { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- require("mini.move").setup({
			-- 	mappings = {
			-- 		left = "<",
			-- 		right = ">",
			-- 		down = "J",
			-- 		up = "K",
			-- 		line_left = ">",
			--                  line_right = "<",
			-- 		line_down = "",
			-- 		line_up = "",
			-- 	},
			-- })

			-- require("mini.comment").setup({
			-- 	hooks = {
			-- 		pre = function()
			-- 			--	require("ts_context_commentstring.internal").update_commentstring({})
			-- 		end,
			-- 	},
			-- 	mappings = {
			-- 		comment = "gc",
			-- 		comment_line = "gc",
			-- 	},
			-- })

			require("mini.bufremove").setup()

			vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>")
			vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")
		end,
	},
}
