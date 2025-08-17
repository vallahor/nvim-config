local M = {}

local _right = 1
local _left = -1

local pairs_open_close_map = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

local pairs_close_open_map = {
  [")"] = "(",
  ["]"] = "[",
  ["}"] = "{",
  [">"] = "<",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

local function eat_whitespace(line, col, direction)
  local char = line:sub(col, col)
  local col_current = col

  while char:match("%s") and col_current > 0 and col_current <= #line do
    col_current = col_current + direction
    char = line:sub(col_current, col_current)
  end

  return col_current
end

local function get_row_and_line(row, direction)
  local new_row = row + direction
  local line = vim.api.nvim_buf_get_lines(0, new_row, new_row + 1, true)[1]
  local col = (direction == _right and 1) or #line
  return line, new_row, col
end

local function eat_empty_lines(row, col, direction)
  local buf_rows = vim.api.nvim_buf_line_count(0)
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  local new_row, new_col = row, col + direction

  if (row <= 0 and new_col < 0) or (row >= buf_rows - 1 and new_col > #line) then
    return row, col
  end

  if col > #line or col <= 0 then
    line, new_row, new_col = get_row_and_line(row, direction)
  end

  local char = line:sub(new_col, new_col)
  while char:match("%s") or char == "" do
    if new_row + direction < 0 or new_row + direction >= buf_rows then
      break
    end
    if line:match("^[%s]*$") or (new_col < 1 or new_col >= #line) then
      line, new_row, new_col = get_row_and_line(new_row, direction)
    end
    new_col = eat_whitespace(line, new_col, direction)
    char = line:sub(new_col, new_col)
  end

  return new_row, new_col
end

local function walk_line_matching_pattern(line, pattern, char, col, direction)
  local col_current = col
  local char_current = char

  while char_current:match(pattern) and col_current > 0 and col_current <= #line do
    col_current = col_current + direction
    char_current = line:sub(col_current, col_current)
  end

  return col_current
end

---Delete a sequence of characters that match the given pattern.
---@param line string
---@param pattern string
---@param char string
---@param row integer
---@param col integer
---@param direction integer -- _left|_right or -1|1
---@return boolean
local function delete_from_pattern(line, pattern, char, row, col, direction)
  local col_start, col_end = col, col
  local col_current = walk_line_matching_pattern(line, pattern, char, col, direction)

  if direction == _right then
    col_start = col_start - 1
    col_end = col_current - 1
  elseif direction == _left then
    col_start = col_current
  end

  if col_end - col_start > 1 then
    vim.api.nvim_buf_set_text(0, row, col_start, row, col_end, {})
    return true
  end

  return false
end

local function peek_next_symbol(row, col, direction)
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  local peek_row = row
  local peek_col = col + direction

  if col > #line then
    peek_col = col
  end

  local peek_char = line:sub(peek_col, peek_col)
  if peek_char:match("%s") or peek_col < 1 or peek_col > #line then
    peek_row, peek_col = eat_empty_lines(peek_row, peek_col, direction)
    line = vim.api.nvim_buf_get_lines(0, peek_row, peek_row + 1, true)[1]
    peek_char = line:sub(peek_col, peek_col)
  end

  return peek_char, peek_row, peek_col
end

local function find_match_pair(expected_symbol, row, col, direction)
  local row_start, col_start = row, col
  local row_end, col_end = row, col

  local peek_char, peek_row, peek_col = peek_next_symbol(row_start, col_start, direction)
  if peek_char == expected_symbol then
    if direction == _right then
      row_end = peek_row
      col_end = peek_col
    elseif direction == _left then
      row_start = peek_row
      col_start = peek_col
    end
  end

  return row_start, col_start, row_end, col_end
end

local function delete_symbol_or_match_pair(match_pairs, char, row, col, direction)
  if string.match(char, "%p") then
    local row_start, col_start = row, col
    local row_end, col_end = row, col

    if match_pairs[char] then
      row_start, col_start, row_end, col_end = find_match_pair(match_pairs[char], row, col, -direction)
    else
      local line = vim.api.nvim_get_current_line()
      local col_current = walk_line_matching_pattern(line, char, char, col, direction)

      if direction == _right then
        col_end = col_current - 1
      elseif direction == _left then
        col_start = col_current + 1
      end
    end

    vim.api.nvim_buf_set_text(0, row_start, col_start - 1, row_end, col_end, {})
    return true
  end

  return false
end

local function consume_spaces_and_lines(row, col, direction)
  local row_start, col_start = row, col
  local row_end, col_end = row, col

  if direction == _right then
    row_end, col_end = eat_empty_lines(row_start, col_start, direction)
    col_start = col_start - 1
    col_end = (col_end == 0 and 1) or col_end - 1
  elseif direction == _left then
    row_start, col_start = eat_empty_lines(row_end, col_end, direction)
  end

  vim.api.nvim_buf_set_text(0, row_start, col_start, row_end, col_end, {})
end

local function consume_spaces(line, row, col, direction)
  local col_start, col_end = col, col
  local col_current = eat_whitespace(line, col_start, direction)

  if direction == _right then
    col_start = col_start - 1
    col_end = col_current - 1
  elseif direction == _left then
    col_start = col_current
  end

  vim.api.nvim_buf_set_text(0, row, col_start, row, col_end, {})
end

local function delete_word(row, col, direction)
  local line = vim.api.nvim_get_current_line()

  local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)
  vim.api.nvim_feedkeys(mark, "i", false)

  if col == 0 or col > #line then
    consume_spaces_and_lines(row, 0, direction)
    return
  end

  local char = line:sub(col, col)

  if char:match("%s") then
    consume_spaces(line, row, col, direction)
    return
  end

  -- eat digits
  if delete_from_pattern(line, "%d", char, row, col, direction) then
    return
  end

  -- eat upper
  if delete_from_pattern(line, "%u", char, row, col, direction) then
    return
  end

  local match_pairs = {}
  if direction == _right then
    match_pairs = pairs_close_open_map
  elseif direction == _left then
    match_pairs = pairs_open_close_map
  end

  if delete_symbol_or_match_pair(match_pairs, char, row, col, direction) then
    return
  end

  local row_start, col_start = row, col
  local row_end, col_end = row, col
  local col_peek = col + direction

  -- word1 and 1work are being deleted
  while col_peek > 0 and col_peek <= #line do
    char = line:sub(col_peek, col_peek)

    if char:match("%s") then
      break
    end

    if char:match("[%p%d]") and col_peek ~= col then
      break
    end

    if char:match("[%u]") and col_peek ~= col then
      if direction == _left then
        col_peek = col_peek - 1
      end
      break
    end

    col_peek = col_peek + direction
  end

  if direction == _right then
    col_start = col_start - 1
    col_end = col_peek - 1
  elseif direction == _left then
    col_start = col_peek
  end

  print(row_start, col_start, row_end, col_end)

  vim.api.nvim_buf_set_text(0, row_start, col_start, row_end, col_end, {})
end

M.delete_backward_word = function()
  local col = vim.fn.col(".") - 1
  local row = vim.fn.line(".") - 1

  delete_word(row, col, _left)
end

M.delete_next_word = function()
  local col = vim.fn.col(".")
  local row = vim.fn.line(".") - 1

  delete_word(row, col, _right)
end

return M
