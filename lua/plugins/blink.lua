return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets", "mini.nvim" },
    version = "1.5.*",
    ---@module 'blink.cmp'
    -- ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
        ["<f1>"] = { "show", "show_documentation", "hide_documentation" },
        ["<f2>"] = { "show_signature", "hide_signature" },
        -- ["<C-k>"] = { "select_prev", "fallback" },
        -- ["<C-j>"] = { "select_next", "fallback" },
        -- ["<C-l>"] = { "accept", "fallback" },
        -- ["<C-h>"] = { "show", "show_documentation", "hide_documentation" },
        -- ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-n>"] = { "snippet_forward" },
        ["<C-p>"] = { "snippet_backward" },
        ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
        ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
        -- ["<C-h>"] = { "show", "show_documentation", "hide_documentation" },
      },

      completion = {
        menu = {
          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
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
            },
          },
        },

        list = {
          max_items = 15,
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
          auto_show = false,
        },

        -- ghost_text = { enabled = true },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                local cmp_item_kind = require("blink.cmp.types").CompletionItemKind

                if item.kind == cmp_item_kind.Property or item.kind == cmp_item_kind.Field then
                  item.score_offset = item.score_offset + 1
                end

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
        keymap = {
          preset = "inherit",
        },

        completion = {
          menu = {
            auto_show = true,
          },

          list = {
            selection = {
              preselect = true,
              auto_insert = false,
            },
          },
        },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      -- signature = { enabled = true, window = { show_documentation = false } },
    },
    opts_extend = { "sources.default" },
  },
}
