return {
  {
    "sbdchd/neoformat",
    config = function()
      vim.g.neoformat_only_msg_on_error = 1
      -- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", command = ":Neoformat ruff" })
      -- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.go", command = ":Neoformat goimports" })
      vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
      -- vim.api.nvim_create_autocmd(
      --   "BufWritePre",
      --   { pattern = { "*.ex", "*.heex", "*.exs" }, command = ":Neoformat mixformat" }
      -- )
      -- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.cs", command = ":Neoformat csharpier" })

      -- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.rs", command = ":Neoformat" })
      -- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.gd", command = ":Neoformat" })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.svelte", "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
        command = ":Neoformat prettierd",
      })
    end,
  },
}
