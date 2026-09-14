-- Neovim 0.13+ built-in multicursors. See :help multicursor.
local api = vim.api
local keymap = vim.keymap.set
local mc = require("user.multicursor")
local mc_ns = mc.ns
local mc_cursor_ns = api.nvim_create_namespace("nvim.multicursor.cursor")
local mc_visual_ns = api.nvim_create_namespace("nvim.multicursor.visual")

local function set_highlights()
  -- Configure both the built-in groups and the explicit overlays below.
  api.nvim_set_hl(0, "MCursor", { link = "Cursor" })
  api.nvim_set_hl(0, "MCursorVisual", { link = "Visual" })
  api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
  api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
end

-- Ghostty supports the Kitty multicursor protocol, but that protocol only
-- draws extra cursor shapes. Force Neovim's highlight renderer instead so the
-- other cursors and their Visual selections use MCursor/MCursorVisual.
local function force_highlight_renderer()
  local ok, builtin_mc = pcall(require, "vim._core.mcursor")
  if ok then
    builtin_mc.tty_cursors(false)
  end
end

local highlight_group = api.nvim_create_augroup("user_builtin_multicursor_highlights", { clear = true })
set_highlights()
api.nvim_create_autocmd("ColorScheme", { group = highlight_group, callback = set_highlights })
api.nvim_create_autocmd({ "VimEnter", "UIEnter" }, {
  group = highlight_group,
  callback = function()
    vim.schedule(force_highlight_renderer)
  end,
})
api.nvim_create_autocmd("TermResponse", {
  group = highlight_group,
  callback = function(event)
    if event.data.sequence:match("^\27%[>[%d;]* q$") then
      -- Run after Neovim handles the terminal response and enables the
      -- protocol, otherwise its handler would turn native cursors back on.
      vim.schedule(force_highlight_renderer)
    end
  end,
})

-- Match overlays win over other text highlights, keeping cursor colors exact.
local overlay_matches = {}

local function clear_overlays(win)
  local ids = overlay_matches[win]
  if not ids then
    return
  end
  overlay_matches[win] = nil
  for _, id in ipairs(ids) do
    pcall(vim.fn.matchdelete, id, win)
  end
end

local function visual_positions(buf)
  local positions = {}
  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)

  for _, mark in ipairs(api.nvim_buf_get_extmarks(buf, mc_visual_ns, 0, -1, { details = true })) do
    local row, col, details = mark[2], mark[3], mark[4]
    local end_row = details.end_row or row
    local end_col = details.end_col or (col + 1)

    if row == end_row then
      positions[#positions + 1] = { row + 1, col + 1, math.max(end_col - col, 1) }
    else
      positions[#positions + 1] = { row + 1, col + 1, math.max(#lines[row + 1] - col, 1) }
      for current_row = row + 1, end_row - 1 do
        positions[#positions + 1] = { current_row + 1 }
      end
      if end_col > 0 then
        positions[#positions + 1] = { end_row + 1, 1, end_col }
      end
    end
  end

  return positions
end

local function refresh_overlays()
  local win = api.nvim_get_current_win()
  clear_overlays(win)

  local buf = api.nvim_win_get_buf(win)
  local cursor_marks = api.nvim_buf_get_extmarks(buf, mc_cursor_ns, 0, -1, { details = true })
  if #cursor_marks == 0 then
    cursor_marks = api.nvim_buf_get_extmarks(buf, mc_ns, 0, -1, { details = true })
  end
  if #cursor_marks == 0 then
    return
  end

  local cursor_positions = {}
  for _, mark in ipairs(cursor_marks) do
    local details = mark[4]
    cursor_positions[#cursor_positions + 1] = {
      mark[2] + 1,
      mark[3] + 1,
      details.end_col and math.max(details.end_col - mark[3], 1) or 1,
    }
  end

  local mode = api.nvim_get_mode().mode
  local cursor_link = mode:sub(1, 1) == "i" and "iCursor"
    or ((mode == "v" or mode == "V" or mode == "\22") and "vCursor" or "Cursor")
  api.nvim_set_hl(0, "MultiCursorCursor", { link = cursor_link })

  local ids = {}
  ids[#ids + 1] = vim.fn.matchaddpos("MultiCursorCursor", cursor_positions, 10000, -1, { window = win })
  local selections = visual_positions(buf)
  if #selections > 0 then
    ids[#ids + 1] = vim.fn.matchaddpos("MultiCursorVisual", selections, 9999, -1, { window = win })
  end
  overlay_matches[win] = ids
end

api.nvim_create_autocmd(
  { "BufEnter", "CmdAtom", "CursorMoved", "CursorMovedI", "ModeChanged", "TextChanged", "TextChangedI", "WinEnter" },
  { group = highlight_group, callback = refresh_overlays }
)
api.nvim_create_autocmd("WinClosed", {
  group = highlight_group,
  callback = function(event)
    overlay_matches[tonumber(event.match)] = nil
  end,
})

local function literal_pattern(text, whole_word)
  local escaped = text:gsub("\\", "\\\\")
  if whole_word then
    return "\\V\\<" .. escaped .. "\\>"
  end
  return "\\V" .. escaped:gsub("\n", "\\n")
end

local function use_search(pattern)
  vim.fn.setreg("/", pattern)
  vim.fn.histadd("search", pattern)
  vim.opt.hlsearch = true
end

-- Add a cursor at every occurrence of the word under the cursor.
keymap("n", "<C-u>", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    return
  end

  local pattern = literal_pattern(word, true)
  use_search(pattern)

  -- [count]Q also adds the match under the primary cursor. That overlapping
  -- cursor makes text objects such as ciw cascade twice and drift into nearby
  -- words. Add matches through the API and explicitly skip the primary.
  local primary = api.nvim_win_get_cursor(0)
  for _, match in ipairs(vim.fn.matchbufline("%", pattern, 1, "$")) do
    if match.lnum ~= primary[1] or match.byteidx ~= primary[2] then
      api.nvim_mcursor(0, { match.lnum, match.byteidx })
    end
  end

  -- This must finish inside the mapping callback. Returning `1q=` from an
  -- expression mapping lets immediately typed commands overtake it.
  vim.cmd.normal({ "1q=", bang = true })
end, { desc = "Add cursors at every word match" })

-- Do the same for an exact Visual selection. Multiline selections are allowed.
keymap("x", "<C-u>", function()
  local anchor = vim.fn.getpos("v")
  local cursor = vim.fn.getpos(".")
  local region = vim.fn.getregion(anchor, cursor, { type = vim.fn.mode() })
  local selection = table.concat(region, "\n")
  if selection == "" then
    return "<Esc>"
  end

  -- Keep the primary cursor on the first byte of the selected match. Leaving
  -- it at the other end would create an overlapping extra cursor on the same
  -- match, which breaks subsequent Visual edits.
  local anchor_is_first = anchor[2] < cursor[2] or (anchor[2] == cursor[2] and anchor[3] <= cursor[3])

  use_search(literal_pattern(selection, false))
  return (anchor_is_first and "o" or "") .. "<Esc>1Q1q="
end, { expr = true, desc = "Add cursors at every selection match" })

-- Leave a cursor behind and move the primary cursor. Follow mode is enabled
-- after adding so subsequent motions and edits are replayed at every cursor.
keymap("n", "<C-j>", "Qj1q=", { desc = "Add cursor below" })
keymap("n", "<C-k>", "Qk1q=", { desc = "Add cursor above" })
keymap("n", "<C-S-j>", "2q=j1q=", { desc = "Skip line below" })
keymap("n", "<C-S-k>", "2q=k1q=", { desc = "Skip line above" })

-- Add/skip the next or previous occurrence of the current word.
keymap("n", "<C-l>", "Q*1q=", { desc = "Add cursor at next word match" })
keymap("n", "<C-h>", "Q#1q=", { desc = "Add cursor at previous word match" })
keymap("n", "<C-S-l>", "2q=*1q=", { desc = "Skip next word match" })
keymap("n", "<C-S-h>", "2q=#1q=", { desc = "Skip previous word match" })

keymap("n", "<C-q>", "q=", { desc = "Toggle multicursor follow mode" })
keymap("n", "Z", "gQ1q=", { desc = "Restore multicursors" })
keymap("n", "<C-z>", "gQ1q=", { desc = "Restore multicursors" })
keymap({ "n", "x" }, "<C-{>", "[C", { desc = "Previous multicursor" })
keymap({ "n", "x" }, "<C-}>", "]C", { desc = "Next multicursor" })

-- Preserve the existing normal-mode Escape behavior when no cursors exist.
local previous_escape = vim.fn.maparg("<Esc>", "n", false, true)
keymap("n", "<Esc>", function()
  if mc.has() then
    api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
    return
  end

  if type(previous_escape.callback) == "function" then
    previous_escape.callback()
  elseif previous_escape.rhs and previous_escape.rhs ~= "" then
    api.nvim_feedkeys(vim.keycode(previous_escape.rhs), "n", false)
  end
end, { desc = "Clear multicursors or escape" })

-- Place one cursor on every selected line before inserting/appending.
keymap("x", "I", "QI", { desc = "Insert at every selected line" })
keymap("x", "A", "QA", { desc = "Append at every selected line" })

-- <C-LeftMouse> and semantic deletion cascading are built in.
