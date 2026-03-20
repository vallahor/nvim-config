return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local languages = {
        "bash",
        "blade",
        "c",
        "cpp",
        "css",
        "gdscript",
        "gdshader",
        "godot_resource",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "nu",
        "hyprlang",
        "odin",
        "php",
        "php_only",
        "phpdoc",
        "python",
        "rust",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "zig",
      }

      local treesitter = require("nvim-treesitter")
      treesitter.install(languages)

      local disable_indent = {
        "cpp",
        "gdscript",
        "odin",
        "python",
        "rust",
        "zig",
      }

      languages = vim.tbl_filter(function(lang)
        return not disable_indent[lang]
      end, languages)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = languages,
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- require("nvim-treesitter.install").compilers = { "clang" }
      require("nvim-treesitter.install").compilers = { "zig" }

      vim.cmd([[
          autocmd BufRead *.scm set filetype=query
      ]])
    end,
  },
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "ruby", "lua", "vim", "bash", "elixir", "fish", "julia" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter" },
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },
  {
    {
      "MeanderingProgrammer/treesitter-modules.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      opts = {
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
    },
  },
}
