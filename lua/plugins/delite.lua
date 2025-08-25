return {
  dir = "c:/projects/delite.nvim",
  config = function()
    local delite = require("delite")
    delite.setup({})

    delite.insert_pattern({ pattern = "__[%u%l]+__" })
    delite.insert_rule({ left = "%%{", right = "}" })
    delite.insert_rule({ left = "```", right = "```" })
    delite.insert_rule({ left = "--%(", right = "%)%-%-" }, { filetypes = { "lua" } })

    delite.insert_default_pairs_priority({ left = "%{", right = "}" }, { not_filetypes = { "lua" } })

    delite.edit_default_pairs("'", { not_filetypes = { "ocaml", "rust" } })
    delite.insert_rule({ left = '~%u"""', right = '"""', { filetypes = { "elixir" } } })
    -- delite.remove_pattern_from_default_pairs("<")

    vim.keymap.set("i", "<c-bs>", delite.previous_word)
    vim.keymap.set("i", "<c-del>", delite.next_word)

    -- vim.keymap.set("i", "<bs>", delite.previous)
    -- vim.keymap.set("i", "<del>", delite.next)

    vim.keymap.set("n", "<c-bs>", delite.previous_word_normal_mode)
    vim.keymap.set("n", "<c-del>", delite.next_word_normal_mode)

    vim.keymap.set("n", "<bs>", delite.previous)
    vim.keymap.set("n", "<del>", delite.next)

    vim.keymap.set("n", "J", delite.join)
  end,
}

-- to check the behavior if needed
-- M.next_word_normal_mode = function()
-- 	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
-- 	local line = vim.api.nvim_get_current_line()
-- 	local line_len = #line
-- 	col = col + 1
-- 	if col == line_len then
-- 		local punctuation = line:sub(col, col):match("%p")
-- 		if not punctuation then
-- 			col = col + 1
-- 		end
-- 	end
-- 	local new_pos = delete_word(row - 1, col, utils.direction.right)

-- 	if new_pos then
-- 		row, col = new_pos[1], new_pos[2]
-- 		if col > 0 and col < #vim.api.nvim_get_current_line() then
-- 			vim.api.nvim_win_set_cursor(0, { row + 1, col })
-- 		end
-- 	end
-- end
