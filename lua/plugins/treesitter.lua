return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup({})
        end,
      },
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
        "c",
        "c_sharp",
        "cpp",
        "zig",
        "rust",
        "go",
        "templ",
        "gdscript",
        "markdown",
        "markdown_inline",
        "python",
        "json",
        "typescript",
        "svelte",
        "odin",
        "tsx",
        "sql",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      -- indent = {
      --   enable = true,
      --   -- disable = { "python", "rust", "cpp", "go", "ocaml", "zig", "htmldjango", "gdscript" },
      -- },
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
