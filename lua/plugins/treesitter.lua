return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdateSync",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "eex",
        "elixir",
        "erlang",
        "heex",
        "gdscript",
        "html",
        "javascript",
        "json",
        "lua",
        "odin",
        "python",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "zig",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = {
          "cpp",
          "gdscript",
          "go",
          "ocaml",
          "ocaml_interface",
          "odin",
          "python",
          "rust",
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
      -- disable auto install of languages when opening files
      auto_install = false,
      -- disable for files bigger than 100 KB
      disable = function(_, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
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
}
