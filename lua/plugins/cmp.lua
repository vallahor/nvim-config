return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline", event = "VeryLazy" },
      { "hrsh7th/cmp-nvim-lsp", lazy = false },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        preselect = true,
        completion = {
          completeopt = "menu,menuone,noinsert",
          placeholder = false,
        },

        formatting = {
          fields = { "abbr", "kind" },

          -- format = function(entry, item)
          --   local entryItem = entry:get_completion_item()
          --   local color = entryItem.documentation

          --   -- check if color is hexcolor
          --   if color and type(color) == "string" and color:match("^#%x%x%x%x%x%x$") then
          --     local hl = "hex-" .. color:sub(2)

          --     if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then
          --       vim.api.nvim_set_hl(0, hl, { fg = color })
          --     end
          --   end

          --   return item
          -- end,
        },

        window = {
          documentation = cmp.config.disable,
        },
        -- experimental = {
        --   ghost_text = { hl_group = "GhostText" },
        -- },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          {
            name = "nvim_lsp",
            -- entry_filter = function(entry, _)
            --   return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            -- end,
          },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        },
        mapping = {
          ["<c-q>"] = cmp.mapping.close(),
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
          ["<down>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end
          end, { "i", "s", "c" }),
          ["<up>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            end
          end, { "i", "s", "c" }),
          ["<tab>"] = cmp.mapping.confirm({
            select = true,
            -- behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<c-tab>"] = cmp.mapping(function()
            cmp.complete()
          end, { "i", "s", "c" }),
          ["<c-space>"] = cmp.mapping.abort(),
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

      -- https://github.com/hrsh7th/cmp-cmdline/issues/108#issuecomment-2003410847
      local cmdline_cmp_state = "has_not_typed"
      vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
        command = "lua cmdline_cmp_state = 'has_not_typed'",
      })
      vim.api.nvim_create_autocmd({ "CmdlineChanged" }, {
        callback = function()
          if cmdline_cmp_state == "has_not_typed" then
            cmdline_cmp_state = "has_typed"
          elseif cmdline_cmp_state == "has_browsed_history" then
            cmdline_cmp_state = "has_not_typed"
          end
        end,
      })
      local function select_or_fallback(select_action)
        return cmp.mapping(function(fallback)
          if cmdline_cmp_state == "has_typed" and cmp.visible() then
            select_action()
          else
            cmdline_cmp_state = "has_browsed_history"
            cmp.close()
            fallback()
          end
        end, { "i", "c" })
      end

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-n>"] = select_or_fallback(cmp.select_next_item),
          ["<C-p>"] = select_or_fallback(cmp.select_prev_item),
          ["<Down>"] = select_or_fallback(cmp.select_next_item),
          ["<Up>"] = select_or_fallback(cmp.select_prev_item),
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
          { name = "cmdline" },
        }),
      })
    end,
  },
}
