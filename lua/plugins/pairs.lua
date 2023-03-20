return {
	-- {
	-- 	"windwp/nvim-autopairs",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		local autopairs = require("nvim-autopairs")
	-- 		autopairs.setup({
	-- 			disable_filetype = { "TelescopePrompt" },
	-- 		})
	-- 	end,
	-- },
	-- auto pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},
}
