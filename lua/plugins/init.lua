return {
  { "folke/lazy.nvim", version = "*" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    -- dir = "../swap_buffer.lua",
    "../swap_buffer.lua",
    virtual = true,
    config = function()
      require("swap_buffer")
      vim.keymap.set("n", "<leader>h", "<cmd>lua Swap_left()<CR>")
      vim.keymap.set("n", "<leader>j", "<cmd>lua Swap_down()<CR>")
      vim.keymap.set("n", "<leader>k", "<cmd>lua Swap_up()<CR>")
      vim.keymap.set("n", "<leader>l", "<cmd>lua Swap_right()<CR>")
    end,
  },
  {
    -- dir = "../close_other_window.lua",
    "../close_other_window.lua",
    virtual = true,
    config = function()
      require("close_other_window")
      if vim.g.skeletyl then
        vim.keymap.set({ "n", "v" }, "<c-left>", "<cmd>lua Close_left()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-down>", "<cmd>lua Close_down()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-up>", "<cmd>lua Close_up()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-right>", "<cmd>lua Close_right()<CR>")
      else
        vim.keymap.set({ "n", "v" }, "<c-s-h>", "<cmd>lua Close_left()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-j>", "<cmd>lua Close_down()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-k>", "<cmd>lua Close_up()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-l>", "<cmd>lua Close_right()<CR>")
      end
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
