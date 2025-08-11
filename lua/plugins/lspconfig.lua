return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local on_attach = function(_, bufnr)
        vim.lsp.document_color.enable(true, bufnr, {
          style = "virtual",
        })

        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<c-a>", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover({ silent = true })
        end, opts)
        vim.keymap.set("n", "&", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, opts)
      end
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.semantic_tokens.enable(false)
      vim.lsp.set_log_level("off")

      vim.lsp.enable({ "gdscript" })

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

          client:request("shutdown", nil, function(err)
            if err then
              client:stop(true)
            end
          end)
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
          "ols",
          "zls",
          "rust_analyzer",
          -- "glsl_analyzer",
          -- "gopls",
          -- "sqlls",
        },
        automatic_enable = {
          exclude = { "ruff" },
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
        "gdformat",
      },
    },
  },
}
