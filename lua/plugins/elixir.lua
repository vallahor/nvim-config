return {
  "elixir-editors/vim-elixir",
  config = function()
    -- vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufWinEnter" }, {
    --   pattern = { "*.*ex", "*.*exs" },
    --   command = "silent! TsEnable indent",
    -- })
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = { "*.*ex", "*.*exs" },
    --   command = "silent! TsEnable indent",
    -- })
  end,
}
