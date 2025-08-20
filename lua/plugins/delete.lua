return {
  dir = "c:/projects/delete.nvim",
  -- lazy = false,
  config = function()
    -- local delete = require("delete")
    local delite = require("better_delete")
    delite.setup()

    delite.insert_pattern({ pattern = "%d%d::%d%d::%d%d" })
    -- order matters
    delite.insert_pair({ first = "%%{", second = "}" })
    delite.insert_pair({ first = "{", second = "}" })

    vim.keymap.set("i", "<c-bs>", delite.previous_word)
    vim.keymap.set("i", "<c-del>", delite.next_word)

    vim.keymap.set("i", "<bs>", delite.previous)
    -- vim.keymap.set("i", "<del>", delite.next)

    vim.keymap.set("i", "<c-j>", delite.join)
    vim.keymap.set("n", "J", delite.join)
  end,
}
