local ok, nvim_cmp_git = pcall(require, "cmp_git")
if not ok then
	return
end
nvim_cmp_git.setup()
