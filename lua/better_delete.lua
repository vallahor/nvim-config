local M = {}

local _forward = 1
local _backward = -1

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

local eat_whitespace = function(line, col, direction)
  local char = line:sub(col, col)
  col = col

  while char:match("[%s%t]") and col > 0 and col < #line do
    col = col + direction
    char = line:sub(col, col)
  end

  return col
end

local get_row_and_line = function(row, direction)
  local new_row = row + direction
  local line = vim.api.nvim_buf_get_lines(0, new_row, new_row + 1, true)[1]
  local col = (direction == 1 and 1) or #line
  return line, new_row, col
end

local eat_empty_lines = function(row, col, direction)
  local buf_rows = vim.api.nvim_buf_line_count(0)
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  local new_col = col + direction
  local new_row = row

  if col > #line or col <= 0 then
    line, new_row, new_col = get_row_and_line(row, direction)
  end

  new_col = eat_whitespace(line, new_col, direction)
  local char = line:sub(new_col, new_col)
  while line:match("^[%s]*$") or char:match("%s") or (new_col < 1 and new_row >= 1 and new_row <= buf_rows) do
    line, new_row, new_col = get_row_and_line(new_row, direction)
    new_col = eat_whitespace(line, new_col, direction)
    char = line:sub(new_col, new_col)
  end

  return new_row, new_col
end

---Delete a sequence of characters that match the given pattern.
---@param pattern string
---@param char string
---@param row integer
---@param col integer
---@return boolean
local delete_backward_from_pattern = function(pattern, char, row, col)
  local threshold = 1

  local current_col = col
  local current_char = char

  local line = vim.api.nvim_get_current_line()

  if char == " " then
    threshold = 0
    current_col = eat_whitespace(line, col + _backward, -1)
  else
    while string.match(current_char, pattern) and current_col > 0 do
      current_col = current_col - 1
      current_char = line:sub(current_col, current_col)
    end
  end

  if col - current_col > threshold then
    vim.api.nvim_buf_set_text(0, row, current_col, row, col, {})
    return true
  end

  return false
end

local delete_next_from_pattern = function(pattern, char, row, col)
  local threshold = 1
  local eaten_tokens = 0

  local current_col = col
  local current_char = char

  local line = vim.api.nvim_get_current_line()

  if char == " " then
    eaten_tokens = eaten_tokens + 1
    threshold = 0
    -- current_col = eat_whitespace(line, col + _forward, 1)
    current_col = eat_whitespace(line, col, 1)
    current_char = line:sub(current_col, current_col)
  else
    -- while current_char:match(pattern) and current_col < #line do
    while current_char:match(pattern) do
      eaten_tokens = eaten_tokens + 1
      current_col = current_col + _forward
      current_char = line:sub(current_col, current_col)
    end
  end

  if eaten_tokens > threshold then
    vim.api.nvim_buf_set_text(0, row, col - 1, row, current_col - 1, {})
    -- vim.api.nvim_put({ current_char }, "c", false, false)
    return true
  end

  return false
end

local peek_next_symbol = function(row, col, direction)
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  local peek_row = row
  local peek_col = col + direction

  if col > #line then
    peek_col = col
  end

  local peek_char = line:sub(peek_col, peek_col)
  print("peek_col and col: ", peek_col, col)
  print("peek_next_symbol: ", peek_char)
  print("line length: ", #line)
  if peek_char:match("[%s%t]") or peek_col < 1 or peek_col > #line then
    peek_row, peek_col = eat_empty_lines(peek_row, peek_col, direction)
    line = vim.api.nvim_buf_get_lines(0, peek_row, peek_row + 1, true)[1]
    peek_char = line:sub(peek_col, peek_col)
  end

  return peek_char, peek_row, peek_col
end

local delete_symbol_or_pair_backward = function(char, row, col)
  local threshold = 0
  local eaten_tokens = 0

  local end_row = row
  local end_col = col
  local current_col = col
  if string.match(char, "%p") then
    current_col = current_col - 1
    eaten_tokens = eaten_tokens + 1

    if pairs_open_close_map[char] then
      local peek_char, peek_row, peek_col = peek_next_symbol(row, col, _forward)
      if peek_char == pairs_open_close_map[char] then
        end_row = peek_row
        end_col = peek_col
      end
    end
  end

  if eaten_tokens > threshold then
    vim.api.nvim_buf_set_text(0, row, current_col, end_row, end_col, {})
    return true
  end

  return false
end

local delete_symbol_or_pair_next = function(char, row, col)
  local threshold = 0
  local eaten_tokens = 0

  local row_start, col_start = row, col
  local row_end, col_end = row, col
  if string.match(char, "%p") then
    eaten_tokens = eaten_tokens + 1

    if pairs_close_open_map[char] then
      local peek_char, peek_row, peek_col = peek_next_symbol(row, col, _backward)
      if peek_char == pairs_close_open_map[char] then
        row_start = peek_row
        col_start = peek_col
      end
    end
  end

  if eaten_tokens > threshold then
    vim.api.nvim_buf_set_text(0, row_start, col_start - 1, row_end, col_end, {})
    return true
  end

  return false
end

local consume_spaces = function(row, col, direction)
  local row_start, col_start = row, col
  local row_end, col_end = row, col

  if direction == _forward then
    row_end, col_end = eat_empty_lines(row_start, col_start, direction)
  elseif direction == _backward then
    row_start, col_start = eat_empty_lines(row_end, col_end, direction)
  end

  vim.api.nvim_buf_set_text(0, row_start, col_start, row_end, col_end, {})
end

M.delete_backward_word = function()
  local end_col = vim.fn.col(".") - 1
  local row = vim.fn.line(".") - 1

  if end_col == 0 then
    local bs = vim.api.nvim_replace_termcodes("<c-g>u<bs>", true, false, true)
    vim.api.nvim_feedkeys(bs, "i", false)
    return
  end

  -- mark undo system
  local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)
  vim.api.nvim_feedkeys(mark, "i", false)

  local current_col = end_col
  local current_char = vim.fn.getline("."):sub(current_col, current_col)

  -- eat whitespaces
  if delete_backward_from_pattern("%s", current_char, row, current_col) then
    return
  end

  -- eat digits
  if delete_backward_from_pattern("%d", current_char, row, current_col) then
    return
  end

  -- eat upper
  if delete_backward_from_pattern("%u", current_char, row, current_col) then
    return
  end

  if delete_symbol_or_pair_backward(current_char, row, current_col) then
    return
  end

  while current_col > 0 do
    current_char = vim.fn.getline("."):sub(current_col, current_col)

    if current_char == " " or current_char == "\t" and end_col - current_col > 0 then
      break
    end

    if (string.match(current_char, "%p") or string.match(current_char, "%d")) and current_col ~= end_col then
      break
    end

    if string.upper(current_char) == current_char then
      current_col = current_col - 1
      break
    end

    current_col = current_col - 1
  end

  vim.api.nvim_buf_set_text(0, row, current_col, row, end_col, {})
end

M.delete_next_word = function()
  local col = vim.fn.col(".")
  local row = vim.fn.line(".") - 1
  local line = vim.api.nvim_get_current_line()

  if col > #line then
    local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)
    vim.api.nvim_feedkeys(mark, "i", false)

    consume_spaces(row, #line, _forward)
    return
  end

  -- mark undo system
  local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)
  vim.api.nvim_feedkeys(mark, "i", false)

  local current_col = col
  local char = line:sub(current_col, current_col)

  -- eat whitespaces
  if delete_next_from_pattern("%s", char, row, current_col) then
    return
  end

  -- eat digits
  if delete_next_from_pattern("%d", char, row, current_col) then
    return
  end

  -- eat upper
  if delete_next_from_pattern("%u", char, row, current_col) then
    return
  end

  if delete_symbol_or_pair_next(char, row, current_col) then
    return
  end

  while current_col <= #line do
    char = line:sub(current_col, current_col)

    if char:match("[%s%t]") then
      current_col = current_col - 1
      break
    end

    print(current_col, char, char:match("[%p%d%u]"))
    if char:match("[%p%d%u]") and current_col ~= col then
      current_col = current_col - 1
      break
    end

    current_col = current_col + 1
  end

  vim.api.nvim_buf_set_text(0, row, col - 1, row, current_col, {})
end

return M
