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

local store = {
  pairs = {},
  ft_pairs = {},
  patterns = {},
  ft_patterns = {},
  filetypes = {},
}

M.config = {
  delete_empty_lines_until_next_char = true,
  delete_repeated_punctuation = true,
  passthrough_numbers = false,
  passthrough_uppercase = false,
  join_line = {
    separator = " ",
    times = 1,
  },
  -- pairs = {},
  -- patterns = {},
  -- ignore = {},
  -- filetypes = {
  --   ["lua"] = {
  --     ignore = { "'", "%d%d::%d%d::%d%d", "<%%=" },
  --     pairs = {},
  --     patterns = {},
  --     treesitter = {
  --       enable = true,
  --       captures = {
  --         {
  --           capture = "",
  --           retrict_to_whitespaces = false,
  --           query = [[]],
  --           -- will receive the captured node with informations and current (row|col)_pos.
  --           -- should return a boolean a output string in an array and a range for deletion.
  --           callback = function(node_info, row_pos, col_pos)
  --             return false, {}, {}
  --           end,
  --         },
  --       },
  --     },
  --   },
  -- },
}

M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.config), config or {})
end

local function get_or_create_filetype(filetype)
  local ft = store.filetypes[filetype]

  if not ft then
    ft = {
      index = #store.filetypes + 1,
      pairs = {},
      patterns = {},
    }
    table.insert(store.filetypes, ft)
  end

  return ft
end

local function insert_into(store_global, store_ft, elem, opts)
  opts.filetypes = opts.filetypes or nil
  opts.not_filetypes = opts.not_filetypes or nil

  if opts.filetypes then
    local store_ft_index = #store_ft + 1
    for _, filetype in ipairs(opts.filetypes) do
      local ft = get_or_create_filetype(filetype)
      local ft_list = (opts.type == 1 and ft.pairs) or ft.patterns
      table.insert(ft_list, store_ft_index)
    end
    table.insert(store_ft, elem)
    return
  end

  if opts.not_filetypes then
    for _, filetype in ipairs(opts.filetypes) do
      local ft = get_or_create_filetype(filetype)
      elem.not_filetypes[ft.index] = true
    end
  end
  table.insert(store_global, elem)
end

M.insert_pair = function(config, opts)
  if not config or not config.first and (not config.second or config.format) then
    return
  end
  opts = opts or {}
  opts.type = 1

  local pair = vim.tbl_extend("force", {
    first = "",
    second = nil,
    format = nil,
    filetypes = {},
    not_filetypes = {},
  }, config)

  insert_into(store.pairs, store.ft_pairs, pair, opts)
end

M.insert_pattern = function(config, opts)
  if not config or not config.pattern then
    return
  end

  opts = opts or {}
  opts.type = 2

  local pattern = vim.tbl_deep_extend("force", {
    pattern = "",
    prefix = nil,
    suffix = nil,
    before = nil,
    after = nil,
    rule_before = nil,
    rule_after = nil,
    filetypes = {},
    not_filetypes = {},
    capture = {
      format = nil,
      order = nil,
    },
  }, config)

  insert_into(store.patterns, store.ft_patterns, pattern, opts)
end

local function in_ignore_list(item, filetype)
  return item.not_filetypes and item.not_filetypes[filetype]
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

local function get_line_and_pos(row, direction)
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
    return row, col
  end

  -- Out of bounds
  if (row < 0 and new_col < 0) or (row + 1 >= buf_rows and new_col > #line) then
    return row, col
  end

  -- Change line if in BOL/EOL
  if col <= 0 or col > #line then
    line, new_row, new_col = get_line_and_pos(row, direction)
  end

  local char = line:sub(new_col, new_col)
  while char:match("%s") or char == "" do
    -- Out of bounds
    if new_row < 0 or new_row + 1 > buf_rows then
      break
    end

    -- Change line if line is empty or in BOL/EOL
    if line:match("^[%s]*$") or (new_col < 1 or new_col >= #line) then
      line, new_row, new_col = get_line_and_pos(new_row, direction)
    end

    new_col = eat_whitespace(line, new_col, direction)
    char = line:sub(new_col, new_col)
  end

  -- `consume_spaces_and_lines` excceed 1 if the remaining lines are empty
  -- or -1 if the all previous lines are empty.
  new_row = math.min(buf_rows - 1, math.max(new_row, 0))
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

  while (char_current == pattern or char_current:match(pattern)) and col_current > 0 and col_current <= #line do
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

  -- Found at least 2 matching pattern.
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
local function peek_non_whitespace(row, col, direction)
  local line = vim.api.nvim_buf_get_lines(utils.bufnr, row, row + 1, false)[1] or ""
  local row_pos = row
  local col_pos = col + direction

  if col > #line then
    col_pos = col
  end

  local char = line:sub(col_pos, col_pos)
  if char:match("%s") or col_pos < 1 or col_pos > #line then
    row_pos, col_pos = eat_empty_lines(row_pos, col_pos, direction)
    line = vim.api.nvim_buf_get_lines(utils.bufnr, row_pos, row_pos + 1, false)[1] or ""
    char = line:sub(col_pos, col_pos)
  end

  return line, char, row_pos, col_pos
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

  local _, char, row_pos, col_pos = peek_non_whitespace(row_start, col_start, direction)
  local found = char == expected_symbol
  if found then
    if direction == utils.direction.right then
      row_end = row_pos
      col_end = col_pos
    elseif direction == utils.direction.left then
      row_start = row_pos
      col_start = col_pos
    end
  end

  return found, row_start, col_start, row_end, col_end
end

---Delete one or more punctuation.
---Can delete matching pairs or repeated punctuation.
---check: `delete_repeated_punctuation`.
---@param line string
---@param char string
---@param row integer
---@param col integer
---@param direction integer
---@return boolean
local function delete_symbol(line, char, row, col, direction)
  if char:match("%p") then
    local row_start, col_start = row, col
    local row_end, col_end = row, col
    -- check: receive line

    if M.config.delete_repeated_punctuation then
      -- Delete repeated punctuation.
      -- Example: `...|` -> `|` or `=========|` -> `|`
      --
      -- Note: it can be turned off.
      local col_current = walk_line_matching_pattern(line, char, char, col, direction)

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
local function consume_spaces_and_lines(row, col, direction)
  local row_start, col_start = row, col
  local row_end, col_end = row, col

  local row_pos, col_pos = eat_empty_lines(row_start, col_start, direction)

  if direction == utils.direction.right then
    row_end = row_pos
    col_start = col_start - 1
    col_end = (col_pos == 0 and 1) or col_pos - 1
  elseif direction == utils.direction.left then
    row_start = row_pos
    col_start = col_pos
  end

  vim.api.nvim_buf_set_text(
    utils.bufnr,
    row_start,
    col_start,
    row_end,
    col_end,
    { string.rep(M.config.join_line.separator, M.config.join_line.times) }
  )
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
    -- its col_(start|end) - 1 because the start is inclusive
    -- and the end is the non whitespace char.
    col_start = col_start - 1
    col_end = col_current - 1
  elseif direction == utils.direction.left then
    col_start = col_current
  end

  vim.api.nvim_buf_set_text(utils.bufnr, row, col_start, row, col_end, {})
end

---Join line consuming spaces, tabs, and lines using a separator.
---@param row integer
local function join_line(row)
  local line = vim.api.nvim_get_current_line()
  consume_spaces_and_lines(row, #line + 1, utils.direction.right)
end

---Finds if the pattern exists in the given line.
---@param item table
---@param line string
---@param col integer
---@param direction integer
---@return boolean
---@return integer
---@return integer
local function find_pattern_line(item, line, col, direction, opts)
  local col_start, col_end = col, col

  local pattern = (item.prefix or "") .. "(" .. item.pattern .. ")" .. (item.suffix or "")

  -- Adds wildcards in the pattern and aditional rules.
  -- Right: "^(pattern)item.after|[item.rule_after|.*]"
  -- Left: "[.*|item.rule_before]|item.before(pattern)$"
  --
  -- Note: The outer most capture group it's used to get the
  -- length of the string generated by the pattern and it does not
  -- counts the `item.rule_(before|after)` and `item.(before|after)`.
  if direction == utils.direction.right then
    pattern = "^" .. pattern .. (item.after or "") .. (item.rule_after or ".*")
    col_end = #line
  elseif direction == utils.direction.left then
    pattern = (item.rule_before or ".*") .. (item.before or "") .. pattern .. "$"
    col_start = 1
  end

  -- Try to match the pattern first and if not exists in the slice early
  -- return else extract the values from the match if it's a regex.
  local slice = line:sub(col_start, col_end)
  local match = slice:match(pattern)

  if match then
    -- Can safelly sub/add the length because the line
    -- has the given pattern.
    local length = #match + (item.prefix and #item.prefix or 0) + (item.suffix and #item.suffix or 0)
    if direction == utils.direction.right then
      col_start = col - 1
      col_end = col + length - 1
    elseif direction == utils.direction.left then
      col_start = col - length
    end
  end

  return match, col_start, col_end
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
  local found, col_start, col_end = find_pattern_line(item, line, col, direction, {})

  if found then
    vim.api.nvim_buf_set_text(utils.bufnr, row, col_start, row, col_end, { item.replace })
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
local function delete_pairs(item, line, row, col, direction)
  local found_lhs, col_lhs_start, col_lhs_end = find_pattern_line(item.lhs, line, col, direction, {})

  if found_lhs then
    local peeked_line, _, row_pos, col_pos = peek_non_whitespace(row, col, -direction)
    local found_rhs, col_rhs_start, col_rhs_end = find_pattern_line(item.rhs, peeked_line, col_pos, -direction)

    if found_rhs then
      local row_start, col_start = row, col
      local row_end, col_end = row, col

      if direction == utils.direction.right then
        row_start = row_pos
        col_start = col_rhs_start
        col_end = col_lhs_end
      elseif direction == utils.direction.left then
        col_start = col_lhs_start
        row_end = row_pos
        col_end = col_rhs_end
      end

      vim.api.nvim_buf_set_text(utils.bufnr, row_start, col_start, row_end, col_end, { item.replace })
    end

    return found_lhs and found_rhs
  end

  return found_lhs
end

---
---@param item table
---@param row integer
---@param col integer
---@param direction integer
---@return boolean
local function delete_capture(item, row, col, direction)
  local node = vim.treesitter.get_node({ pos = { row, col } })
  local captures = vim.treesitter.get_captures_at_pos(0, row, col)
  if node then
    vim.print(node:type(), vim.treesitter.get_node_text(node, vim.api.nvim_get_current_buf()))
    vim.print("id: ", node:id())
    vim.print("range: ", node:range())
    vim.print("child_count: ", node:child_count())
    vim.print("named_children: ", node:named_children())
  end

  -- print(vim.inspect(node))
  -- print(vim.inspect(captures))

  return false
  -- return true -- DEV DELETE IT
end

---Delete word or punctuation following the specified `direction`.
---@param row integer
---@param col integer
---@param direction integer
local function delete_word(row, col, direction)
  local line = vim.api.nvim_get_current_line()

  local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)

  -- Check if BOL/EOF.
  if col == 0 or col > #line then
    if M.config.delete_empty_lines_until_next_char then
      -- Consume spaces and lines til the next non whitespace char
      -- or begin of the buffer or EOF.
      vim.api.nvim_feedkeys(mark, "i", false)
      consume_spaces_and_lines(row, col, direction)
    else
      -- If `delete_empty_lines_until_next_char` is disabled
      -- it fallback to <bs>/<del>.
      --
      -- Note: if that keys are set in the keymap it will fallback to them
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

  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local config_filetype = store.filetypes[filetype]

  -- First look if there are any config related with the filetype
  -- if nothing matches fallback to global config.
  if config_filetype then
    -- for _, item in ipairs(config_filetype.treesitter.captures) do
    --   if delete_capture(item, row, col, direction) then
    --     return
    --   end
    -- end

    for _, index in ipairs(config_filetype.pairs) do
      local item = store.ft_pairs[index]
      if delete_pairs(item, line, row, col, direction) then
        return
      end
    end

    for _, index in ipairs(config_filetype.patterns) do
      local item = store.ft_pairs[index]
      if delete_pattern(item, line, row, col, direction) then
        return
      end
    end
  end

  for _, item in ipairs(store.pairs) do
    if not in_ignore_list(item, filetype) then
      if delete_pairs(item, line, row, col, direction) then
        return
      end
    end
  end

  for _, item in ipairs(store.patterns) do
    if not in_ignore_list(item, filetype) then
      if delete_pattern(item, line, row, col, direction) then
        return
      end
    end
  end

  if delete_symbol(line, char, row, col, direction) then
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
local function delete(row, col, direction)
  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col, col)

  local row_start, col_start = row, col
  local row_end, col_end = row, col

  if char:match("%p") then
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    local config_filetype = M.config.filetypes[filetype]
    local filetype_match, config_match = get_match_pairs(config_filetype, direction)

    if not in_ignore_list(filetype, char) then
      local found = false
      -- Looks first if there some rule in filetype config and if not found
      -- fallback to the global config.
      if filetype_match[char] then
        found, row_start, col_start, row_end, col_end = find_match_pair(filetype_match[char], row, col, -direction)
      end
      if not found and config_match[char] then
        found, row_start, col_start, row_end, col_end = find_match_pair(config_match[char], row, col, -direction)
      end
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

M.previous_word = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete_word(row - 1, col, utils.direction.left)
end

M.next_word = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete_word(row - 1, col + 1, utils.direction.right)
end

M.previous = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete(row - 1, col, utils.direction.left)
end

M.next = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  delete(row - 1, col + 1, utils.direction.right)
end

M.join = function()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  join_line(row - 1)
end

return M
