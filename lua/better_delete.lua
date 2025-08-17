local M = {}

local _right = 1
local _left = -1
local _bufnr = 0

local utils = {
  keys = {
    bs = "<bs>",
    del = "<del>",
  },
}

M.config = {
  delete_empty_lines_until_next_char = {
    enable = true,
  },
  delete_repeated_punctuation = {
    enable = true,
  },
  delete_pairs = {
    open_close = {
      enable = true,
      match_pairs = {
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ["<"] = ">",
        ['"'] = '"',
        ["'"] = "'",
        ["`"] = "`",
      },
    },
    close_open = {
      enable = true,
      match_pairs = {
        [")"] = "(",
        ["]"] = "[",
        ["}"] = "{",
        [">"] = "<",
        ['"'] = '"',
        ["'"] = "'",
        ["`"] = "`",
      },
    },
  },
}

M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.config), config or {})
end

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
  local line = vim.api.nvim_buf_get_lines(_bufnr, new_row, new_row + 1, false)[1] or ""
  local col = (direction == _right and 1) or #line
  return line, new_row, col
end

local function eat_empty_lines(row, col, direction)
  local buf_rows = vim.api.nvim_buf_line_count(0)
  local line = vim.api.nvim_buf_get_lines(_bufnr, row, row + 1, false)[1] or ""
  local new_row, new_col = row, col + direction

  -- Empty buffer
  if buf_rows == 1 and #line == 0 then
    return 0, 1
  end

  -- Out of bounds
  if (row < 0 and new_col < 0) or (row + 1 >= buf_rows and new_col > #line) then
    return row, col
  end

  -- Change line if in BOL/EOL
  if col <= 0 or col > #line then
    line, new_row, new_col = get_row_and_line(row, direction)
  end

  local char = line:sub(new_col, new_col)
  while char:match("%s") or char == "" do
    -- Out of bounds
    if new_row < 0 or new_row + 1 > buf_rows then
      break
    end

    -- Change line if line is empty or in BOL/EOL
    if line:match("^[%s]*$") or (new_col < 1 or new_col >= #line) then
      line, new_row, new_col = get_row_and_line(new_row, direction)
    end

    new_col = eat_whitespace(line, new_col, direction)
    char = line:sub(new_col, new_col)
  end

  -- `consume_spaces_and_lines` excceed 1 if the remaining lines are empty
  -- until the end of the buffer
  new_row = math.min(new_row, buf_rows - 1)
  return new_row, new_col
end

---Walk the line through the `direction` specified matching the char using the
---given pattern and returning the new column position.
---@param line string
---@param pattern string
---@param char string
---@param col integer
---@param direction integer
---@return integer
local function walk_line_matching_pattern(line, pattern, char, col, direction)
  local col_current = col
  local char_current = char

  while char_current:match(pattern) and col_current > 0 and col_current <= #line do
    col_current = col_current + direction
    char_current = line:sub(col_current, col_current)
  end

  return col_current
end

---Same as walk_line_matching_pattern but for `char` because if use the
---symbol `.` it matches as any char.
---@param line string
---@param pattern string
---@param char string
---@param col integer
---@param direction integer
---@return integer
local function walk_line_matching_char(line, pattern, char, col, direction)
  local col_current = col
  local char_current = char

  while char_current == pattern and col_current > 0 and col_current <= #line do
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

  -- Found at least 2 matching pattern
  if col_end - col_start > 1 then
    vim.api.nvim_buf_set_text(_bufnr, row, col_start, row, col_end, {})
    return true
  end

  return false
end

---Peek the next punctuation across lines, returninig the char and position.
---@param row integer
---@param col integer
---@param direction integer
---@return string
---@return integer
---@return integer
local function peek_next_symbol(row, col, direction)
  local line = vim.api.nvim_buf_get_lines(_bufnr, row, row + 1, false)[1] or ""
  local peek_row = row
  local peek_col = col + direction

  if col > #line then
    peek_col = col
  end

  local peek_char = line:sub(peek_col, peek_col)
  if peek_char:match("%s") or peek_col < 1 or peek_col > #line then
    peek_row, peek_col = eat_empty_lines(peek_row, peek_col, direction)
    line = vim.api.nvim_buf_get_lines(_bufnr, peek_row, peek_row + 1, false)[1] or ""
    peek_char = line:sub(peek_col, peek_col)
  end

  return peek_char, peek_row, peek_col
end

local function find_match_pair(expected_symbol, row, col, direction)
  local row_start, col_start = row, col
  local row_end, col_end = row, col

  local peek_char, peek_row, peek_col = peek_next_symbol(row_start, col_start, direction)
  local found = peek_char == expected_symbol
  if found then
    if direction == _right then
      row_end = peek_row
      col_end = peek_col
    elseif direction == _left then
      row_start = peek_row
      col_start = peek_col
    end
  end

  return found, row_start, col_start, row_end, col_end
end

local function delete_symbol_or_match_pair(match_pairs, char, row, col, direction)
  if string.match(char, "%p") then
    local row_start, col_start = row, col
    local row_end, col_end = row, col

    if match_pairs[char] then
      _, row_start, col_start, row_end, col_end = find_match_pair(match_pairs[char], row, col, -direction)
    elseif M.config.delete_repeated_punctuation.enable then
      local line = vim.api.nvim_get_current_line()
      local col_current = walk_line_matching_char(line, char, char, col, direction)

      if direction == _right then
        col_end = col_current - 1
      elseif direction == _left then
        col_start = col_current + 1
      end
    end

    vim.api.nvim_buf_set_text(_bufnr, row_start, col_start - 1, row_end, col_end, {})
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

  vim.api.nvim_buf_set_text(_bufnr, row_start, col_start, row_end, col_end, {})
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

  vim.api.nvim_buf_set_text(_bufnr, row, col_start, row, col_end, {})
end

local function delete_word(row, col, direction)
  local line = vim.api.nvim_get_current_line()

  local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)

  if col == 0 or col > #line then
    if M.config.delete_empty_lines_until_next_char.enable then
      vim.api.nvim_feedkeys(mark, "i", false)
      consume_spaces_and_lines(row, col, direction)
    else
      if direction == _right then
        local delete = vim.api.nvim_replace_termcodes(utils.keys.del, true, false, true)
        vim.api.nvim_feedkeys(delete, "i", false)
      elseif direction == _left then
        local backspace = vim.api.nvim_replace_termcodes(utils.keys.bs, true, false, true)
        vim.api.nvim_feedkeys(backspace, "i", false)
      end
    end
    return
  end

  vim.api.nvim_feedkeys(mark, "i", false)

  local char = line:sub(col, col)

  if char:match("%s") then
    consume_spaces(line, row, col, direction)
    return
  end

  if delete_from_pattern(line, "%d", char, row, col, direction) then
    return
  end

  if delete_from_pattern(line, "%u", char, row, col, direction) then
    return
  end

  local match_pairs = {}
  if direction == _right then
    match_pairs = (M.config.delete_pairs.close_open.enable and M.config.delete_pairs.close_open.match_pairs) or {}
  elseif direction == _left then
    match_pairs = (M.config.delete_pairs.open_close.enable and M.config.delete_pairs.open_close.match_pairs) or {}
  end

  if delete_symbol_or_match_pair(match_pairs, char, row, col, direction) then
    return
  end

  local row_start, col_start = row, col
  local row_end, col_end = row, col
  local col_peek = col + direction

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

  vim.api.nvim_buf_set_text(_bufnr, row_start, col_start, row_end, col_end, {})
end

local function delete(row, col, direction)
  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col, col)

  local row_start, col_start = row, col
  local row_end, col_end = row, col

  if char:match("%p") and (M.config.delete_pairs.close_open.enable or M.config.delete_pairs.open_close.enable) then
    local match_pairs = {}
    if direction == _right then
      match_pairs = (M.config.delete_pairs.close_open.enable and M.config.delete_pairs.close_open.match_pairs) or {}
    elseif direction == _left then
      match_pairs = (M.config.delete_pairs.open_close.enable and M.config.delete_pairs.open_close.match_pairs) or {}
    end

    if match_pairs[char] then
      local found = false
      found, row_start, col_start, row_end, col_end = find_match_pair(match_pairs[char], row, col, -direction)
      if found then
        local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)
        vim.api.nvim_feedkeys(mark, "i", false)

        vim.api.nvim_buf_set_text(_bufnr, row_start, col_start - 1, row_end, col_end, {})
        return
      end
    end
  end

  --- It's necessary to recreate the <bs>/<del> behavior
  --- because it's not possible to map this function to <bs>/<del>
  --- and call `nvim_feedkeys` as a fallback without an infinite loop.
  local buf_rows = vim.api.nvim_buf_line_count(0)

  if buf_rows == 1 and #line == 0 then
    return
  end

  if direction == _right then
    col_start = col - 1
    if col > #line and row + 1 < buf_rows then
      row_end = row + 1
      col_end = 0
    end
  elseif direction == _left then
    if col > 0 then
      col_start = col - 1
    elseif row > 0 then
      row_start = row - 1
      line = vim.api.nvim_buf_get_lines(_bufnr, row_start, row_start + 1, true)[1]
      col_start = #line
    end
  end

  vim.api.nvim_buf_set_text(_bufnr, row_start, col_start, row_end, col_end, {})
end

M.delete_previous_word = function()
  local col = vim.fn.col(".") - 1
  local row = vim.fn.line(".") - 1

  delete_word(row, col, _left)
end

M.delete_next_word = function()
  local col = vim.fn.col(".")
  local row = vim.fn.line(".") - 1

  delete_word(row, col, _right)
end

M.delete_previous = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete(row - 1, col, _left)
end

M.delete_next = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete(row - 1, col + 1, _right)
end

vim.keymap.set("i", utils.keys.bs, M.delete_previous)
vim.keymap.set("i", utils.keys.del, M.delete_next)

return M
