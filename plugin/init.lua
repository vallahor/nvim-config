vim.pack.add({
  "https://github.com/tpope/vim-repeat",
  "https://github.com/habamax/vim-godot",
  -- "https://github.com/ricardoramirezr/blade-nav.nvim",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "godot", "gdresource", "gdshader" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.cmd([[
      setlocal tabstop=4
      setlocal shiftwidth=4
      setlocal indentexpr=
    ]])
  end,
})
