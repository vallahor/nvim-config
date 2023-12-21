return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local on_attach = function(client, bufnr)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr, silent = true })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
      vim.keymap.set("n", "<c-a>", vim.lsp.buf.code_action, { buffer = bufnr })

      vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr })
      -- vim.keymap.set("n", "<c-3>", "<cmd>lua require('telescope.builtin').lsp_references()<cr>")
      -- vim.keymap.set("n", "<c-1>", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>")

      client.server_capabilities.semanticTokensProvider = nil
    end

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

    lspconfig.gopls.setup({
      on_attach = on_attach,
    })

    lspconfig.tsserver.setup({
      on_attach = on_attach,
    })
    lspconfig.svelte.setup({
      on_attach = on_attach,
    })

    -- @check how to make it work with htmldjango
    local tailwind_filetypes = lspconfig.tailwindcss.document_config.default_config.filetypes
    table.insert(tailwind_filetypes, "htmldjango")

    lspconfig.tailwindcss.setup({
      on_attach = on_attach,
      filetypes = tailwind_filetypes,
    })

    lspconfig.sqlls.setup({
      on_attach = on_attach,
    })

    lspconfig.jsonls.setup({
      on_attach = on_attach,
    })

    lspconfig.clangd.setup({
      on_attach = on_attach,
    })

    lspconfig.rust_analyzer.setup({
      on_attach = on_attach,
    })

    lspconfig.zls.setup({
      on_attach = on_attach,
    })

    lspconfig.gdscript.setup({
      on_attach = on_attach,
      cmd = { "nc", "localhost", "6005" },
    })
    lspconfig.ols.setup({
      on_attach = on_attach,
    })

    lspconfig.omnisharp.setup({
      on_attach = on_attach,
      cmd = { "dotnet", "C:/apps/omnisharp/OmniSharp.dll" },
    })
  end,
}
