return {
  dir = "c:/projects/delete.nvim",
  lazy = false,
  config = function()
    -- local delete = require("delete")
    local delite = require("better_delete")
    delite.setup({})

    -- 11::33::44
    delite.insert_pattern({ pattern = "%d%d::%d%d::%d%d" })
    delite.insert_pattern({ pattern = "__[%u]+__" })
    delite.insert_pattern({ pattern = "%x%x%x%x%x%x", prefix = "0x" })
    delite.insert_pattern({ pattern = "__aeho__" })
    -- order matters
    -- delite.insert_pair({ left = "%{", right = "}" }, { filetypes = { "elixir" } })
    delite.insert_rule({ left = "%%{", right = "}", disable_right = true })
    delite.insert_rule({ left = "```", right = "```" })
    delite.insert_rule({ left = "<>", right = "</>" })

    vim.keymap.set("i", "<c-bs>", delite.previous_word)
    vim.keymap.set("i", "<c-del>", delite.next_word)

    vim.keymap.set("i", "<bs>", delite.previous)
    vim.keymap.set("i", "<del>", delite.next)

    vim.keymap.set("i", "<c-j>", delite.join)
    vim.keymap.set("n", "J", delite.join)
  end,
}
