return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local on_attach = function(client, _)
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- https://www.mitchellhanberg.com/modern-format-on-save-in-neovim/
    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = { "*.odin", "*.zig", "*.cs", "*.ex", "*.exs", "*.heex" },
      group = vim.api.nvim_create_augroup("lsp", { clear = true }),
      callback = function(args)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.format({ async = false, id = args.data.client_id })
          end,
        })
      end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })

    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
          return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })

    lspconfig.pyright.setup({
      on_attach = on_attach,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    lspconfig.html.setup({
      on_attach = on_attach,
    })

    lspconfig.tsserver.setup({
      on_attach = on_attach,
    })

    lspconfig.tailwindcss.setup({
      on_attach = on_attach,
      filetypes = { "html", "elixir", "eelixir", "heex", "htmldjango" },
      init_options = {
        userLanguages = {
          elixir = "html-eex",
          eelixir = "html-eex",
          heex = "html-eex",
        },
      },
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              'class[:]\\s*"([^"]*)"',
            },
          },
        },
      },
    })

    lspconfig.clangd.setup({
      on_attach = on_attach,
    })

    lspconfig.rust_analyzer.setup({
      on_attach = on_attach,
    })

    lspconfig.ols.setup({
      on_attach = on_attach,
    })

    lspconfig.glsl_analyzer.setup({
      on_attach = on_attach,
    })

    lspconfig.elixirls.setup({
      on_attach = on_attach,
      cmd = { "C:/apps/elixir-ls/language_server.bat" },
      settings = {
        elixirLS = {
          dialyzerEnabled = false,
        },
      },
    })

    lspconfig.sqlls.setup({
      on_attach = on_attach,
    })

    lspconfig.jsonls.setup({
      on_attach = on_attach,
    })

    lspconfig.cssls.setup({
      on_attach = on_attach,
    })

    lspconfig.zls.setup({
      on_attach = on_attach,
    })

    lspconfig.csharp_ls.setup({
      on_attach = on_attach,
    })

    lspconfig.gdscript.setup({
      on_attach = on_attach,
      cmd = { "ncat", "localhost", "6005" },
    })

    -- local pid = vim.fn.getpid()
    -- lspconfig.omnisharp.setup({
    --   cmd = { "C:/apps/omnisharp/OmniSharp.exe", "--languageserver", "--hostPID", tostring(pid) },
    --   on_attach = on_attach,
    --   handlers = {
    --     ["textDocument/definition"] = require("omnisharp_extended").definition_handler,
    --   },
    -- })

    lspconfig.gopls.setup({
      on_attach = on_attach,
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.go", "*.templ" },
      callback = function()
        local params = vim.lsp.util.make_range_params()
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

    vim.filetype.add({ extension = { templ = "templ" } })
    lspconfig.templ.setup({
      on_attach = on_attach,
    })
  end,
}
