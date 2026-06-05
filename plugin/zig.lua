vim.pack.add({
  "https://codeberg.org/ziglang/zig.vim",
})

vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 1

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.zig", "*.zon" },
  callback = function(_)
    vim.lsp.buf.code_action({
      context = { only = { "source.fixAll" } },
      apply = true,
    } --[[@as vim.lsp.buf.code_action.Opts]])
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
    } --[[@as vim.lsp.buf.code_action.Opts]])
  end,
})
