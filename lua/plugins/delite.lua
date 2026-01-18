return {
  "vallahor/delite.nvim",
  config = function()
    local delite = require("delite")
    delite.setup({
      disable_right = true,
      -- default_pairs = {},
    })

    -- delite.insert_pattern({ pattern = "__[%u%l]+__" })

    delite.insert_default_pairs_priority({ left = "%{", right = "}" }, { not_filetypes = { "lua" } })

    delite.edit_default_pairs("'", { not_filetypes = { "ocaml", "rust" } })
    delite.insert_rule({ left = '~%u"""', right = '"""', { filetypes = { "elixir" } } })
    -- delite.remove_pattern_from_default_pairs("<")

    vim.keymap.set("i", "<c-bs>", delite.previous_word)
    vim.keymap.set("i", "<c-del>", delite.next_word)

    vim.keymap.set("i", "<bs>", delite.previous)
    -- vim.keymap.set("i", "<del>", delite.next)

    vim.keymap.set("n", "<c-bs>", delite.previous_word_normal_mode)
    vim.keymap.set("n", "<c-del>", delite.next_word_normal_mode)

    vim.keymap.set("n", "<bs>", delite.previous_normal_mode)
    vim.keymap.set("n", "<del>", delite.next_normal_mode)

    vim.keymap.set("n", "J", delite.join)
    vim.keymap.set("i", "<c-j>", delite.join)
  end,
}
