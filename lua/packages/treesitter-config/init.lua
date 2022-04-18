require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "c", "cpp", "javascript", "typescript", "tsx", "zig", "jsonc", "json", "css", "scss" },
  highlight = {
    enable = true,
  },
}
