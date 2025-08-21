local M = {}

local utils = {
  bufnr = 0,
  keys = {
    bs = "<bs>",
    del = "<del>",
  },
  direction = {
    left = "left",
    right = "right",
  },
  opposite = {
    left = "right",
    right = "left",
  },
}

local store = {
  pairs = {
    ft = {},
    default = {},
  },
  rules = {
    ft = {},
    default = {},
  },
  patterns = {
    ft = {},
    default = {},
  },
  filetypes = {},
}

local store_index = {
  ["pairs.ft"] = store.pairs.ft,
  ["pairs.default"] = store.pairs.default,
  ["rules.ft"] = store.rules.ft,
  ["rules.default"] = store.rules.default,
  ["patterns.ft"] = store.patterns.ft,
  ["patterns.default"] = store.patterns.default,
}

M.config = {
  delete_empty_lines_until_next_char = true,
  -- repeated_allowed = nil,
  repeated_allowed = nil,
  passthrough_numbers = false,
  passthrough_uppercase = false,
  join_line = {
    separator = " ",
    times = 1,
  },
  default_pairs = {
    { left = "(", right = ")", not_filetypes = nil },
    { left = "{", right = "}", not_filetypes = nil },
    { left = "[", right = "]", not_filetypes = nil },
    { left = "'", right = "'", not_filetypes = nil },
    { left = '"', right = '"', not_filetypes = nil },
    { left = "`", right = "`", not_filetypes = nil },
    { left = "<", right = ">", not_filetypes = nil },
  },
  seek_spaces = {
    ["left"] = "[%s]*$",
    ["right"] = "^[%s]*",
  },
  seek_punctuations = {
    ["left"] = "[%p]*$",
    ["right"] = "^[%p]*",
  },
  seek_numbers = {
    ["left"] = "[%d]*$",
    ["right"] = "^[%d]*",
  },
  seek_uppercases = {
    ["left"] = "[%u]*$",
    ["right"] = "^[%u]*",
  },
  seek_lowercases = {
    ["left"] = "%u?[%l]*%d?$",
    ["right"] = "^[%l]*",
  },
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
}

M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.config), config or {})
  if M.config.default_pairs then
    for _, pair in ipairs(M.config.default_pairs) do
      pair.filetypes = pair.filetypes or nil
      pair.not_filetypes = pair.not_filetypes or nil

      M.insert_pair(
        { left = pair.left, right = pair.right },
        { filetypes = pair.filetypes, not_filetypes = pair.not_filetypes }
      )
    end
  end
  M.config.default_pairs = nil
end

local function insert_undo()
  local mark = vim.api.nvim_replace_termcodes("<c-g>u", true, false, true)
  vim.api.nvim_feedkeys(mark, "i", false)
end

local function get_or_create_filetype(filetype)
  local ft = store.filetypes[filetype]

  if not ft then
    ft = {
      index = #store.filetypes + 1,
      pairs = {},
      patterns = {},
      rules = {},
    }
    store.filetypes[filetype] = ft
  end

  return ft
end

local function insert_into(store_default, store_ft, elem, opts)
  opts.filetypes = opts.filetypes or nil
  opts.not_filetypes = opts.not_filetypes or nil

  if opts.filetypes then
    local store_ft_index = #store_ft + 1
    for _, filetype in ipairs(opts.filetypes) do
      local ft = get_or_create_filetype(filetype)
      local ft_list = ft[opts.ft_list]
      table.insert(ft_list, store_ft_index)
    end
    table.insert(store_ft, elem)
    return
  end

  if opts.not_filetypes then
    elem.not_filetypes = elem.not_filetypes or {}
    for _, filetype in ipairs(opts.not_filetypes) do
      local _ = get_or_create_filetype(filetype)
      elem.not_filetypes[filetype] = true
    end
  end
  table.insert(store_default, elem)
end

local function escape_pattern(text)
  return text:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
end

M.insert_pair_rule = function(config, opts)
  local pair = {
    pattern = {
      left = config.left .. "$",
      right = "^" .. config.right,
    },
    not_filetypes = nil,
  }

  insert_into(store_index[opts.type], store_index[opts.ft], pair, opts)
end

M.insert_pair = function(config, opts)
  if not config or not config.left and config.right then
    return
  end

  opts = opts or {}
  opts.type = "pairs.default"
  opts.ft = "pairs.ft"
  opts.ft_list = "pairs"

  config.left = escape_pattern(config.left)
  config.right = escape_pattern(config.right)

  M.insert_pair_rule(config, opts)
end

M.insert_rule = function(config, opts)
  if not config or not config.left and config.right then
    return
  end

  opts = opts or {}
  opts.type = "rules.default"
  opts.ft = "rules.ft"
  opts.ft_list = "rules"

  M.insert_pair_rule(config, opts)
end

M.insert_pattern = function(config, opts)
  if not config or not config.pattern then
    return
  end

  opts = opts or {}
  opts.type = "patterns.default"
  opts.ft_list = "patterns"

  -- Adds wildcards in the pattern and aditional rules.
  -- Right: "^(pattern)item.suffix"
  -- Left: "item.prefix(pattern)$"
  local config_pattern = (config.prefix or "") .. "(" .. config.pattern .. ")" .. (config.suffix or "")
  local pattern = {
    pattern = {
      left = config_pattern .. "$",
      right = "^" .. config_pattern,
    },
    not_filetypes = nil,
  }
  insert_into(store_index[opts.type], store.patterns.ft, pattern, opts)
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

local function count_pattern(line, pattern, start_col, end_col)
  local match = line:sub(start_col, end_col):match(pattern)
  print(pattern, line, match, match and #match)
  return (match and #match) or 0
end

local function get_range_line(col, len, direction)
  if direction == utils.direction.left then
    return 1, col
  end
  return col, len
end

local function get_range_lines(
  left_row,
  left_start_col,
  left_end_col,
  right_row,
  right_start_col,
  right_end_col,
  direction
)
  if direction == utils.direction.left then
    return left_row, left_start_col, right_row, right_end_col
  end
  return right_row, right_start_col, left_row, left_end_col
end

local function calc_col(cache_line, len, direction)
  if direction == utils.direction.left then
    return cache_line.end_col - len, cache_line.end_col
  end
  return cache_line.start_col - 1, cache_line.start_col + len - 1
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

---Peek the next symbol across lines running by a specified direction,
---returninig the char and position.
---@param row integer
---@param col integer
---@param direction string
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

---@param row integer
---@param col integer
---@param direction string
local function consume_spaces_and_lines(row, col, direction)
  local left_row, left_start_col = row, col
  local right_row, right_end_col = row, col

  local row_pos, col_pos = eat_empty_lines(row, col, direction)

  if direction == utils.direction.right then
    right_row = row_pos
    left_start_col = left_start_col - 1
    right_end_col = (col_pos == 0 and 1) or col_pos - 1
  elseif direction == utils.direction.left then
    left_row = row_pos
    left_start_col = col_pos
  end

  vim.api.nvim_buf_set_text(
    utils.bufnr,
    left_row,
    left_start_col,
    right_row,
    right_end_col,
    { string.rep(M.config.join_line.separator, M.config.join_line.times) }
  )
end

---@param row integer
local function join_line(row)
  local line = vim.api.nvim_get_current_line()
  consume_spaces_and_lines(row, #line + 1, utils.direction.right)
end

---@param cache table
---@param pattern string
---@return boolean
local function delete_pattern(cache, pattern)
  local count = count_pattern(cache.line.text, pattern, cache.line.start_col, cache.line.end_col)

  if count >= 1 then
    local start_col, end_col = calc_col(cache.line, count, cache.direction)
    insert_undo()
    vim.api.nvim_buf_set_text(utils.bufnr, cache.line.row, start_col, cache.line.row, end_col, {})
    return true
  end

  return false
end

---@param cache table
---@param left string
---@param right string
---@return boolean
local function delete_pairs(cache, left, right)
  local left_pattern, right_pattern = left, right
  if cache.direction == utils.direction.right then
    left_pattern, right_pattern = right, left
  end

  local left_count = count_pattern(cache.line.text, left_pattern, cache.line.start_col, cache.line.end_col)

  if left_count > 1 then
    if not cache.lookup_line then
      peek_non_whitespace(cache, row, start_col, utils.opposite[direction])
    end
    local right_count =
      count_pattern(cache.lookup_line.text, right_pattern, cache.lookup_line.start_col, cache.lookup_line.end_col)

    if right_count > 1 then
      local left_start_col, left_end_col = calc_col(cache.line, left_count, cache.direction)
      local right_start_col, right_end_col = calc_col(cache.lookup_line, right_count, utils.opposite[cache.direction])

      local sr, sc, er, ec = get_range_lines(
        cache.line.row,
        left_start_col,
        left_end_col,
        cache.lookup_line.row,
        right_start_col,
        right_end_col,
        cache.direction
      )
      insert_undo()
      vim.api.nvim_buf_set_text(utils.bufnr, sr, sc, er, ec, {})
    end

    return left_count > 1 and right_count > 1
  end

  return false
end

---
---@param item table
---@param row integer
---@param col integer
---@param direction string
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

---@param row integer
---@param col integer
---@param direction string
local function delete_word(row, col, direction)
  local line = vim.api.nvim_get_current_line()

  local start_col, end_col = get_range_line(col, #line, direction)
  local new_line = line:sub(start_col, end_col)

  if col == 0 or col > #line then
    if M.config.delete_empty_lines_until_next_char then
      insert_undo()
      consume_spaces_and_lines(row, col, direction)
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

  local char = line:sub(col, col)

  local cache = {
    direction = direction,
    line = {
      text = new_line,
      row = row,
      start_col = start_col,
      end_col = end_col,
    },
    lookup_line = nil,
  }

  if delete_pattern(cache, M.config.seek_spaces[direction]) then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local config_filetype = store.filetypes[filetype]

  if config_filetype then
    -- for _, item in ipairs(config_filetype.treesitter.captures) do
    --   if delete_capture(item, row, col, direction) then
    --     return
    --   end
    -- end

    for _, index in ipairs(config_filetype.rules) do
      local item = store.rules.ft[index]
      if delete_pairs(cache, item.pattern.left, item.pattern.right) then
        return
      end
    end

    for _, index in ipairs(config_filetype.patterns) do
      local item = store.patterns.ft[index]
      if delete_pattern(cache, item.pattern[direction]) then
        return
      end
    end

    for _, index in ipairs(config_filetype.pairs) do
      local item = store.pairs.ft[index]
      if delete_pairs(cache, item.pattern.left, item.pattern.right) then
        return
      end
    end
  end

  for _, item in ipairs(store.rules.default) do
    if not in_ignore_list(item, filetype) then
      if delete_pairs(cache, item.pattern.left, item.pattern.right) then
        return
      end
    end
  end

  for _, item in ipairs(store.patterns.default) do
    if not in_ignore_list(item, filetype) then
      if delete_pattern(cache, item.pattern[direction]) then
        return
      end
    end
  end

  for _, item in ipairs(store.pairs.default) do
    if not in_ignore_list(item, filetype) then
      if delete_pairs(cache, item.pattern.left, item.pattern.right) then
        return
      end
    end
  end

  if char:match("%p") then
    if delete_pattern(cache, M.config.seek_punctuations[direction]) then
      return
    end
  end

  local col_peek = 0

  -- Digits
  if M.config.passthrough_numbers then
    col_peek = count_pattern(line, "%d", start_col, end_col)
  elseif delete_pattern(cache, M.config.seek_numbers[direction]) then
    return
  end

  -- Uppercase
  if M.config.passthrough_uppercase then
    col_peek = count_pattern(line, "%u", start_col, end_col)
  elseif delete_pattern(cache, M.config.seek_uppercases[direction]) then
    return
  end

  -- start_col, end_col = calc_col(start_col, end_col, col_peek, direction)
  if delete_pattern(cache, M.config.seek_lowercases[direction]) then
    return
  end
end

---Is <BS> and <DEL> but add the capability of deleting matching pairs.
---@param row integer
---@param col integer
---@param direction string
local function delete(row, col, direction)
  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col, col)

  local row_start, col_start = row, col
  local row_end, col_end = row, col

  if char:match("%p") then
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    local config_filetype = store.filetypes[filetype]

    local cache = {
      line = nil,
      row = 0,
      start_col = 0,
      end_col = 0,
    }

    local start_col, end_col = get_range_line(col, #line, direction)

    if config_filetype then
      for _, index in ipairs(config_filetype.pairs) do
        local item = store.pairs.ft[index]
        if delete_pairs(cache, item.pattern.left, item.pattern.right) then
          return
        end
      end
    end

    for _, item in ipairs(store.pairs.default) do
      if not in_ignore_list(item, filetype) then
        if delete_pairs(cache, item.pattern.left, item.pattern.right) then
          return
        end
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
