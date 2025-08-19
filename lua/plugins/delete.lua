return {
  dir = "c:/projects/delete.nvim",
  lazy = false,
  config = function()
    -- local delete = require("delete")
    local delete = require("better_delete")
    delete.setup()
    vim.keymap.set("i", "<c-bs>", delete.previous_word)
    vim.keymap.set("i", "<c-del>", delete.next_word)

    vim.keymap.set("i", "<bs>", delete.previous)
    -- vim.keymap.set("i", "<del>", delete.next)

    vim.keymap.set("i", "<c-j>", delete.join)
    vim.keymap.set("n", "J", delete.join)
  end,
}
