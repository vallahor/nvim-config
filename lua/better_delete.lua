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
  filetypes = {
    ["lua"] = {
      enable = true,
      ignore = { "'", "%d%d::%d%d::%d%d", "<%%=" },
      delete_pairs = {
        open_close = {
          enable = true,
          match_pairs = {
            [">"] = "%",
            ["("] = ")",
          },
        },
        close_open = {},
      },
      delete_patterns = {
        enable = true,
        patterns = {},
      },
      delete_patterns_pairs = {
        enable = true,
        patterns = {},
      },
      treesitter = {
        enable = true,
        captures = {
          {
            capture = "",
            retrict_to_whitespaces = false,
            -- will receive the captured node with informations and current (row|col)_pos.
            -- should return a boolean.
            callback = function(node_info, row_pos, col_pos)
              return false
            end,
          },
        },
      },
    },
  },
  delete_pattern = {
    enable = true,
    patterns = {
      {
        -- 13::26::45
        pattern = "%d%d::%d%d::%d%d",
      },
      {
        pattern = "(%x%x)(%x%x)(%x%x)(%x%x)argb",
        order = { [4] = 1, [3] = 2, [2] = 3, [1] = 4 },
        format = "%s%s%s%s",
        capture_regex = true,
        -- before = "0[xb]",
        -- after = "[xb]0",
      },
      {
        pattern = "(%x%x)(%x%x)(%x%x)(%x%x)rgba",
        order = { [4] = 1, [3] = 2, [2] = 3, [1] = 4 },
        format = "%s%s%s%s",
        capture_regex = true,
        -- before = "0[xb]",
        -- after = "[xb]0",
      },
    },
  },
  delete_pattern_pairs = {
    enable = true,
    patterns = {
      {
        -- lhs = { pattern = ".*(<(%w+).*>)", save_matches = { ignore = { 1 } } },
        -- lhs = { pattern = ".*(<(%w+)>)", save_matches = { ignore = { 1 } } },
        lhs = {
          rule_before = "",
          before = "",
          pattern = "<(%w+) (%w+)>",
          order = { [2] = 1, [1] = 2 },
          capture_regex = true,
        },
        rhs = { rule_after = "", after = "", format = "</%s %s>" },
        surround_check = "%w",
      },
      {
        lhs = { pattern = "<%%=" },
        rhs = { pattern = "%%>" },
        replace = "",
        surround_check = "%w",
      },
      {
        rhs = { pattern = "<%%=" },
        lhs = { pattern = "%%>" },
        replace = "",
        surround_check = "%w",
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

local function in_ignore_list(filetype, item)
  item = item.pattern or (item.lhs and item.lhs.pattern) or item
  local found = false
  if M.config.filetypes[filetype] and M.config.filetypes[filetype].ignore then
    found = vim.tbl_contains(M.config.filetypes[filetype].ignore, item)
  end
  return found
end

local function get_match_pairs(config_filetype, direction)
  local config_match_pairs = {}
  local filetype_match_pairs = {}

  if direction == utils.direction.right then
    config_match_pairs = (M.config.delete_pairs.close_open.enable and M.config.delete_pairs.close_open.match_pairs)
      or {}

    if config_filetype then
      filetype_match_pairs = (
        config_filetype.delete_pairs.close_open.enable and config_filetype.delete_pairs.close_open.match_pairs
      ) or {}
    end
  elseif direction == utils.direction.left then
    config_match_pairs = (M.config.delete_pairs.open_close.enable and M.config.delete_pairs.open_close.match_pairs)
      or {}

    if config_filetype then
      filetype_match_pairs = (
        config_filetype.delete_pairs.open_close.enable and config_filetype.delete_pairs.open_close.match_pairs
      ) or {}
    end
  end

  return filetype_match_pairs, config_match_pairs
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
    return 0, 1
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

  -- `consume_spaces_and_lines` excceed 1 if the remaining lines are empty.
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
      -- Delete repeated punctuation.
      -- Example: `...|` -> `|` or `=========|` -> `|`
      --
      -- Note: it can be turned off.
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
---@return table
---@return integer
---@return integer
local function find_pattern_line(item, line, col, direction)
  local col_start, col_end = col, col

  if not item.pattern then
    return false, {}, -1, -1
  end

  local pattern = "(" .. item.pattern .. ")"

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

  local slice = line:sub(col_start, col_end)
  local match = ""
  local matches = {}

  if item.capture_regex then
    -- Save the matches to insert in the `rhs` format string.
    if item.order then
      -- If there are some capture ordering that need to be
      -- followed like `"%2 %1 %3"` it appears in
      -- `item.save_matches.order` as a table linking the
      -- expected number the specified position.
      -- eg. `"%2 %1 %3"` becomes
      -- `item.save_matches.order = { [2] = 1, [1] = 2, [3] = 3 }`
      --
      -- Note: it matches the `i - 1` because of the capture group
      -- inserted around the pattern, which is used to calculate
      -- the `length` after the match.
      local items_ordered = {}
      match = slice:gsub(pattern, function(...)
        local result_matches = { ... }
        for i = 2, #result_matches do
          local index = item.order[i - 1] or i
          items_ordered[index] = result_matches[i]
        end
        return result_matches[1]
      end)

      -- Flatten the `items_ordered` table into the
      -- actual captures from the regex.
      for _, matched in pairs(items_ordered) do
        table.insert(matches, matched)
      end
    else
      -- Directly insert the captures into `matches`.
      match = slice:gsub(pattern, function(...)
        local result_matches = { ... }
        for i = 2, #result_matches do
          table.insert(matches, result_matches[i])
        end
        return result_matches[1]
      end)
    end
  else
    match = slice:match(pattern)
  end

  if match then
    -- Can safelly sub/add the length because the line
    -- has the given pattern.
    local length = #match
    if direction == utils.direction.right then
      col_start = col - 1
      col_end = col + length - 1
    elseif direction == utils.direction.left then
      col_start = col - length
    end
    return true, matches, col_start, col_end
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
  local found, matches, col_start, col_end = find_pattern_line(item, line, col, direction)

  if found then
    if item.format and #matches > 0 then
      item.replace = string.format(item.format, table.unpack(matches))
    end

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
  local found_lhs, matches, col_lhs_start, col_lhs_end = find_pattern_line(item.lhs, line, col, direction)

  if found_lhs then
    if item.rhs.format and #matches > 0 then
      -- Generate a pattern from `lhs` captures.
      -- This is necessary when the deleted pattern appears in the `rhs`
      -- with the same name or structure with variable sized patterns .
      --
      -- Example: <div>|</div>
      -- The pattern <(%w).*> captures %w which can be length.
      -- If we simply use </(%w)> in `rhs`, it could match the wrong string,
      -- e.g., <div>|</main>.
      --
      -- To fix this the captured %w in `lhs` id inject in
      -- the `rhs` pattern using </%s> which producing a string
      -- that corretly matches the first pattern.
      item.rhs.pattern = string.format(item.rhs.format, table.unpack(matches))
    end

    local peeked_line, _, row_pos, col_pos = peek_non_whitespace(row, col, -direction)
    local found_rhs, _, col_rhs_start, col_rhs_end = find_pattern_line(item.rhs, peeked_line, col_pos, -direction)

    if found_rhs then
      local row_start, col_start = row, col
      local row_end, col_end = row, col
      local surround_char = ""

      if direction == utils.direction.right then
        row_start = row_pos
        col_start = col_rhs_start
        col_end = col_lhs_end

        surround_char = peeked_line:sub(col_start, col_start)
      elseif direction == utils.direction.left then
        col_start = col_lhs_start
        row_end = row_pos
        col_end = col_rhs_end

        surround_char = peeked_line:sub(col_end + 1, col_end + 1)
      end

      -- Surround Check apply a char pattern matchs
      -- to garantee that not matching the wrong `rhs`.
      item.surround_check = item.surround_check or nil
      if item.surround_check and surround_char:match(item.surround_check) then
        return false
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
local function delete_word(row, col, direction)
  local line = vim.api.nvim_get_current_line()

  local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)

  -- Check if BOL/EOF.
  if col == 0 or col > #line then
    if M.config.delete_empty_lines_until_next_char.enable then
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
  local config_filetype = M.config.filetypes[filetype]
  local filetype_match, config_match = get_match_pairs(config_filetype, direction)

  -- First look if there are any config related with the filetype
  -- if nothing matches fallback to global config.
  if config_filetype and config_filetype.enable then
    if config_filetype.delete_pattern_pairs and config_filetype.delete_pattern_pairs.patterns then
      for _, item in ipairs(config_filetype.delete_pattern_pairs.patterns) do
        if delete_pattern_pairs(item, line, row, col, direction) then
          return
        end
      end
    end

    if config_filetype.delete_patterns and config_filetype.delete_patterns.patterns then
      for _, item in ipairs(config_filetype.delete_patterns.patterns) do
        if delete_pattern(item, line, row, col, direction) then
          return
        end
      end
    end

    if delete_symbol_or_match_pair(filetype_match, char, row, col, direction) then
      return
    end
  end

  if M.config.delete_pattern_pairs.enable then
    for _, item in ipairs(M.config.delete_pattern_pairs.patterns) do
      if not in_ignore_list(filetype, item) then
        if delete_pattern_pairs(item, line, row, col, direction) then
          return
        end
      end
    end
  end

  -- This should be executed after `delete_pattern_pairs` because it's
  -- a fallback if the same pattern appear in both tables.
  -- The reason is if this run first the expected behavior will not work
  -- because the `lhs pattern` from pair will be deleted.
  if M.config.delete_pattern.enable then
    for _, item in ipairs(M.config.delete_pattern.patterns) do
      if not in_ignore_list(filetype, item) then
        if delete_pattern(item, line, row, col, direction) then
          return
        end
      end
    end
  end

  if not in_ignore_list(filetype, char) then
    if config_filetype then
      if delete_symbol_or_match_pair(filetype_match, char, row, col, direction) then
        return
      end
    end
    if config_match then
      if delete_symbol_or_match_pair(config_match, char, row, col, direction) then
        return
      end
    end
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
