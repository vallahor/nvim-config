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
            -- max_item_count = 10,
            -- entry_filter = function(entry, _ctx)
            -- 	return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
            -- end,
          },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        },
        mapping = {
          ["<C-q>"] = cmp.mapping.close(),
          ["<c-j>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end
          end, { "i", "s", "c" }),
          ["<c-k>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            end
          end, { "i", "s", "c" }),
          ["<tab>"] = cmp.mapping.confirm({
            select = true,
            -- behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<c-space>"] = cmp.mapping.abort(),
        },
        -- @check
        -- sorting = {
        -- 	comparators = {
        -- 		cmp.config.compare.exact,
        -- 		cmp.config.compare.offset,
        -- 		cmp.config.compare.score,
        -- 		cmp.config.compare.kind,
        -- 		cmp.config.compare.sort_text,
        -- 		cmp.config.compare.length,
        -- 		cmp.config.compare.order,
        -- 	},
        -- },
        experimental = {
          ghost_text = {
            hl_group = "MiniGhostText",
          },
        },
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline({
          ["<Tab>"] = {
            c = function(_)
              if cmp.visible() then
                cmp.confirm()
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-z>", true, true, true), "ni", true)
              end
            end,
          },
        }),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-j>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          },
          ["<C-k>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
          ["<Tab>"] = {
            c = function(_)
              if cmp.visible() then
                cmp.confirm()
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-z>", true, true, true), "ni", true)
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
