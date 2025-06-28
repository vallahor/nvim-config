return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.4.1",
    ---@module 'blink.cmp'
    -- ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<Up>"] = { "select_prev", "fallback_to_mappings" },
        ["<Down>"] = { "select_next", "fallback_to_mappings" },
        ["<Tab>"] = { "accept", "fallback" },
        ["<C-n>"] = { "snippet_forward" },
        ["<C-p>"] = { "snippet_backward" },
      },

      completion = {
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              label = {
                width = { max = 40 },
              },
              label_description = {
                width = { max = 30 },
              },
            },
          },
        },

        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },

        trigger = {
          show_on_insert_on_trigger_character = true,
          show_on_x_blocked_trigger_characters = {
            "'",
            '"',
            "(",
            "{",
            "[",
          },
          -- show_on_trigger_character = true,
          -- show_on_blocked_trigger_characters = { " ", "\n", "\t" },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          -- window = { border = "single" },
        },

        -- ghost_text = { enabled = true },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = {
          "exact",
          "score",
          "sort_text",
        },
      },

      cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },

      appearance = {
        nerd_font_variant = "mono",
      },
      providers = {
        lsp = {
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              local cmp_item_kind = require("blink.cmp.types").CompletionItemKind

              if item.kind == cmp_item_kind.Property or item.kind == cmp_item_kind.Field then
                item.score_offset = item.score_offset + 1
              end

              -- print(vim.inspect(item))

              if item.kind == cmp_item_kind.Operator then
                item.score_offset = item.score_offset - 1
              end
            end

            return vim.tbl_filter(function(item)
              return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
            end, items)
          end,
        },
      },

      -- signature = { enabled = true, window = { show_documentation = false } },
    },
    opts_extend = { "sources.default" },
  },
}
