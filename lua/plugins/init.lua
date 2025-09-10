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
      vim.keymap.set({ "n", "v" }, "<c-left>", cow.left)
      vim.keymap.set({ "n", "v" }, "<c-down>", cow.down)
      vim.keymap.set({ "n", "v" }, "<c-up>", cow.up)
      vim.keymap.set({ "n", "v" }, "<c-right>", cow.right)
    end,
  },
  {
    "habamax/vim-godot",
    config = function()
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter", "BufWinEnter" }, {
        pattern = "*.gd",
        callback = function()
          vim.opt_local.expandtab = false
        end,
      })

      vim.cmd([[
        setlocal tabstop=4
        setlocal shiftwidth=4
        setlocal indentexpr=
      ]])
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
          "vue",
          "heex",
          "eex",
          "elixir",
        },
        command = "EmmetInstall",
      })
      vim.keymap.set("i", "<c-y>", "<nop>")
      vim.keymap.set("i", "<c-y>", "<Plug>(emmet-expand-abbr)", { nowait = true, silent = true })

      vim.g.user_emmet_install_global = 0
      vim.g.user_emmet_mode = "i"
    end,
  },
}
