return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    init = function()
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
        "luadoc",
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
        "query",
      }
      local alreadyInstalled = require("nvim-treesitter.config").get_installed()
      local parsersToInstall = vim
        .iter(languages)
        :filter(function(parser)
          return not vim.tbl_contains(alreadyInstalled, parser)
        end)
        :totable()
      require("nvim-treesitter").install(parsersToInstall)

      local disable_indent = {
        cpp = true,
        gdscript = true,
        odin = true,
        python = true,
        rust = true,
        zig = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          pcall(vim.treesitter.start)
          local lang = vim.bo[ev.buf].filetype
          if not disable_indent[lang] then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- require("nvim-treesitter.install").compilers = { "clang" }
      require("nvim-treesitter.install").compilers = { "zig" }
    end,
  },
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter" },
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
}
