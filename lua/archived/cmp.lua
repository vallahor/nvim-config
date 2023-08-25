return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline", event = "VeryLazy" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				preselect = true,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				-- formatting = {
				-- 	format = function(entry, vim_item)
				-- 		vim_item.abbr = vim_item.abbr:match("[^(]+")
				-- 		vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
				-- 		return vim_item
				-- 	end,
				-- },
				window = {
					documentation = cmp.config.disable,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{
						name = "nvim_lsp",
						max_item_count = 10,
						-- entry_filter = function(entry, _ctx)
						-- 	return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
						-- end,
					},
					{ name = "buffer", max_item_count = 10 },
					{ name = "path", max_item_count = 10 },
					-- { name = "luasnip" },
				},
				mapping = {
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
						-- behavior = cmp.ConfirmBehavior.Replace,
					}),
					["<c-space>"] = cmp.mapping.abort(),
				},
				sorting = {
					comparators = {
						cmp.config.compare.exact,
						cmp.config.compare.offset,
						cmp.config.compare.score,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			})
			cmp.setup.cmdline({ "/", "?" }, {
				-- preselect = false,
				-- mapping = cmp.mapping.preset.cmdline(),
				mapping = cmp.mapping.preset.cmdline({
					["<Tab>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm()
							else
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<C-z>", true, true, true),
									"ni",
									true
								)
							end
						end,
					},
				}),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				-- preselect = false,
				-- mapping = cmp.mapping.preset.cmdline(),
				mapping = cmp.mapping.preset.cmdline({
					["<Tab>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm()
							else
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<C-z>", true, true, true),
									"ni",
									true
								)
							end
						end,
					},
				}),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
