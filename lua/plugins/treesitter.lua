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
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "c",
        "cpp",
        "zig",
        "rust",
        "markdown",
        "markdown_inline",
        "mermaid",
        "python",
        "proto",
        "json",
        "typescript",
        "javascript",
        "svelte",
        "odin",
        "tsx",
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
        enable = false,
        -- disable = { "python", "rust", "cpp", "go", "odin"},
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
      autotag = {
        enable = true,
        enable_close_on_slash = false,
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
