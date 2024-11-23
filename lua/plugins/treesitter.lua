return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "RRethy/nvim-treesitter-endwise" },
    },
    version = false,
    build = ":TSUpdate",
    event = { "BufRead", "BufEnter" },
    opts = {
      ensure_installed = {
        "asm",
        "bash",
        "comment",
        "lua",
        "vim",
        "vimdoc",
        "c",
        "cpp",
        "c_sharp",
        "css",
        "zig",
        "rust",
        "glsl",
        "hlsl",
        "html",
        "markdown",
        "markdown_inline",
        "mermaid",
        "python",
        "go",
        "proto",
        "json",
        "typescript",
        "javascript",
        "odin",
        "tsx",
        "jsdoc",
        "svelte",
        "vue",
        "sql",
        "yaml",
        "dockerfile",
        "eex",
        "heex",
        "elixir",
        "ocaml",
        "ocaml_interface",
        "php",
        "php_only",
        "phpdoc",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "python", "rust", "cpp", "go", "odin", "ocaml", "ocaml_interface" },
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

      -- ---@class ParserInfo[]
      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_config.blade = {
      --   install_info = {
      --     url = "https://github.com/EmranMR/tree-sitter-blade",
      --     files = {
      --       "src/parser.c",
      --       -- 'src/scanner.cc',
      --     },
      --     branch = "main",
      --     generate_requires_npm = true,
      --     requires_generate_from_grammar = true,
      --   },
      --   filetype = "blade",
      -- }

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
