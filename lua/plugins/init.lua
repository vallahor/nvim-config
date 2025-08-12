return {
  { "folke/lazy.nvim", version = "*" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    -- dir = "../swap_buffer.lua",
    "../swap_buffer.lua",
    virtual = true,
    config = function()
      local sb = require("swap_buffer")
      vim.keymap.set("n", "<s-left>", sb.left)
      vim.keymap.set("n", "<s-down>", sb.down)
      vim.keymap.set("n", "<s-up>", sb.up)
      vim.keymap.set("n", "<s-right>", sb.right)
    end,
  },
  {
    -- dir = "../close_other_window.lua",
    "../close_other_window.lua",
    virtual = true,
    config = function()
      local cow = require("close_other_window")
      if vim.g.skeletyl then
        vim.keymap.set({ "n", "v" }, "<c-left>", cow.left)
        vim.keymap.set({ "n", "v" }, "<c-down>", cow.down)
        vim.keymap.set({ "n", "v" }, "<c-up>", cow.up)
        vim.keymap.set({ "n", "v" }, "<c-right>", cow.right)
      else
        vim.keymap.set({ "n", "v" }, "<c-s-h>", cow.left)
        vim.keymap.set({ "n", "v" }, "<c-s-j>", cow.down)
        vim.keymap.set({ "n", "v" }, "<c-s-k>", cow.up)
        vim.keymap.set({ "n", "v" }, "<c-s-l>", cow.right)
      end
    end,
  },
  {
    "mattn/emmet-vim",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "typescriptreact",
          "javascripreact",
          "html",
          "heex",
          "eex",
          "elixir",
        },
        command = "EmmetInstall",
      })
      vim.keymap.set("i", "<c-y>", "<nop>")
      vim.keymap.set("i", "<c-y>", "<Plug>(emmet-expand-abbr)", { nowait = true, silent = true })

      vim.keymap.set("n", "<leader>mc", "<cmd>call emmet#toggleComment()<cr>")
      vim.keymap.set("v", "<leader>ma", '<cmd>call emmet#expandAbbr(2,"")<cr>')
      vim.keymap.set("n", "<leader>md", "<cmd>call emmet#removeTag()<cr>")

      vim.g.user_emmet_install_global = 0
    end,
  },
  {
    "habamax/vim-godot",
    config = function()
      vim.cmd([[
        setlocal tabstop=4
        setlocal shiftwidth=4
        setlocal indentexpr=
      ]])
    end,
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    build = ":UpdateRemotePlugins",
    dependencies = { "nvim-treesitter" },
    opts = {
      server = {
        override = false,
      },
      document_color = {
        enabled = false,
      },
      keymaps = {
        smart_increment = {
          enabled = false,
        },
      },
    },
  },
}
