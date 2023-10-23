return {
	{
		"windwp/nvim-autopairs",
		event = "VeryLazy",
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({
				disable_filetype = { "TelescopePrompt", "vim" },
			})
		end,
	},
}
