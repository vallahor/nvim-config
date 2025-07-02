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
          map("K", vim.lsp.buf.hover)
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

      vim.lsp.config.roslyn = {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },
          ["csharp|completion"] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_provide_regex_completions = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
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

      vim.lsp.config.tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        root_dir = require("lspconfig").util.root_pattern(
          "mix.exs",
          "tailwind.config.js",
          "tailwind.config.ts",
          "postcss.config.js",
          "postcss.config.ts",
          "package.json",
          "node_modules",
          ".git",
          ".env"
        ),
        filetypes = vim.tbl_extend("force", vim.lsp.config.tailwindcss.filetypes, {
          "elixir",
          "eelixir",
          "heex",
          "ex",
          "htmldjango",
        }),
        settings = {
          tailwindCSS = {
            includeLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
              blade = "html",
              htmldjango = "html",
            },
            experimental = {
              classRegex = {
                'class[:]\\s*"([^"]*)"',
              },
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
        cmd = { "C:/apps/elixir-ls/language_server.bat" },
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

      -- go install golang.org/x/tools/gopls@latest
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.go", "*.templ" },
        callback = function()
          -- local params = vim.lsp.util.make_range_params()
          local params = vim.lsp.util.make_range_params(0, "utf-8")
          params.context = { only = { "source.organizeImports" } }
          -- buf_request_sync defaults to a 1000ms timeout. Depending on your
          -- machine and codebase, you may want longer. Add an additional
          -- argument after params if you find that you have to write the file
          -- twice for changes to be saved.
          -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = {
        "roslyn",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
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
        "csharpier",
        "prettierd",
        "ruff",
        "stylua",
      },
    },
  },
}
