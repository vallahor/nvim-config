return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local on_attach = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
      end
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local map = function(keys, func)
            vim.keymap.set("n", keys, func, { buffer = ev.buf })
          end

          local telescope = require("telescope.builtin")
          map("gi", telescope.lsp_implementations)
          map("gr", telescope.lsp_references)
          map("gd", function()
            vim.lsp.buf.definition()
            vim.defer_fn(function()
              -- vim.api.nvim_feedkeys("zz", "n", false)
              vim.cmd("norm! zzzz")
            end, 100)
          end)
          map("<c-a>", vim.lsp.buf.code_action)
          map("K", function()
            vim.lsp.buf.hover({ silent = true })
          end)
          map("&", vim.diagnostic.open_float)
          map("`", vim.diagnostic.open_float)
          map("<c-*>", vim.lsp.buf.rename)
          map("<f2>", vim.lsp.buf.rename)
        end,
      })

      -- https://www.reddit.com/r/neovim/comments/1jibjpp/comment/mjgigww/
      vim.api.nvim_create_autocmd({ "LspDetach" }, {
        group = vim.api.nvim_create_augroup("LspStopWithLastClient", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or not client.attached_buffers then
            return
          end
          for buf_id in pairs(client.attached_buffers) do
            if buf_id ~= args.buf then
              return
            end
          end
          client:stop()
        end,
        desc = "Stop lsp client when no buffer is attached",
      })

      vim.lsp.config.lua_ls = {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath("config")
              and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
              path = {
                "lua/?.lua",
                "lua/?/init.lua",
              },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      }

      vim.lsp.config.basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      }

      -- rustup component add rust-src
      vim.lsp.config.rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allTargets = false,
            },
          },
        },
      }

      vim.lsp.config.elixirls = {
        -- cmd = { "C:/apps/elixir-ls/language_server.bat" },
        settings = {
          elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false,
            enableTestLenses = false,
            suggestSpecs = false,
          },
        },
      }

      vim.lsp.config.zls = {
        settings = {
          zls = {
            enable_build_on_save = true,
            build_on_save_step = "check",
          },
        },
      }

      local port = os.getenv("GDScript_Port") or "6005"
      vim.lsp.config.gdscript = {
        cmd = { "ncat", "localhost", port },
      }
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "nvim-lspconfig",
      "mason.nvim",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "basedpyright",
          "clangd",
          "cssls",
          "elixirls",
          "html",
          "jsonls",
          "lua_ls",
          "tailwindcss",
          "vtsls",
          "zls",
          -- "gdshader_lsp",
          -- "glsl_analyzer",
          -- "gopls",
          -- "ols",
          -- "sqlls",
          -- "ts_ls",
        },
        automatic_enable = {
          exclude = { "gdscript", "ruff" },
        },
      })
    end,
  },
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "mason.nvim",
      "conform.nvim",
    },
    opts = {
      ensure_installed = {
        "prettierd",
        "ruff",
        "stylua",
      },
    },
  },
}
