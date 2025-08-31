return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local on_attach = function(client, bufnr)
        -- vim.lsp.document_color.enable(true, bufnr, {
        --   style = "virtual",
        -- })
        client.server_capabilities.semanticTokensProvider = nil

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
      -- vim.lsp.semantic_tokens.enable(false)
      vim.lsp.log.set_level(vim.log.levels.ERROR)

      vim.lsp.enable({ "gdscript" })

      -- https://www.reddit.com/r/neovim/comments/1jibjpp/comment/mjgigww/
      -- vim.api.nvim_create_autocmd({ "LspDetach" }, {
      --   group = vim.api.nvim_create_augroup("LspStopWithLastClient", { clear = true }),
      --   callback = function(args)
      --     local client_id = args.data.client_id
      --     local client = vim.lsp.get_client_by_id(client_id)
      --     local current_buf = args.buf

      --     if client then
      --       local clients = vim.lsp.get_clients({ id = client_id })
      --       local count = 0

      --       if clients and #clients > 0 then
      --         local remaining_client = clients[1]

      --         if remaining_client.attached_buffers then
      --           for buf_id in pairs(remaining_client.attached_buffers) do
      --             if buf_id ~= current_buf then
      --               count = count + 1
      --             end
      --           end
      --         end
      --       end

      --       if count == 0 then
      --         client:stop(true)
      --       end
      --     end
      --   end,
      -- })

      vim.lsp.config("lua_ls", {
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
                "${3rd}/love2d/library",
              },
            },
          })
        end,
        settings = {
          Lua = {},
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

      vim.lsp.config("zls", {
        settings = {
          zls = {
            enable_build_on_save = true,
            build_on_save_step = "check",
          },
        },
      })

      local port = os.getenv("GDScript_Port") or "6005"
      vim.lsp.config("gdscript", {
        cmd = { "ncat", "localhost", port },
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

      vim.lsp.config("emmet_language_server", {
        filetypes = {
          {
            "astro",
            "css",
            "eruby",
            "html",
            "htmlangular",
            "htmldjango",
            "less",
            "pug",
            "sass",
            "scss",
            "templ",
          },
        },
        init_options = {
          includeLanguages = {
            eelixir = "html-eex",
            elixir = "phoenix-heex",
            heex = "phoenix-heex",
            vue = "vue",
            typescriptreact = "typescriptreact",
            javascriptreact = "javascriptreact",
          },
        },
      })

      local lspconfig = require("lspconfig")
      lspconfig.laravel_ls.setup({})
      lspconfig.intelephense.setup({
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
              maxMemory = 1024,
              -- environment = {
              --   phpVersion = "8.4.1",
              -- },
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
          "emmet_language_server",
          "html",
          "intelephense",
          "jsonls",
          "laravel_ls",
          "lua_ls",
          "ols",
          "tailwindcss",
          "vtsls",
          "vue_ls",
          "zls",
        },
        automatic_enable = {
          exclude = { "ruff", "laravel_ls", "intelephense" },
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
