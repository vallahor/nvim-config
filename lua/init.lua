vim.pack.add({
  "https://github.com/tpope/vim-repeat",
  "https://github.com/habamax/vim-godot",
  -- "https://github.com/ricardoramirezr/blade-nav.nvim",
})

local cow = require("close_other_window")
vim.keymap.set({ "n", "v" }, "<c-left>", cow.left)
vim.keymap.set({ "n", "v" }, "<c-down>", cow.down)
vim.keymap.set({ "n", "v" }, "<c-up>", cow.up)
vim.keymap.set({ "n", "v" }, "<c-right>", cow.right)

local sb = require("swap_buffer")
vim.keymap.set({ "n", "v" }, "<s-left>", sb.left)
vim.keymap.set({ "n", "v" }, "<s-down>", sb.down)
vim.keymap.set({ "n", "v" }, "<s-up>", sb.up)
vim.keymap.set({ "n", "v" }, "<s-right>", sb.right)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "godot", "gdresource", "gdshader" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.cmd([[
      setlocal tabstop=4
      setlocal shiftwidth=4
      setlocal indentexpr=
    ]])
  end,
})
