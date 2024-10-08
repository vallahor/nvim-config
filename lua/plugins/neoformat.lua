return {
  {
    "sbdchd/neoformat",
    config = function()
      vim.g.neoformat_only_msg_on_error = 1
      vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = "Neoformat stylua" })

      vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.gd", command = ":Neoformat gdformat" })

      -- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", command = ":Neoformat" })

      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   pattern = "*.html",
      --   callback = function(opts)
      --     if vim.bo[opts.buf].filetype == "htmldjango" then
      --       vim.cmd([[Neoformat djlint]])
      --     else
      --       vim.cmd([[Neoformat prettierd]])
      --     end
      --   end,
      -- })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.css", "*.scss", "*.json" },
        command = ":Neoformat prettierd",
      })
    end,
  },
}
