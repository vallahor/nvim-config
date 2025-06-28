return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.4.1",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<c-y>"] = { "accept", "snippet_forward", "fallback" },
        ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
        ["<C-Tab>"] = { "snippet_backward", "fallback" },
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

        ghost_text = { enabled = true },
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

      -- signature = { enabled = true, window = { show_documentation = false } },
    },
    opts_extend = { "sources.default" },
  },
}
