return {
	"terryma/vim-expand-region",
	dependencies = {
		"kana/vim-textobj-user",
		"kana/vim-textobj-line",
		"kana/vim-textobj-indent",
	},
	config = function()
		vim.keymap.set({ "n", "v" }, "m", "<Plug>(expand_region_expand)")
		vim.keymap.set("v", "M", "<Plug>(expand_region_shrink)")
		vim.g.expand_region_text_objects = {
			["iw"] = 0,
			["iW"] = 0,

			['i"'] = 1,
			["i'"] = 1,

			['a"'] = 1,
			["a'"] = 1,

			["i>"] = 1,
			["i]"] = 1,
			["ib"] = 1,
			["iB"] = 1,

			["a>"] = 1,
			["a]"] = 1,
			["ab"] = 1,
			["aB"] = 1,

			["ii"] = 0,
			["ai"] = 0,

			["il"] = 0,

			["ip"] = 0,
			["ie"] = 0,
		}
	end,
}
