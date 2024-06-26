return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local on_attach = function(client, bufnr)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>zz", { buffer = bufnr, silent = true })
      vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>zz", { buffer = bufnr, silent = true })
      vim.keymap.set("n", "<a-y>", vim.diagnostic.open_float, { buffer = bufnr, silent = true })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
      vim.keymap.set("n", "<c-a>", vim.lsp.buf.code_action, { buffer = bufnr })

      vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr })
      -- vim.keymap.set("n", "<c-3>", "<cmd>lua require('telescope.builtin').lsp_references()<cr>")
      -- vim.keymap.set("n", "<c-1>", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>")
      -- vim.keymap.set("n", "<a-[>", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = bufnr, silent = true })
      -- vim.keymap.set("n", "<a-]>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = bufnr, silent = true })

      client.server_capabilities.semanticTokensProvider = nil

      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   buffer = bufnr,
      --   callback = function()
      --     vim.lsp.buf.format({ async = false })
      --   end,
      -- })
    end

    -- https://www.mitchellhanberg.com/modern-format-on-save-in-neovim/
    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = { "*.odin", "*.zig", "*.cs", "*.*ex", "*.exs" },
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
        if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
          client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- "${3rd}/luv/library"
                  -- "${3rd}/busted/library",
                },
              },
            },
          })

          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
      end,
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

    lspconfig.htmx.setup({
      on_attach = on_attach,
      filetypes = { "html", "templ" },
    })

    lspconfig.tsserver.setup({
      on_attach = on_attach,
    })

    lspconfig.tailwindcss.setup({
      on_attach = on_attach,
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
          fetchDeps = false,
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
