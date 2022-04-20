require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "c", "cpp", "javascript", "typescript", "tsx", "zig", "jsonc", "json", "css", "scss" },
  highlight = {
    enable = true,
  },
  autotag = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-=>",
      node_incremental = "<c-=>",
      node_decremental = "<c-->",
      scope_incremental = "<c-]>",
    },
  },
}
