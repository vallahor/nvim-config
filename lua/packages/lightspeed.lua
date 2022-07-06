local ok, lightspeed = pcall(require, "lightspeed")
if not ok then
	return
end

-- vim.g.lightspeed_no_default_keymaps = true

lightspeed.setup({
	exit_after_idle_msecs = { unlabeled = 300, labeled = nil },
	--- s/x ---
	jump_to_unique_chars = { safety_timeout = 300 },
	ignore_case = true,
	repeat_ft_with_target_char = true,
})
