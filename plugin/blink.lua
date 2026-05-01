vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "blink.cmp" and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add({
  "https://github.com/Saghen/blink.lib",
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("*") },
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  once = true,
  callback = function()
    ---@diagnostic disable: param-type-mismatch, missing-fields
    require("blink.cmp").setup({
      keymap = {
        preset = "none",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<c-k>"] = { "select_prev", "fallback" },
        ["<c-j>"] = { "select_next", "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
        ["<c-space>"] = { "accept", "fallback" },
        ["<f1>"] = { "show", "show_documentation", "hide_documentation" },
        ["<f2>"] = { "show_signature", "hide_signature" },
        ["<C-n>"] = { "snippet_forward" },
        ["<C-p>"] = { "snippet_backward" },
        ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
        ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
      },

      completion = {
        menu = {
          draw = {
            components = {
              label = {
                width = { fill = true, max = 40 },
              },
            },
            columns = { { "label", "label_description", gap = 1 }, { "kind" } },
          },
        },

        accept = {
          auto_brackets = { enabled = false },
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
        },

        documentation = {
          auto_show = false,
        },
      },

      -- https://code.visualstudio.com/docs/editing/userdefinedsnippets
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
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
        },
      },

      fuzzy = {
        implementation = "rust",
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

      signature = {
        enabled = true,
        trigger = {
          enabled = false,
          show_on_keyword = true,
          show_on_insert = true,
        },
        window = {
          show_documentation = false,
        },
      },
    })
  end,
})
