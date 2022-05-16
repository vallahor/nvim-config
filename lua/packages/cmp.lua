local ok, nvim_cmp = pcall(require, "cmp")
if not ok then
	return
end

local icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "⌘",
	Field = "ﰠ",
	Variable = "",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "塞",
	Value = "",
	Enum = "",
	Keyword = "廓",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "פּ",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
nvim_cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "git" },
		{ name = "nvim_lsp_signature_help" },
	},
	mapping = {
		["<C-Space>"] = nvim_cmp.mapping.complete(),
		["<C-q>"] = nvim_cmp.mapping.close(),
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
	completion = {
		completeopt = "menu,menuone,noinsert",
		keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
		keyword_length = 1,
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(_, vim_item)
			vim_item.menu = vim_item.kind
			vim_item.kind = icons[vim_item.kind]

			return vim_item
		end,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})
