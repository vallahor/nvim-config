return {
	{
		"noib3/nvim-cokeline",
		config = function()
			local ok, cokeline = pcall(require, "cokeline")
			if ok then
				-- local utils = require("cokeline/utils")
				local get_hex = require("cokeline.hlgroups").get_hl_attr
				-- local yellow = vim.g.terminal_color_3

				local errors_fg = get_hex("DiagnosticError", "fg")
				local warning_fg = get_hex("DiagnosticWarn", "fg")

				cokeline.setup({
					sidebar = {
						filetype = "NvimTree",
						components = {
							{
								text = "",
								-- fg = yellow,
								fg = get_hex("Normal", "fg"),
								-- bg = get_hex("Normal", "bg"),
								-- bg = get_hex("TabLine", "bg"),
								bg = get_hex("StatusLineNC", "bg"),
								bold = true,
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
							bg = get_hex("StatusLineNC", "bg"),
							-- bg = "#191819",
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
							italic = function(buffer)
								return buffer.is_modified
							end,
							undercurl = function(buffer)
								return buffer.diagnostics.errors > 0 or buffer.diagnostics.warnings > 0
							end,
							fg = function(buffer)
								if buffer.diagnostics.errors > 0 then
									-- return "#a23343"
									return errors_fg
								elseif buffer.diagnostics.warnings > 0 then
									return warning_fg
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