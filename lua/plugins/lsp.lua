return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      local lsp_augroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_augroup,
        callback = function(args)
          local bufnr = args.buf
          vim.lsp.document_color.enable(true, { bufnr = bufnr }, { style = "● " })

          local opts = { buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<c-a>", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ silent = true })
          end, opts)
          vim.keymap.set("n", "&", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, opts)
        end,
      })

      vim.lsp.enable({ "gdscript", "nushell", "rust_analyzer", "laravel_ls", "intelephense", "svelte" })

      vim.lsp.semantic_tokens.enable(false)

      local port = os.getenv("GDScript_Port") or "6005"
      vim.lsp.config("gdscript", {
        cmd = { "ncat", "localhost", port },
      })

      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
      })

      vim.lsp.config("emmylua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              library = { vim.env.VIMRUNTIME },
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data")
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
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

      vim.lsp.config("html", {
        filetypes = { "html", "heex", "eex", "elixir", "blade" },
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
                "**/storage/**",
                "**/build/**",
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
          "emmylua_ls",
          "rust_analyzer",
          "intelephense",
          "laravel_ls",
          "tailwindcss",
          "vtsls",
          "vue_ls",
          "svelte",
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
