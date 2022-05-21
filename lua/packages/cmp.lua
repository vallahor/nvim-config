local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "git" },
	},

	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-q>"] = cmp.mapping.close(),
		["<c-j>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert, select = false })
			end
		end, { "i", "s" }),

		["<c-k>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert, select = false })
			end
		end, { "i", "s" }),
		["<tab>"] = cmp.mapping.confirm({
			select = true,
			behavior = cmp.ConfirmBehavior.Replace,
		}),
		["<CR>"] = cmp.mapping.confirm({
			select = true,
		}),
		["<c-e>"] = cmp.mapping.abort(),
	},

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})
