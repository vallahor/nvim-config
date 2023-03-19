return {
	{
		"ggandor/lightspeed.nvim",
		event = "VeryLazy",
		config = function()
			-- vim.g.lightspeed_no_default_keymaps = true
			require("lightspeed").setup({
				exit_after_idle_msecs = { unlabeled = 300, labeled = nil },
				--- s/x ---
				jump_to_unique_chars = { safety_timeout = 300 },
				ignore_case = true,
				repeat_ft_with_target_char = true,
			})
			-- vim.keymap.set("v", "s", "<Plug>Lightspeed_s")
			-- vim.keymap.set("v", "S", "<Plug>Lightspeed_S")

			vim.keymap.set("v", "n", "<Plug>Lightspeed_s")
			vim.keymap.set("v", "N", "<Plug>Lightspeed_S")
			vim.cmd([[
                let g:lightspeed_last_motion = ''
                augroup lightspeed_last_motion
                autocmd!
                autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
                autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
                augroup end
                map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
                map <expr> , g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"
            ]])
		end,
	},
}
