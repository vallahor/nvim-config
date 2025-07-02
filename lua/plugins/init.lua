return {
  { "folke/lazy.nvim", version = "*" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "sheerun/vim-polyglot" },
  {
    -- dir = "../swap_buffer.lua",
    "../swap_buffer.lua",
    virtual = true,
    -- event = "VeryLazy",
    config = function()
      require("swap_buffer")
      vim.keymap.set("n", "<leader>h", "<cmd>lua Swap_left()<CR>")
      vim.keymap.set("n", "<leader>j", "<cmd>lua Swap_down()<CR>")
      vim.keymap.set("n", "<leader>k", "<cmd>lua Swap_up()<CR>")
      vim.keymap.set("n", "<leader>l", "<cmd>lua Swap_right()<CR>")
      -- if vim.g.skeletyl then
      --   vim.keymap.set("n", "<a-H>", "<cmd>lua Swap_left()<CR>")
      --   vim.keymap.set("n", "<a-J>", "<cmd>lua Swap_down()<CR>")
      --   vim.keymap.set("n", "<a-K>", "<cmd>lua Swap_up()<CR>")
      --   vim.keymap.set("n", "<a-L>", "<cmd>lua Swap_right()<CR>")
      -- else
      --   vim.keymap.set("n", "<a-h>", "<cmd>lua Swap_left()<CR>")
      --   vim.keymap.set("n", "<a-j>", "<cmd>lua Swap_down()<CR>")
      --   vim.keymap.set("n", "<a-k>", "<cmd>lua Swap_up()<CR>")
      --   vim.keymap.set("n", "<a-l>", "<cmd>lua Swap_right()<CR>")
      -- end
    end,
  },
  {
    -- dir = "../close_other_window.lua",
    "../close_other_window.lua",
    virtual = true,
    -- event = "VeryLazy",
    config = function()
      require("close_other_window")
      if vim.g.skeletyl then
        vim.keymap.set({ "n", "v" }, "<c-s-h>", "<cmd>lua Close_left()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-j>", "<cmd>lua Close_down()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-k>", "<cmd>lua Close_up()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-l>", "<cmd>lua Close_right()<CR>")

        -- vim.keymap.set({ "n", "v" }, "<c-left>", "<cmd>lua Close_left()<CR>")
        -- vim.keymap.set({ "n", "v" }, "<c-down>", "<cmd>lua Close_down()<CR>")
        -- vim.keymap.set({ "n", "v" }, "<c-up>", "<cmd>lua Close_up()<CR>")
        -- vim.keymap.set({ "n", "v" }, "<c-right>", "<cmd>lua Close_right()<CR>")
      else
        vim.keymap.set({ "n", "v" }, "<c-s-h>", "<cmd>lua Close_left()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-j>", "<cmd>lua Close_down()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-k>", "<cmd>lua Close_up()<CR>")
        vim.keymap.set({ "n", "v" }, "<c-s-l>", "<cmd>lua Close_right()<CR>")
      end
    end,
  },
  {
    "mattn/emmet-vim",
    config = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.php", "*.svelte", "*.vue", "*.tsx", "*.jsx", "*.html", ".*ex" },
        command = "EmmetInstall",
      })
      vim.keymap.set("i", "<c-y>", "<nop>")
      vim.keymap.set("i", "<c-y>", "<Plug>(emmet-expand-abbr)", { nowait = true, silent = true })

      vim.keymap.set("n", "<leader>mc", "<cmd>call emmet#toggleComment()<cr>")
      vim.keymap.set("v", "<leader>ma", '<cmd>call emmet#expandAbbr(2,"")<cr>')
      vim.keymap.set("n", "<leader>md", "<cmd>call emmet#removeTag()<cr>")
    end,
  },
  -- {
  --   "junegunn/vim-easy-align",
  --   config = function()
  --     vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
  --   end,
  -- },
  -- {
  --   "ricardoramirezr/blade-nav.nvim",
  --   dependencies = { -- totally optional
  --     "hrsh7th/nvim-cmp", -- if using nvim-cmp
  --   },
  --   ft = { "blade", "php" }, -- optional, improves startup time
  --   opts = {
  --     close_tag_on_complete = true, -- default: true
  --   },
  -- },
  -- {
  --   "habamax/vim-godot",
  --   config = function()
  --     vim.cmd([[
  --       setlocal tabstop=4
  --       setlocal shiftwidth=4
  --       setlocal indentexpr=
  --     ]])
  --   end,
  -- },
  {
    "ziglang/zig.vim",
    config = function()
      vim.cmd([[
        let g:zig_fmt_autosave = 0
      ]])

      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   pattern = { "*.zig", "*.zon" },
      --   callback = function(_)
      --     vim.lsp.buf.code_action({
      --       context = { only = { "source.fixAll" }, diagnostics = {} },
      --       apply = true,
      --     })
      --     vim.lsp.buf.format()
      --   end,
      -- })
    end,
  },
  {
    "posva/vim-vue",
  },
}
