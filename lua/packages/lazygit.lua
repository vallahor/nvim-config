local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end

telescope.load_extension("lazygit")

vim.cmd([[
let g:lazygit_floating_window_winblend = 0
let g:lazygit_floating_window_scaling_factor = 1
let g:lazygit_floating_window_corner_chars = ['┌', '┐', '└', '┘']
let g:lazygit_floating_window_use_plenary = 0
]])
