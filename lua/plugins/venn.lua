return {
  "jbyuki/venn.nvim",
  config = function()
    function _G.Toggle_venn()
      -- @check: mini.statusline not update by it self we need to press some key to update the mini.statusline
      local venn_enabled = vim.inspect(vim.b.venn_enabled)
      if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd([[setlocal ve=all]])
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<C-h>", "xi<C-v>u25c4<Esc>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", "xi<C-v>u25bc<Esc>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<C-k>", "xi<C-v>u25b2<Esc>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<C-l>", "xi<C-v>u25ba<Esc>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
      else
        vim.cmd([[setlocal ve=]])
        vim.cmd([[mapclear <buffer>]])
        vim.b.venn_enabled = nil
      end
    end

    vim.keymap.set("n", "<c-space>", ":lua Toggle_venn()<CR>", { noremap = true, silent = true })
  end,
}
