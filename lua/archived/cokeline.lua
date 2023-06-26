return {
	{
		"noib3/nvim-cokeline",
		config = function()
			local ok, cokeline = pcall(require, "cokeline")
			if ok then
				local utils = require("cokeline/utils")
				local get_hex = require("cokeline/utils").get_hex
				local yellow = vim.g.terminal_color_3

				local errors_fg = get_hex("DiagnosticError", "fg")

				cokeline.setup({
					sidebar = {
						-- filetype = "CHADTree",
						filetype = "NvimTree",
						components = {
							{
								-- text = "  CHADTree",
								text = "  AEHO",
								-- fg = yellow,
								fg = get_hex("Normal", "fg"),
								-- bg = get_hex("Normal", "bg"),
								bg = get_hex("TabLine", "bg"),
								style = "bold",
							},
						},
					},
					components = {
						{
							text = function(buffer)
								if buffer.is_first then
									return " "
								else
									return " "
								end
							end,
							-- bg = get_hex("Normal", "bg"),
							bg = "#191819",
						},
						{
							text = " ",
							bg = function(buffer)
								if buffer.is_focused then
									return get_hex("ColorColumn", "bg")
								end
								return "#3d3339"
							end,
						},
						{
							text = " ",
							bg = function(buffer)
								if buffer.is_focused then
									return get_hex("ColorColumn", "bg")
								end
								return "#3d3339"
							end,
						},
						{
							text = function(buffer)
								return buffer.filename
							end,
							style = function(buffer)
								local text_style = "NONE"
								-- if buffer.is_focused then
								-- 	text_style = "bold"
								-- end
								if buffer.is_modified then
									text_style = text_style .. "italic"
								end
								if buffer.diagnostics.errors > 0 then
									if text_style ~= "NONE" then
										text_style = text_style .. ",undercurl"
									else
										text_style = "undercurl"
									end
								end
								return text_style
							end,
							fg = function(buffer)
								if buffer.diagnostics.errors > 0 then
									-- return "#a23343"
									return errors_fg
								end
								if buffer.is_focused then
									return get_hex("Normal", "fg")
								end
								return "#7e706c"
							end,
							bg = function(buffer)
								if buffer.is_focused then
									return get_hex("ColorColumn", "bg")
								end
								return "#3d3339"
							end,
						},
						{
							text = " ",
							bg = function(buffer)
								if buffer.is_focused then
									return get_hex("ColorColumn", "bg")
								end
								return "#3d3339"
							end,
						},
						{
							text = " ",
							bg = function(buffer)
								if buffer.is_focused then
									return get_hex("ColorColumn", "bg")
								end
								return "#3d3339"
							end,
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
