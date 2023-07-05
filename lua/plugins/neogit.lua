return {
	"NeogitOrg/neogit",
	config = function()
		require("neogit").setup()
		vim.keymap.set("n", "<c-g>", "<cmd>Neogit<cr>")
	end,
}
