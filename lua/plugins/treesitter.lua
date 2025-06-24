return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdateSync",
    opts = {
      ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "python", "javascript", "typescript", "rust", "bash", "html", "json", "tsx"},
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
    },
    config = function(_, opts)
      require("nvim-treesitter.install").compilers = { "clang" }

      vim.cmd([[
          autocmd BufRead *.scm set filetype=query
      ]])

      require("nvim-treesitter.configs").setup(opts)
    end,

  },
  {
    "brianhuster/treesitter-endwise.nvim",
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {'ruby', 'lua', 'vim', 'bash', 'elixir', 'fish', 'julia'},
        callback = function()
          vim.treesitter.start()
        end
      })
    end
  },
}
