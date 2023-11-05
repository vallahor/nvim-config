return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  -- opts = {
  --   inlay_hints = {
  --     enabled = true,

  --     -- this not work, that's not here @check just a reminder
  --     -- variableTypes = true,
  --     -- functionReturnTypes = true,
  --     -- callArgumentNames = true,
  --   },
  -- },
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
      -- capabilities = capabilities,
    })

    lspconfig.gopls.setup({
      on_attach = on_attach,
      -- capabilities = capabilities,
    })

    lspconfig.tsserver.setup({
      on_attach = on_attach,
      -- capabilities = capabilities,
    })
    lspconfig.svelte.setup({
      on_attach = on_attach,
      -- capabilities = capabilities,
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
      -- capabilities = capabilities,
    })

    lspconfig.clangd.setup({
      on_attach = on_attach,
      -- capabilities = capabilities,
    })

    lspconfig.rust_analyzer.setup({
      on_attach = on_attach,
      -- capabilities = capabilities,
    })

    lspconfig.zls.setup({
      on_attach = on_attach,
      -- capabilities = capabilities,
    })
  end,
}
