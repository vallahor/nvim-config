return {
  "RRethy/nvim-treesitter-endwise",
  dependencies = { "nvim-treesitter" },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "ruby", "lua", "vim", "bash", "elixir", "fish", "julia" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
