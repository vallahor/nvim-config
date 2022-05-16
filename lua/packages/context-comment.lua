local ok, nvim_context_comment = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end
nvim_context_comment.setup({
	context_commentstring = {
		enable = true,
	},
})
