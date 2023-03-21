return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline", event = "VeryLazy" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				completion = {
					-- completeopt = "menu,noinsert,menuone,noselect",
					completeopt = "menu,preview,menuone,noselect",
				},
				sources = {
					{
						name = "nvim_lsp",
						entry_filter = function(entry, _ctx)
							return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
						end,
					},
					{ name = "buffer" },
					{ name = "path" },
				},
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-q>"] = cmp.mapping.close(),
					["<c-j>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert, select = false })
						end
					end, { "i", "s", "c" }),
					["<c-k>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert, select = false })
						end
					end, { "i", "s", "c" }),
					["<tab>"] = cmp.mapping.confirm({
						select = true,
						behavior = cmp.ConfirmBehavior.Replace,
					}),
					["<c-e>"] = cmp.mapping.abort(),
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
