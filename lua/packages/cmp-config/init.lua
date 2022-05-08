local ok, nvim_cmp = pcall(require, "cmp")
if not ok then
	return
end

nvim_cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "git" },
	},
	mapping = {
		["<c-j>"] = nvim_cmp.mapping(function()
			if nvim_cmp.visible() then
				nvim_cmp.select_next_item({ behavior = nvim_cmp.SelectBehavior.Insert, select = false })
			end
		end, { "i", "s" }),

		["<c-k>"] = nvim_cmp.mapping(function()
			if nvim_cmp.visible() then
				nvim_cmp.select_prev_item({ behavior = nvim_cmp.SelectBehavior.Insert, select = false })
			end
		end, { "i", "s" }),
		["<tab>"] = nvim_cmp.mapping.confirm({
			select = true,
			behavior = nvim_cmp.ConfirmBehavior.Replace,
		}),
		["<CR>"] = nvim_cmp.mapping.confirm({
			select = false,
			behavior = nvim_cmp.ConfirmBehavior.Replace,
		}),
		["<c-e>"] = nvim_cmp.mapping.abort(),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})
