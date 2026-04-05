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

      vim.lsp.enable({ "gdscript", "nushell", "rust_analyzer", "svelte" })

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
              library = {
                vim.env.VIMRUNTIME,
                vim.fn.stdpath("data") .. "/lazy",
              },
              checkThirdParty = false,
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
                  name = "typescript-svelte-plugin",
                  location = vim.fn.stdpath("data")
                    .. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
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
          "emmylua_ls",
          "html",
          "jsonls",
          "rust_analyzer",
          "svelte",
          "tailwindcss",
          "vtsls",
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
        "prettier",
        "ruff",
        "stylua",
        "gdtoolkit",
      },
    },
  },
}
