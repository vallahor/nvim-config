return {
	{
		"noib3/nvim-cokeline",
		config = function()
			local ok, cokeline = pcall(require, "cokeline")
			if ok then
				local utils = require("cokeline/utils")
				local get_hex = require("cokeline/utils").get_hex
				local yellow = vim.g.terminal_color_3
				cokeline.setup({
					sidebar = {
						filetype = "CHADTree",
						components = {
							{
								text = "  CHADTree",
								fg = yellow,
								bg = get_hex("Normal", "bg"),
								style = "bold",
							},
						},
					},
					components = {
						{
							text = "   ",
						},
						{
							text = function(buffer)
								return buffer.filename .. " "
							end,
							style = function(buffer)
								return buffer.is_focused and nil
							end,
						},
						{
							text = function(buffer)
								if buffer.is_modified then
									return "●"
								end
								return " "
							end,
						},
						{
							text = " ",
						},
					},
				})
			end

			vim.keymap.set("n", "<c-,>", "<Plug>(cokeline-focus-prev)")
			vim.keymap.set("n", "<c-.>", "<Plug>(cokeline-focus-next)")
			-- Re-order to previous/next
			vim.keymap.set("n", "<a-,>", "<Plug>(cokeline-switch-prev)")
			vim.keymap.set("n", "<a-.>", "<Plug>(cokeline-switch-next)")
		end,
	},
}
