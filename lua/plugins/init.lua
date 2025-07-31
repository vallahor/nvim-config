return {
  { "folke/lazy.nvim", version = "*" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    -- dir = "../swap_buffer.lua",
    "../swap_buffer.lua",
    virtual = true,
    config = function()
      require("swap_buffer")
      vim.keymap.set("n", "<s-left>", function()
        Swap_left()
      end)
      vim.keymap.set("n", "<s-down>", function()
        Swap_down()
      end)
      vim.keymap.set("n", "<s-up>", function()
        Swap_up()
      end)
      vim.keymap.set("n", "<s-right>", function()
        Swap_right()
      end)
    end,
  },
  {
    -- dir = "../close_other_window.lua",
    "../close_other_window.lua",
    virtual = true,
    config = function()
      require("close_other_window")
      if vim.g.skeletyl then
        vim.keymap.set({ "n", "v" }, "<c-left>", function()
          Close_left()
        end)
        vim.keymap.set({ "n", "v" }, "<c-down>", function()
          Close_down()
        end)
        vim.keymap.set({ "n", "v" }, "<c-up>", function()
          Close_up()
        end)
        vim.keymap.set({ "n", "v" }, "<c-right>", function()
          Close_right()
        end)
      else
        vim.keymap.set({ "n", "v" }, "<c-s-h>", function()
          Close_left()
        end)
        vim.keymap.set({ "n", "v" }, "<c-s-j>", function()
          Close_down()
        end)
        vim.keymap.set({ "n", "v" }, "<c-s-k>", function()
          Close_up()
        end)
        vim.keymap.set({ "n", "v" }, "<c-s-l>", function()
          Close_right()
        end)
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
}
