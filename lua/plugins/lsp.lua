return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- local on_attach = function(_, bufnr)
      --   if vim.lsp.document_color then
      --     vim.lsp.document_color.enable(true, bufnr, {
      --       style = "virtual",
      --     })
      --   end

      --   local opts = { buffer = bufnr }
      --   vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      --   vim.keymap.set("n", "<c-a>", vim.lsp.buf.code_action, opts)
      --   vim.keymap.set("n", "K", function()
      --     vim.lsp.buf.hover({ silent = true })
      --   end, opts)
      --   vim.keymap.set("n", "&", vim.diagnostic.open_float, opts)
      --   vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, opts)
      -- end
      vim.lsp.config("*", {
        capabilities = capabilities,
        -- on_attach = on_attach,
      })

      local lsp_augroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_augroup,
        callback = function(args)
          local bufnr = args.buf
          if vim.lsp.document_color then
            vim.lsp.document_color.enable(true, bufnr, {
              style = "virtual",
            })
          end

          local opts = { buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<c-a>", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ silent = true })
          end, opts)
          vim.keymap.set("n", "&", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, opts)
        end,
      })

      vim.lsp.enable({ "gdscript", "nushell", "rust_analyzer", "laravel_ls", "intelephense", "svelte" })

      -- vim.lsp.semantic_tokens.enable(false)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client then
            -- local bufnr = ev.buf
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      local port = os.getenv("GDScript_Port") or "6005"
      vim.lsp.config("gdscript", {
        cmd = { "ncat", "localhost", port },
      })

      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {
                "vim",
                "require",
              },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      })

      vim.lsp.config("laravel_ls", {})
      vim.lsp.config("intelephense", {
        settings = {
          intelephense = {
            files = {
              maxSize = 10000000,
              exclude = {
                "**/.git/**",
                "**/.svn/**",
                "**/.hg/**",
                "**/CVS/**",
                "**/.DS_Store/**",
                "**/node_modules/**",
                "**/bower_components/**",
                "**/vendor/**/{Test,test,Tests,tests}/**",
                "*.twig",
                "*.js",
              },
            },
          },
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
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
          "html",
          "jsonls",
          "lua_ls",
          "ols",
          "rust_analyzer",
          "intelephense",
          "laravel_ls",
          "tailwindcss",
          "vtsls",
          -- "svelte",
        },
        automatic_enable = {
          exclude = { "ruff", "intelephense", "laravel_ls" },
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
        "gdtoolkit",
      },
    },
  },
}
