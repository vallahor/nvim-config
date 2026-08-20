local nvim_set_hl = vim.api.nvim_set_hl

vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
})

nvim_set_hl(0, "DiagnosticLineNumhlError", { fg = "#a1495c", bg = "#221418" })
nvim_set_hl(0, "DiagnosticLineNumhlWarn", { fg = "#a1495c", bg = "#221c12" })
nvim_set_hl(0, "DiagnosticLineNumhlInfo", { fg = "#a1495c", bg = "#1c1a1c" })
nvim_set_hl(0, "DiagnosticLineNumhlHint", { fg = "#a1495c", bg = "#1a1a1a" })

vim.diagnostic.config({
  update_in_insert = false,
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

    local diagnostic_opts = { buffer = bufnr, nowait = true, silent = true }
    vim.keymap.set({ "n", "v", "x" }, "[", function()
      vim.diagnostic.jump({ count = -1, float = false })
    end, diagnostic_opts)
    vim.keymap.set({ "n", "v", "x" }, "]", function()
      vim.diagnostic.jump({ count = 1, float = false })
    end, diagnostic_opts)
  end,
})

vim.lsp.enable({ "gdscript", "nushell", "rust_analyzer", "svelte" })

vim.lsp.semantic_tokens.enable(false)

local port = os.getenv("GDScript_Port") or "6005"
vim.lsp.config("gdscript", {
  -- cmd = { "ncat", "localhost", port },
  cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
})

vim.lsp.config("emmylua_ls", {
  settings = {
    emmylua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
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

-- vim.lsp.config("tsgo", {
--   init_options = {
--     hostInfo = "neovim",
--     plugins = {
--       {
--         name = "typescript-svelte-plugin",
--         location = vim.fn.stdpath("data")
--           .. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin",
--         enableForWorkspaceTypeScriptVersions = true,
--       },
--     },
--   },
-- })

local mason = vim.fn.stdpath("data") .. "/mason/packages"
local vue_ls_path = mason .. "/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("ts_ls", {
  init_options = {
    hostInfo = "neovim",
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_ls_path,
        languages = { "vue" },
      },
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
})

vim.lsp.config("vue_ls", {
  init_options = {
    vue = {
      hybridMode = true,
    },
    typescript = {
      tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
    },
  },
})

-- vim.lsp.config("basedpyright", {
--   settings = {
--     basedpyright = {
--       analysis = {
--         typeCheckingMode = "standard",
--       },
--     },
--   },
-- })

local function python_path(root_dir)
  if not root_dir then
    return nil
  end

  local candidates = {
    root_dir .. "/.venv/Scripts/python.exe",
    root_dir .. "/.venv/bin/python",
    root_dir .. "/venv/Scripts/python.exe",
    root_dir .. "/venv/bin/python",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
end

vim.lsp.config("basedpyright", {
  filetypes = { "python" },
  root_markers = { "manage.py", "pyproject.toml", "pyrightconfig.json", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  before_init = function(_, config)
    local path = python_path(config.root_dir)
    if path then
      config.settings = config.settings or {}
      config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
        pythonPath = path,
      })
    end
  end,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        extraPaths = { "." },
        diagnosticSeverityOverrides = {
          reportIncompatibleMethodOverride = "none",
          reportIncompatibleVariableOverride = "none",
          reportAttributeAccessIssue = "none",
          reportUnknownMemberType = "none",
          reportUnknownVariableType = "none",
          reportUnknownArgumentType = "none",
          reportGeneralTypeIssues = "warning",
          reportArgumentType = "none",
          reportFunctionMemberAccess = "none",
        },
      },
    },
  },
})

vim.lsp.config("laravel_lsp", {
  cmd = { "laravel-lsp" },
  filetypes = { "php", "blade" },
  root_markers = { "artisan", "composer.json", ".git" },
})

vim.lsp.enable("laravel_lsp")

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
      require("mason").setup()

      vim.pack.add({ "https://github.com/mason-org/mason-lspconfig.nvim" })
      require("mason-lspconfig").setup({
        ensure_installed = {
          "basedpyright",
          "clangd",
          "emmylua_ls",
          "expert",
          "html",
          "jsonls",
          "rust_analyzer",
          "svelte",
          "vue_ls",
          -- "tsgo",
          -- "vtsls",
          "ts_ls",
          -- "laravel_ls",
          "phpantom_lsp",
          "ols",
          "zls",
          "cssls",
          "tailwindcss",
        },
        automatic_enable = {
          exclude = { "ruff" },
        },
      })

      vim.pack.add({ "https://github.com/zapling/mason-conform.nvim" })
      require("mason-conform").setup({
        ensure_installed = {
          "gdscript-formatter",
          "gdtoolkit",
          "prettier",
          "prettierd",
          "ruff",
          "stylua",
        },
      })
    end)
  end,
})
