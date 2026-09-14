vim.pack.add({ "https://github.com/vallahor/delite.nvim" })
local delite = require("delite")
delite.setup({})

local is_macos = vim.uv.os_uname().sysname == "Darwin"
local previous_word_keys = is_macos and { "<M-BS>", "<C-BS>" } or { "<C-BS>" }
local next_word_key = is_macos and "<M-Del>" or "<C-Del>"

-- delite.insert_pattern({ pattern = "__[%u%l]+__" })

delite.insert_default_pairs_priority({ left = "%{", right = "}" }, { not_filetypes = { "lua" } })

---@diagnostic disable-next-line: param-type-mismatch, missing-fields
delite.edit_default_pairs("'", { not_filetypes = { "ocaml", "rust" } })
delite.insert_rule({ left = '~%u"""', right = '"""', { filetypes = { "elixir" } } })
-- delite.remove_pattern_from_default_pairs("<")
local api = vim.api
local mc = require("user.multicursor")
local replay_ns = api.nvim_create_namespace("user.multicursor.delite")

local function at_every_cursor(action)
  if api.nvim__mcursor_cascading() then
    return
  end

  local marks = api.nvim_buf_get_extmarks(0, mc.ns, 0, -1, {})
  table.sort(marks, function(a, b)
    return a[2] > b[2] or (a[2] == b[2] and a[3] > b[3])
  end)

  -- Track the primary cursor while edits at earlier cursors shift the text.
  local primary = api.nvim_win_get_cursor(0)
  local primary_mark = api.nvim_buf_set_extmark(0, replay_ns, primary[1] - 1, primary[2], {
    right_gravity = true,
  })

  for _, mark in ipairs(marks) do
    local pos = api.nvim_buf_get_extmark_by_id(0, mc.ns, mark[1], {})
    if #pos > 0 and not (pos[1] == primary[1] - 1 and pos[2] == primary[2]) then
      api.nvim_win_set_cursor(0, { pos[1] + 1, pos[2] })
      action()
      local target = api.nvim_win_get_cursor(0)
      mc.set_cursor(mark[1], target[1] - 1, target[2])
    end
  end

  local current_primary = api.nvim_buf_get_extmark_by_id(0, replay_ns, primary_mark, {})
  api.nvim_buf_del_extmark(0, replay_ns, primary_mark)
  if #current_primary > 0 then
    api.nvim_win_set_cursor(0, { current_primary[1] + 1, current_primary[2] })
    action()
  end
end

api.nvim_create_user_command("DeliteMulticursorNextWord", function()
  if mc.has() then
    at_every_cursor(delite.next_word_normal_mode)
    vim.schedule(function()
      api.nvim_feedkeys("a", "it", false)
    end)
  end
end, { force = true })

local function delite_previous_word_insert()
  if not mc.has() then
    delite.previous_word()
    return
  end

  -- Delite deletes one subword at a time, and manually invoking it once per
  -- cursor is itself cascaded by Neovim (so three cursors delete three
  -- subwords). Native CTRL-W is one semantic insert action per cursor and
  -- keeps the insertion point before the remaining character.
  mc.feed("<C-w>")
end

local function delite_next_word_insert()
  if not mc.has() then
    delite.next_word()
    return
  end
  mc.feed("<Esc><Cmd>DeliteMulticursorNextWord<CR>")
end

local function multicursor_or(action)
  return function()
    if mc.has() then
      at_every_cursor(action)
    else
      action()
    end
  end
end

local function delite_or_native(mode, lhs, native_keys, delite_action)
  vim.keymap.set(mode, lhs, function()
    if mc.has() then
      mc.feed(type(native_keys) == "function" and native_keys() or native_keys)
    else
      delite_action()
    end
  end)
end

local simple_pairs = {
  ["("] = ")",
  ["{"] = "}",
  ["["] = "]",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
  ["<"] = ">",
}

local function insert_backspace_keys()
  local _, col = unpack(api.nvim_win_get_cursor(0))
  local line = api.nvim_get_current_line()
  local left = line:sub(col, col)
  local right = line:sub(col + 1, col + 1)

  if simple_pairs[left] == right then
    return "<C-h><Del>"
  end
  if line:sub(col - 1, col) == "%{" and right == "}" then
    return "<C-h><C-h><Del>"
  end
  return "<C-h>"
end

-- delite.nvim performs some fallback edits with queued feedkeys. During a
-- built-in multicursor session, use equivalent native commands instead so
-- insert/normal deletions remain part of Neovim's semantic cascade.
for _, previous_word_key in ipairs(previous_word_keys) do
  vim.keymap.set("i", previous_word_key, delite_previous_word_insert)
  vim.keymap.set("n", previous_word_key, multicursor_or(delite.previous_word_normal_mode))
end

vim.keymap.set("i", next_word_key, delite_next_word_insert)
vim.keymap.set("n", next_word_key, multicursor_or(delite.next_word_normal_mode))
delite_or_native("i", "<BS>", insert_backspace_keys, delite.previous)
-- vim.keymap.set("i", "<del>", delite.next)
delite_or_native("n", "<BS>", '"_x', delite.previous_normal_mode)
delite_or_native("n", "<Del>", '"_x', delite.next_normal_mode)

-- Backspace/Delete are motions in Visual mode by default. Treat them as
-- deletion keys, matching the expected multicursor-editor behavior.
vim.keymap.set("x", { "<BS>", "<C-h>", "<Del>" }, '"_d')

vim.keymap.set("n", "J", delite.join)
vim.keymap.set("i", "<c-j>", delite.join)
