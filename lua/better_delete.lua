local M = {}

local utils = {
  bufnr = 0,
  keys = {
    bs = "<bs>",
    del = "<del>",
  },
  direction = {
    left = -1,
    right = 1,
  },
}

M.config = {
  delete_empty_lines_until_next_char = {
    enable = true,
  },
  delete_repeated_punctuation = {
    enable = true,
  },
  passthrough_numbers = false,
  passthrough_uppercase = false,
  join_line = {
    separator = " ",
    times = 1,
  },
  delete_pattern = {
    enable = true,
    list = {
      {
        -- 13::26::45
        pattern = "%d%d::%d%d::%d%d",
        replace = "",
      },
      {
        pattern = "%x%x%x%x%x%x",
        replace = "0x",
      },
    },
  },
  delete_pattern_pairs = {
    enable = true,
    list = {
      {
        lhs = { pattern = "<%=" },
        rhs = { pattern = "%>" },
        replace = "",
        surround_check = nil,
        -- surround_check = "%w",
      },
      {
        lhs = { pattern = "#STRING" },
        rhs = { pattern = "#END" },
        replace = "",
        surround_check = nil,
        -- surround_check = "%w",
      },
      {
        lhs = { pattern = "xxx" },
        rhs = { pattern = "yyy" },
        replace = "",
        surround_check = nil,
        -- surround_check = "%w",
      },
      {
        lhs = { pattern = "yyy" },
        rhs = { pattern = "xxx" },
        replace = "",
        -- surround_check = "%w",
      },
    },
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
      match_pairs_custom = {},
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
      match_pairs_custom = {},
    },
  },
}

local function concat_tables(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.config), config or {})
  if M.config.delete_pairs.open_close.enable then
    M.config.delete_pairs.open_close.match_pairs =
      concat_tables(M.config.delete_pairs.open_close.match_pairs, M.config.delete_pairs.open_close.match_pairs_custom)
  end
  if M.config.delete_pairs.close_open.enable then
    M.config.delete_pairs.close_open.match_pairs =
      concat_tables(M.config.delete_pairs.close_open.match_pairs, M.config.delete_pairs.close_open.match_pairs_custom)
  end
end

local function get_match_pairs(opts, direction)
  local match_pairs = {}
  if direction == utils.direction.right then
    if M.config.delete_pairs.close_open.enable then
      match_pairs = concat_tables(M.config.delete_pairs.close_open.match_pairs, opts.close_open)
    end
  elseif direction == utils.direction.left then
    if M.config.delete_pairs.open_close.enable then
      match_pairs = concat_tables(M.config.delete_pairs.open_close.match_pairs, opts.open_close)
    end
  end

  return match_pairs
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
  local line = vim.api.nvim_buf_get_lines(utils.bufnr, new_row, new_row + 1, false)[1] or ""
  local col = (direction == utils.direction.right and 1) or #line
  return line, new_row, col
end

local function eat_empty_lines(row, col, direction)
  local buf_rows = vim.api.nvim_buf_line_count(0)
  local line = vim.api.nvim_buf_get_lines(utils.bufnr, row, row + 1, false)[1] or ""
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
---@param direction integer
---@return boolean
local function delete_from_pattern(line, pattern, char, row, col, direction)
  local col_start, col_end = col, col
  local col_current = walk_line_matching_pattern(line, pattern, char, col, direction)

  if direction == utils.direction.right then
    col_start = col_start - 1
    col_end = col_current - 1
  elseif direction == utils.direction.left then
    col_start = col_current
  end

  -- Found at least 2 matching pattern
  if col_end - col_start > 1 then
    vim.api.nvim_buf_set_text(utils.bufnr, row, col_start, row, col_end, {})
    return true
  end

  return false
end

---Peek the next symbol across lines running by a specified direction,
---returninig the char and position.
---@param row integer
---@param col integer
---@param direction integer
---@return string
---@return string
---@return integer
---@return integer
local function peek_next_symbol(row, col, direction)
  local line = vim.api.nvim_buf_get_lines(utils.bufnr, row, row + 1, false)[1] or ""
  local peek_row = row
  local peek_col = col + direction

  if col > #line then
    peek_col = col
  end

  local peek_char = line:sub(peek_col, peek_col)
  if peek_char:match("%s") or peek_col < 1 or peek_col > #line then
    peek_row, peek_col = eat_empty_lines(peek_row, peek_col, direction)
    line = vim.api.nvim_buf_get_lines(utils.bufnr, peek_row, peek_row + 1, false)[1] or ""
    peek_char = line:sub(peek_col, peek_col)
  end

  return line, peek_char, peek_row, peek_col
end

---Peek the next char following the given `direction` returning if the `peeked char` and
---the `expected_symbol` matches.
---@param expected_symbol string
---@param row integer
---@param col integer
---@param direction integer
---@return true|false
---@return integer
---@return integer
---@return integer
---@return integer
local function find_match_pair(expected_symbol, row, col, direction)
  local row_start, col_start = row, col
  local row_end, col_end = row, col

  local _, peek_char, peek_row, peek_col = peek_next_symbol(row_start, col_start, direction)
  local found = peek_char == expected_symbol
  if found then
    if direction == utils.direction.right then
      row_end = peek_row
      col_end = peek_col
    elseif direction == utils.direction.left then
      row_start = peek_row
      col_start = peek_col
    end
  end

  return found, row_start, col_start, row_end, col_end
end

---Delete one or more punctuation.
---Can delete matching pairs or repeated punctuation.
---check: `delete_repeated_punctuation`.
---@param match_pairs table
---@param char string
---@param row integer
---@param col integer
---@param direction integer
---@return boolean
local function delete_symbol_or_match_pair(match_pairs, char, row, col, direction)
  if char:match("%p") then
    local row_start, col_start = row, col
    local row_end, col_end = row, col

    if match_pairs[char] then
      _, row_start, col_start, row_end, col_end = find_match_pair(match_pairs[char], row, col, -direction)
    elseif M.config.delete_repeated_punctuation.enable then
      local line = vim.api.nvim_get_current_line()
      local col_current = walk_line_matching_char(line, char, char, col, direction)

      if direction == utils.direction.right then
        col_end = col_current - 1
      elseif direction == utils.direction.left then
        col_start = col_current + 1
      end
    end

    vim.api.nvim_buf_set_text(utils.bufnr, row_start, col_start - 1, row_end, col_end, {})
    return true
  end
  return false
end

---Consume spaces, tabs, and lines.
---@param row integer
---@param col integer
---@param direction integer
---@param opts table
local function consume_spaces_and_lines(row, col, direction, opts)
  opts = opts or {}
  opts.separator = opts.separator or ""

  local row_start, col_start = row, col
  local row_end, col_end = row, col

  if direction == utils.direction.right then
    row_end, col_end = eat_empty_lines(row_start, col_start, direction)
    col_start = col_start - 1
    col_end = (col_end == 0 and 1) or col_end - 1
  elseif direction == utils.direction.left then
    row_start, col_start = eat_empty_lines(row_end, col_end, direction)
  end

  vim.api.nvim_buf_set_text(utils.bufnr, row_start, col_start, row_end, col_end, { opts.separator })
end

---Consume spaces and tabs in the same line.
---@param line string
---@param row integer
---@param col integer
---@param direction integer
local function consume_spaces(line, row, col, direction)
  local col_start, col_end = col, col
  local col_current = eat_whitespace(line, col_start, direction)

  if direction == utils.direction.right then
    col_start = col_start - 1
    col_end = col_current - 1
  elseif direction == utils.direction.left then
    col_start = col_current
  end

  vim.api.nvim_buf_set_text(utils.bufnr, row, col_start, row, col_end, {})
end

---Join line consuming spaces, tabs, and lines using a separator.
---@param row integer
---@param opts table
local function join_next_line(row, opts)
  opts = opts or {}
  opts.join_line = opts.join_line or M.config.join_line

  local line = vim.api.nvim_get_current_line()
  consume_spaces_and_lines(
    row,
    #line + 1,
    utils.direction.right,
    { separator = string.rep(opts.join_line.separator, opts.join_line.times) }
  )
end

---Finds if the pattern exists in the given line.
---@param item table
---@param line string
---@param col integer
---@param direction integer
---@return boolean
---@return table
---@return integer
---@return integer
local function find_pattern_line(item, line, col, direction)
  item.inject_matches = item.inject_matches or nil
  local col_start, col_end = col, col

  local pattern = item.pattern

  if item.inject_matches then
    pattern = string.format(pattern, table.unpack(item.inject_matches))
  end

  if direction == utils.direction.right then
    pattern = "^" .. pattern .. (item.surround_check or "")
    col_end = #line
  elseif direction == utils.direction.left then
    pattern = (item.surround_check or "") .. pattern .. "$"
    col_start = 1
  end

  local slice = line:sub(col_start, col_end)
  local match = slice:match(pattern)

  if match then
    local length = #match
    local result_matches = {}

    if item.save_matches then
      for result_match in string.gsub(slice, pattern, item.save_matches) do
        table.insert(result_matches, result_match)
      end
    end

    if direction == utils.direction.right then
      col_start = col - 1
      col_end = col + length - 1
    elseif direction == utils.direction.left then
      col_start = col - length
    end

    return true, result_matches, col_start, col_end
  end

  return false, {}, 0, 0
end

---Delete string slice from a given pattern. Matches regex and literal string.
---NOTE: For the regex the length must be provided to match correctly.
---@param item table
---@param line string
---@param row integer
---@param col integer
---@param direction integer
---@return boolean
local function delete_pattern(item, line, row, col, direction)
  local found, _, col_start, col_end = find_pattern_line(item, line, col, direction)

  if found then
    local replace = item.replace or ""
    vim.api.nvim_buf_set_text(utils.bufnr, row, col_start, row, col_end, { replace })
  end

  return found
end

---Delete pairs from a given pattern. Matches regex and literal string.
---Multiple lines.
---NOTE: For the regex the length must be provided to match correctly.
---@param item table
---@param line string
---@param row integer
---@param col integer
---@param direction integer
---@return boolean
local function delete_pattern_pairs(item, line, row, col, direction)
  local found_lhs, result_matches, col_lhs_start, col_lhs_end = find_pattern_line(item.lhs, line, col, direction)

  if found_lhs then
    if item.lhs.save_matches then
      item.rhs.inject_matches = result_matches
    end

    local peek_line, _, peek_row, peek_col = peek_next_symbol(row, col, -direction)
    local found_rhs, _, col_rhs_start, col_rhs_end = find_pattern_line(item.rhs, peek_line, peek_col, -direction)

    if found_rhs then
      local row_start, col_start = row, col
      local row_end, col_end = row, col

      if direction == utils.direction.right then
        row_start = peek_row
        col_start = col_rhs_start
        col_end = col_lhs_end
      elseif direction == utils.direction.left then
        col_start = col_lhs_start
        row_end = peek_row
        col_end = col_rhs_end
      end

      local replace = item.replace or ""
      vim.api.nvim_buf_set_text(utils.bufnr, row_start, col_start, row_end, col_end, { replace })
    end

    return found_lhs and found_rhs
  end

  return found_lhs
end

---Delete word or punctuation following the specified `direction`.
---@param row integer
---@param col integer
---@param direction integer
---@param opts table
local function delete_word(row, col, direction, opts)
  opts = opts or {}
  opts.open_close = opts.open_close or {}
  opts.close_open = opts.close_open or {}
  local line = vim.api.nvim_get_current_line()

  local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)

  if col == 0 or col > #line then
    if M.config.delete_empty_lines_until_next_char.enable then
      vim.api.nvim_feedkeys(mark, "i", false)
      consume_spaces_and_lines(row, col, direction, {})
    else
      if direction == utils.direction.right then
        local delete = vim.api.nvim_replace_termcodes(utils.keys.del, true, false, true)
        vim.api.nvim_feedkeys(delete, "i", false)
      elseif direction == utils.direction.left then
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

  if M.config.delete_pattern_pairs.enable then
    for _, item in ipairs(M.config.delete_pattern_pairs.list) do
      if delete_pattern_pairs(item, line, row, col, direction) then
        return
      end
    end
  end

  -- This should be executed after `delete_pattern_pairs` because it's
  -- a fallback if the same pattern appear in both tables.
  -- The reason is if this run first the expected behavior will not work
  -- because the `lhs pattern` from pair will be deleted.
  if M.config.delete_pattern.enable then
    for _, item in ipairs(M.config.delete_pattern.list) do
      if delete_pattern(item, line, row, col, direction) then
        return
      end
    end
  end

  local match_pairs = get_match_pairs(opts, direction)
  if delete_symbol_or_match_pair(match_pairs, char, row, col, direction) then
    return
  end

  local row_start, col_start = row, col
  local row_end, col_end = row, col
  local col_peek = col + direction

  -- Digits
  if M.config.passthrough_numbers then
    col_peek = walk_line_matching_pattern(line, "%d", char, col, direction)
  elseif delete_from_pattern(line, "%d", char, row, col, direction) then
    return
  end

  -- Uppercase
  if M.config.passthrough_uppercase then
    col_peek = walk_line_matching_pattern(line, "%u", char, col, direction)
  elseif delete_from_pattern(line, "%u", char, row, col, direction) then
    return
  end

  -- Limited to the current row
  -- stops if reachs BOL/EOL
  while col_peek > 0 and col_peek <= #line do
    char = line:sub(col_peek, col_peek)

    -- Stops if find space or tab
    if char:match("%s") then
      break
    end

    -- Stops if find punctuation or digit
    if char:match("[%p%d]") and col_peek ~= col then
      break
    end

    -- Stops if find uppercase
    -- if the direction is `utils.direction.left` it consumes the char
    if char:match("[%u]") and col_peek ~= col then
      if direction == utils.direction.left then
        col_peek = col_peek - 1
      end
      break
    end

    col_peek = col_peek + direction
  end

  if direction == utils.direction.right then
    col_start = col_start - 1
    col_end = col_peek - 1
  elseif direction == utils.direction.left then
    col_start = col_peek
  end

  vim.api.nvim_buf_set_text(utils.bufnr, row_start, col_start, row_end, col_end, {})
end

---Is <BS> and <DEL> but add the capability of deleting matching pairs.
---@param row integer
---@param col integer
---@param direction integer
---@param opts table
local function delete(row, col, direction, opts)
  opts = opts or {}
  opts.open_close = opts.open_close or {}
  opts.close_open = opts.close_open or {}

  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col, col)

  local row_start, col_start = row, col
  local row_end, col_end = row, col

  if char:match("%p") and (M.config.delete_pairs.close_open.enable or M.config.delete_pairs.open_close.enable) then
    local match_pairs = get_match_pairs(opts, direction)

    if match_pairs[char] then
      local found = false
      found, row_start, col_start, row_end, col_end = find_match_pair(match_pairs[char], row, col, -direction)
      if found then
        local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)
        vim.api.nvim_feedkeys(mark, "i", false)

        vim.api.nvim_buf_set_text(utils.bufnr, row_start, col_start - 1, row_end, col_end, {})
        return
      end
    end
  end

  --- It's necessary to recreate the <bs>/<del> behavior
  --- because it's not possible to map this function to <bs>/<del>
  --- and call `nvim_feedkeys` as a fallback without an infinite loop.
  --- Other solutions like couting the empty spaces/tabs/lines not worked
  --- because of `nvim_srtwidth` was count the tabs as spaces `tabwidth`
  --- generating way more <bs>/<del> than required deleting more than
  --- expected.
  local buf_rows = vim.api.nvim_buf_line_count(0)

  -- Empty buffer
  if buf_rows == 1 and #line == 0 then
    return
  end

  if direction == utils.direction.right then
    col_start = col - 1

    -- EOL and not at the last line
    if col > #line and row + 1 < buf_rows then
      row_end = row + 1
      col_end = 0
    end
  elseif direction == utils.direction.left then
    if col > 0 then
      col_start = col - 1
    -- In BOL and not at the fist line.
    -- ps.: the `col == 0` is redundant because it's an `elseif`.
    elseif row > 0 then
      row_start = row - 1
      line = vim.api.nvim_buf_get_lines(utils.bufnr, row_start, row_start + 1, true)[1]
      col_start = #line
    end
  end

  vim.api.nvim_buf_set_text(utils.bufnr, row_start, col_start, row_end, col_end, {})
end

M.previous_word = function(opts)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete_word(row - 1, col, utils.direction.left, opts)
end

M.next_word = function(opts)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete_word(row - 1, col + 1, utils.direction.right, opts)
end

M.previous = function(opts)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete(row - 1, col, utils.direction.left, opts)
end

M.next = function(opts)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete(row - 1, col + 1, utils.direction.right, opts)
end

M.join = function(opts)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  join_next_line(row - 1, opts)
end

return M
