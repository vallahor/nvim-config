return {
	"NeogitOrg/neogit",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("neogit").setup()
		vim.keymap.set("n", "<c-g>", "<cmd>Neogit<cr>")
	end,
}
