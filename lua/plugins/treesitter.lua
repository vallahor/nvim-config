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

      local treesitter = require("nvim-treesitter")
      treesitter.install(languages)

      local disable_indent = {
        cpp = true,
        gdscript = true,
        odin = true,
        python = true,
        rust = true,
        zig = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(ev)
          local ok, _ = vim.treesitter.get_parser(nil, nil, { error = false })
          if ok then
            vim.treesitter.start()
            local lang = vim.bo[ev.buf].filetype
            if not disable_indent[lang] then
              vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
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
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
}
