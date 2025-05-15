return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "RRethy/nvim-treesitter-endwise" },
    },
    version = false,
    build = ":TSUpdateSync",
    event = { "BufRead", "BufEnter" },
    opts = {
      ensure_installed = "all",
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        -- disable = { "python", "rust", "cpp", "go", "odin", "ocaml", "ocaml_interface", "blade", "gdscript", "zig" },
        disable = {
          "python",
          "rust",
          "cpp",
          "go",
          "odin",
          "ocaml",
          "ocaml_interface",
          "blade",
          "gdscript",
          "zig",
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "m",
          node_incremental = "m",
          node_decremental = "M",
          scope_incremental = "<nop>",
        },
      },
      endwise = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").compilers = { "clang" }

      vim.cmd([[
          autocmd BufRead *.scm set filetype=query
      ]])

      require("nvim-treesitter.configs").setup(opts)
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }

      -- parser_config.blade = {
      --   install_info = {
      --     url = "https://github.com/deanrumsby/tree-sitter-blade",
      --     files = { "src/parser.c", "src/scanner.c" },
      --     branch = "main",
      --   },
      --   filetype = "blade",
      -- }

      vim.cmd([[
        augroup BladeFiletypeRelated
        autocmd!
        autocmd BufNewFile,BufRead *.blade.php set ft=blade
        augroup END
      ]])

      vim.cmd([[
        augroup BladeIndentation
        autocmd!
        autocmd FileType blade setlocal tabstop=2 shiftwidth=2 expandtab
        augroup END
      ]])

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
