vim.pack.add({ "https://github.com/jake-stewart/multicursor.nvim" })
vim.pack.add({ "https://github.com/vallahor/delite.nvim" })
local delite = require("delite")
delite.setup({})

-- delite.insert_pattern({ pattern = "__[%u%l]+__" })

delite.insert_default_pairs_priority({ left = "%{", right = "}" }, { not_filetypes = { "lua" } })

---@diagnostic disable-next-line: param-type-mismatch, missing-fields
delite.edit_default_pairs("'", { not_filetypes = { "ocaml", "rust" } })
delite.insert_rule({ left = '~%u"""', right = '"""', { filetypes = { "elixir" } } })
-- delite.remove_pattern_from_default_pairs("<")
-- vim.keymap.set("i", "<c-bs>", delite.previous_word)
vim.keymap.set("i", "<c-del>", delite.next_word)

local mc = require("multicursor-nvim")
vim.keymap.set("i", "<c-bs>", function()
  if mc.hasCursors() then
    mc.feedkeys(vim.api.nvim_replace_termcodes("<c-w>", true, false, true))
  else
    delite.previous_word()
  end
end)

vim.keymap.set("i", "<bs>", delite.previous)
-- vim.keymap.set("i", "<del>", delite.next)

vim.keymap.set("n", "<c-bs>", delite.previous_word_normal_mode)
vim.keymap.set("n", "<c-del>", delite.next_word_normal_mode)

vim.keymap.set("n", "<bs>", delite.previous_normal_mode)
vim.keymap.set("n", "<del>", delite.next_normal_mode)

vim.keymap.set("n", "J", delite.join)
vim.keymap.set("i", "<c-j>", delite.join)
