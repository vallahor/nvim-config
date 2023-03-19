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
	{
		"windwp/nvim-ts-autotag",
		config = function()
			local ok, autotag = pcall(require, "nvim-ts-autotag")
			if ok then
				autotag.setup({})
			end
		end,
	},
	{ "RRethy/nvim-treesitter-endwise" },
}
