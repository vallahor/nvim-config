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
        "sql",
        "yaml",
        "dockerfile",
        "elixir",
        "heex",
        "eex",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        -- disable = { "python", "rust", "cpp", "go", "odin" },
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
      require("nvim-treesitter.configs").setup(opts)

      vim.cmd([[
          autocmd BufRead *.scm set filetype=query
      ]])
    end,
  },
}
