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
        "lua",
        "vim",
        "vimdoc",
        "c",
        "c_sharp",
        "gdscript",
        "gdshader",
        "godot_resource",
        "cpp",
        "css",
        "zig",
        "rust",
        "glsl",
        "hlsl",
        "html",
        "htmldjango",
        "markdown",
        "markdown_inline",
        "mermaid",
        "python",
        "go",
        "templ",
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
        enable = false,
        -- disable = { "python", "rust", "cpp", "go", "odin" },
      },
      incremental_selection = {
        enable = false,
        -- keymaps = {
        --   init_selection = "m",
        --   node_incremental = "m",
        --   node_decremental = "M",
        --   scope_incremental = "<nop>",
        -- },
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
