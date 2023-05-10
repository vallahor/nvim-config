return {
	-- {
	-- 	"vim-scripts/camelcasemotion",
	-- 	-- event = "VeryLazy",
	-- 	config = function()
	-- 		-- better than wordmotion
	-- 		vim.cmd([[
	--            map w <Plug>CamelCaseMotion_w
	--            map b <Plug>CamelCaseMotion_b
	--            map e <Plug>CamelCaseMotion_e
	--            sunmap w
	--            sunmap b
	--            sunmap e
	--            " nmap cw ce
	--            " omap iw ie
	--            " xmap iw ie
	--            " omap iw <Plug>CamelCaseMotion_w
	--            " xmap iw <Plug>CamelCaseMotion_w
	--            " omap ib <Plug>CamelCaseMotion_b
	--            " xmap ib <Plug>CamelCaseMotion_b
	--            " omap ie <Plug>CamelCaseMotion_e
	--            " xmap ie <Plug>CamelCaseMotion_e
	--            ]])
	-- 	end,
	-- },
	{
		"chaoren/vim-wordmotion",
		event = "VeryLazy",
		config = function()
			vim.keymap.set({ "n", "v" }, "w", "<Plug>WordMotion_w")
			vim.keymap.set({ "n", "v" }, "b", "<Plug>WordMotion_b")
			vim.keymap.set({ "n", "v" }, "e", "<Plug>WordMotion_e")

			-- better than camelcasemotion
			vim.keymap.set("i", "<c-bs>", "<esc>v<Plug>WordMotion_bc")
		end,
	},
}
