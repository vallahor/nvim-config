vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    prefix = "",
  },
  float = {
    show_header = false,
  },
  jump = {
    on_jump = function() end,
  },
  signs = {
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticLinehlError",
      [vim.diagnostic.severity.WARN] = "DiagnosticLinehlWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticLinehlInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticLinehlHint",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticNumhlError",
      [vim.diagnostic.severity.WARN] = "DiagnosticNumhlWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticNumhlInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticNumhlHint",
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
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

-- vim.lsp.config("lua_ls", {
vim.lsp.config("emmylua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath("data") .. "/site/pack/core/opt",
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

vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
require("mason").setup()

vim.pack.add({ "https://github.com/mason-org/mason-lspconfig.nvim" })
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
  ensure_installed = {
    "basedpyright",
    "clangd",
    "cssls",
    "emmylua_ls",
    -- "lua_ls",
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

vim.pack.add({ "https://github.com/zapling/mason-conform.nvim" })
local mason_conform = require("mason-conform")
mason_conform.setup({
  ensure_installed = {
    "prettierd",
    "prettier",
    "ruff",
    "stylua",
    "gdtoolkit",
  },
})
