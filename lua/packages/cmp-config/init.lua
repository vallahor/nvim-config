local cmp = require('cmp')
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'luasnip' },
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ["<c-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert, select = false })
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<c-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert, select = false })
      end
    end, { "i", "s" }),
    ['<tab>'] = cmp.mapping.confirm({ select = true }),
    ['<c-e>'] = cmp.mapping.abort(),
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

}