return {
  { "folke/lazy.nvim", version = "*" },
  { "tpope/vim-repeat", event = "VeryLazy" },

  {
    dir = "../swap_buffer.lua",
    event = "VeryLazy",
    config = function()
      require("swap_buffer")
      vim.keymap.set("n", "<leader>h", "<cmd>lua Swap_left()<CR>", { silent = true })
      vim.keymap.set("n", "<leader>j", "<cmd>lua Swap_down()<CR>", { silent = true })
      vim.keymap.set("n", "<leader>k", "<cmd>lua Swap_up()<CR>", { silent = true })
      vim.keymap.set("n", "<leader>l", "<cmd>lua Swap_right()<CR>", { silent = true })
    end,
  },
  {
    dir = "../close_other_window.lua",
    event = "VeryLazy",
    config = function()
      require("close_other_window")
      vim.keymap.set({ "n", "v" }, "<c-s-h>", "<cmd>lua Close_left()<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<c-s-j>", "<cmd>lua Close_down()<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<c-s-k>", "<cmd>lua Close_up()<CR>", { silent = true })
      vim.keymap.set({ "n", "v" }, "<c-s-l>", "<cmd>lua Close_right()<CR>", { silent = true })
    end,
  },
  {
    dir = "../theme.lua",
    init = function()
      require("theme").colorscheme()
    end,
  },
  {
    "mattn/emmet-vim",
    config = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.svelte", "*.vue", "*.tsx", "*.jsx", "*.html" },
        command = ":EmmetInstall",
      })
      vim.keymap.set("i", "<c-y>", "<nop>")
      vim.keymap.set("i", "<c-y>", "<Plug>(emmet-expand-abbr)", { nowait = true, silent = true })

      vim.keymap.set("n", "<leader>gc", "<cmd>call emmet#toggleComment()<cr>", { silent = true })
      vim.keymap.set("v", "<leader>a", '<cmd>call emmet#expandAbbr(2,"")<cr>', { silent = true })
      vim.keymap.set("n", "<leader>d", "<cmd>call emmet#removeTag()<cr>", { silent = true })
    end,
  },
  {
    "Tetralux/odin.vim",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.odin",
        command = ":lua vim.lsp.buf.format()",
      })
      vim.cmd([[
        " from https://github.com/Tetralux/odin.vim/pull/11
        setlocal indentexpr=GetOdinIndent(v:lnum)

        function! GetOdinIndent(lnum)
          let prev = prevnonblank(a:lnum-1)

          if prev == 0
            return 0
          endif

          let prevline = getline(prev)
          let line = getline(a:lnum)

          let ind = indent(prev)

          if prevline =~ '[({]\s*$'
            let ind += &sw
          endif

          " Indent if previous line is a case statement
          if prevline =~ '^\s*case.*:$'
            let ind += &sw
          endif

          if line =~ '^\s*[)}]'
            let ind -= &sw
          endif

          " Un-indent if current line is a case statement
          if line =~ '^\s*case.*:$'
            let ind -= &sw
          endif

          return ind
        endfunction
      ]])
    end,
  },
}
