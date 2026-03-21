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

      local filetype_map = { tsx = { "typescriptreact", "javascriptreact" } }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim
          .iter(languages)
          :map(function(l)
            return filetype_map[l] or l
          end)
          :flatten()
          :totable(),
        callback = function(ev)
          vim.treesitter.start()
          local lang = vim.bo[ev.buf].filetype
          if not disable_indent[lang] then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
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
}
