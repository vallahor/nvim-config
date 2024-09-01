return {
  { "folke/lazy.nvim", version = "*" },
  -- { "tpope/vim-repeat", event = "VeryLazy" },

  {
    dir = "../swap_buffer.lua",
    event = "VeryLazy",
    config = function()
      require("swap_buffer")
      vim.keymap.set("n", "<leader>h", "<cmd>lua Swap_left()<CR>", { silent = true })
      vim.keymap.set("n", "<leader>j", "<cmd>lua Swap_down()<CR>", { silent = true })
      vim.keymap.set("n", "<leader>k", "<cmd>lua Swap_up()<CR>", { silent = true })
      vim.keymap.set("n", "<leader>l", "<cmd>lua Swap_right()<CR>", { silent = true })
      -- vim.keymap.set("n", "<a-h>", "<cmd>lua Swap_left()<CR>", { silent = true })
      -- vim.keymap.set("n", "<a-j>", "<cmd>lua Swap_down()<CR>", { silent = true })
      -- vim.keymap.set("n", "<a-k>", "<cmd>lua Swap_up()<CR>", { silent = true })
      -- vim.keymap.set("n", "<a-l>", "<cmd>lua Swap_right()<CR>", { silent = true })
    end,
  },
  {
    dir = "../close_other_window.lua",
    event = "VeryLazy",
    config = function()
      require("close_other_window")
      vim.keymap.set({ "n", "v" }, "<c-left>", "<cmd>lua Close_left()<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<c-down>", "<cmd>lua Close_down()<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<c-up>", "<cmd>lua Close_up()<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<c-right>", "<cmd>lua Close_right()<CR>", { silent = true })
    end,
  },
  {
    "mattn/emmet-vim",
    config = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.svelte", "*.vue", "*.tsx", "*.jsx", "*.html", ".*ex" },
        command = "EmmetInstall",
      })
      vim.keymap.set("i", "<c-y>", "<nop>")
      vim.keymap.set("i", "<c-y>", "<Plug>(emmet-expand-abbr)", { nowait = true, silent = true })

      vim.keymap.set("n", "<leader>mc", "<cmd>call emmet#toggleComment()<cr>", { silent = true })
      vim.keymap.set("v", "<leader>ma", '<cmd>call emmet#expandAbbr(2,"")<cr>', { silent = true })
      vim.keymap.set("n", "<leader>md", "<cmd>call emmet#removeTag()<cr>", { silent = true })
    end,
  },
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.cmd([[
        xmap ga <Plug>(EasyAlign)
        nmap ga <Plug>(EasyAlign)
      ]])
    end,
  },
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
  },
  {
    "habamax/vim-godot",
    event = "BufEnter *.gd",
    config = function()
      vim.cmd([[
        setlocal tabstop=4
        setlocal shiftwidth=4
        setlocal indentexpr=
      ]])
    end,
  },
}
