local M = {}

local pairs_map = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

local eat_whitespace = function(line, col, direction)
  local char = line:sub(col, col)

  while char:match("[%s%t]") and col >= 1 and col < #line do
    col = col + direction
    char = line:sub(col, col)
  end

  return col
end

local get_row_and_line = function(row, direction)
  local line = vim.api.nvim_buf_get_lines(0, row + direction, row + direction + direction, true)[1]
  local col = (direction == 1 and 1) or #line
  return line, row + direction, col
end

local eat_empty_lines = function(row, col, direction)
  local buf_rows = vim.api.nvim_buf_line_count(0)
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  local new_col = col
  local new_row = row

  if new_col == #line then
    line, new_row, new_col = get_row_and_line(row, direction)
  end

  new_col = eat_whitespace(line, new_col, direction)

  while (new_col == 1 or new_col == #line) and new_row + direction > 1 and new_row + direction < buf_rows do
    line, new_row, new_col = get_row_and_line(new_row, direction)
    new_col = eat_whitespace(line, new_col, direction)
  end

  print(line)
  print(new_col, #line)
  return new_row, new_col
end

local delete_backward_from_pattern = function(pattern, char, row, col)
  local threshold = 1

  local current_col = col
  local current_char = char

  if char == " " then
    threshold = 0
    -- (col - 1) -> accounts for the new column added by the insert mode
    current_col = eat_whitespace(vim.api.nvim_get_current_line(), col - 1, -1)
  else
    while string.match(current_char, pattern) and current_col > 0 do
      current_col = current_col - 1
      current_char = vim.fn.getline("."):sub(current_col, current_col)
    end
  end

  if col - current_col > threshold then
    vim.api.nvim_buf_set_text(0, row, current_col, row, col, {})
    return true
  end

  return false
end

local peek_next_symbol = function(row, col)
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  local peek_row = row
  local peek_col = col + 1

  if col == #line then
    peek_col = col
  end

  local peek_char = line:sub(peek_col, peek_col)
  if peek_char:match("[%s%t]") or col == #line then
    peek_row, peek_col = eat_empty_lines(peek_row, peek_col, 1)
    line = vim.api.nvim_buf_get_lines(0, peek_row, peek_row + 1, true)[1]
    peek_char = line:sub(peek_col, peek_col)
  end

  return peek_char, peek_row, peek_col
end

local delete_symbol_or_pair_backward = function(char, row, col)
  local threshold = 0

  local end_row = row
  local end_col = col
  local current_col = col
  local current_char = char
  if string.match(current_char, "%p") then
    current_col = current_col - 1

    if pairs_map[current_char] then
      local peek_char, peek_row, peek_col = peek_next_symbol(row, col)
      if peek_char == pairs_map[current_char] then
        end_row = peek_row
        end_col = peek_col
      end
    end
  end

  if col - current_col > threshold then
    vim.api.nvim_buf_set_text(0, row, current_col, end_row, end_col, {})
    return true
  end

  return false
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

return M
