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
  direction_step = {
    left = -1,
    right = 1,
  },
  seek_spaces = {
    left = "%s*$",
    right = "^%s*",
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
  repeated_punctuation = true,
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
  seek_punctuation = {
    left = "%p$",
    right = "^%p",
  },
  seek_allowed_punctuations = {
    left = "[%.%,%!%?%:%;%-%/%@%#%$%%%^%&%*%_%+%=%~%|%\\]*$",
    right = "^[%.%,%!%?%:%;%-%/%@%#%$%%%^%&%*%_%+%=%~%|%\\]*",
  },
  seek_numbers = {
    left = "%d*$",
    right = "^%d*",
  },
  seek_uppercases = {
    left = "%u*$",
    right = "^%u*",
  },
  seek_lowercases = {
    left = "%u?%l*[%d%u]?$",
    right = "^%u?%l*%d?",
  },
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
  return text:gsub("([%p])", "%%%1")
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

local function count_pattern(line, pattern)
  local match = line:match(pattern)
  return (match and #match) or 0
end

local function get_range_line(col, len, direction)
  if direction == utils.direction.left then
    return 1, col
  end
  return col, len
end

local function get_range_lines(left_row, left_col, right_row, right_col, direction)
  if direction == utils.direction.left then
    return right_row, right_col, left_row, left_col
  end
  return left_row, left_col, right_row, right_col
end

local function calc_col(col, len, direction)
  if direction == utils.direction.left then
    return col - len, col
  end
  return col - 1, col + len - 1
end

---@param slice string
---@param col integer
---@param direction any
---@return string
---@return integer
local function seek_spaces(slice, col, direction)
  local match = slice:match(utils.seek_spaces[direction])
  if direction == utils.direction.left then
    return slice:sub(1, #slice - #match), col - #match
  end
  return slice:sub(#match + 1), col + #match
end

local function seek_line(row, direction)
  row = row + utils.direction_step[direction]
  local line = vim.api.nvim_buf_get_lines(utils.bufnr, row, row + 1, false)[1] or ""
  local col = (direction == utils.direction.left and #line) or 1
  return line, row, col
end

---@param text string
---@param row integer
---@param col integer
---@param direction any
---@return string|nil
---@return integer
---@return integer
local function eat_empty_lines(text, row, col, direction)
  local rows = vim.api.nvim_buf_line_count(0)
  if (col <= 0 and row <= 0) or (col > #text and row + 1 >= rows) then
    return nil, row, col
  end

  local start_col, end_col = get_range_line(col, #text, direction)
  local slice = text:sub(start_col, end_col)
  slice, col = seek_spaces(slice, col, direction)

  if col > 0 and col <= #text then
    return slice, row, col
  end

  while row >= 0 and row <= rows do
    text, row, col = seek_line(row, direction)
    if not text:match("^%s*$") then
      break
    end
  end

  start_col, end_col = get_range_line(col, #text, direction)
  slice = text:sub(start_col, end_col)
  slice, col = seek_spaces(slice, col, direction)
  row = math.min(rows - 1, math.max(row, 0))
  return slice, row, col
end

local function consume_spaces_and_lines(text, row, col, direction, separator)
  local line, new_row, new_col = eat_empty_lines(text, row, col, direction)

  if not line then
    return
  end

  local left_row, left_col, right_row, right_col = get_range_lines(row, col, new_row, new_col, direction)

  if direction == utils.direction.right then
    left_col = left_col - 1
    right_col = right_col - 1
  end

  vim.api.nvim_buf_set_text(utils.bufnr, left_row, left_col, right_row, right_col, { separator })
end

---@param opts table
local function join_line(row, opts)
  opts = opts or {}
  opts.separator = opts.separator or M.config.join_line.separator or ""
  opts.times = opts.times or M.config.join_line.times or 1

  local line = vim.api.nvim_get_current_line()
  local separator = string.rep(opts.separator, opts.times)
  consume_spaces_and_lines(line, row, #line + 1, utils.direction.right, separator)
end

---@param context table
---@param pattern string
---@return boolean
local function delete_pattern(context, pattern, min)
  local count = count_pattern(context.line.slice, pattern)

  if count > min then
    local start_col, end_col = calc_col(context.line.col, count, context.direction)
    insert_undo()
    vim.api.nvim_buf_set_text(utils.bufnr, context.line.row, start_col, context.line.row, end_col, {})
    return true
  end

  return false
end

---@param context table
---@param left string
---@param right string
---@return boolean
local function delete_pairs(context, left, right)
  local left_pattern, right_pattern = left, right
  if context.direction == utils.direction.right then
    left_pattern, right_pattern = right, left
  end

  local left_count = count_pattern(context.line.slice, left_pattern)

  if left_count > 0 then
    if not context.lookup_line.slice then
      local col = context.line.col + utils.direction_step[utils.opposite[context.direction]]
      local slice = nil
      local row = 0

      slice, row, col = eat_empty_lines(context.line.text, context.line.row, col, utils.opposite[context.direction])

      if not slice then
        context.lookup_line.valid = false
        return false
      end

      context.lookup_line.slice = slice
      context.lookup_line.row = row
      context.lookup_line.col = col
    end

    local right_count = count_pattern(context.lookup_line.slice, right_pattern)

    if right_count > 0 then
      local left_row, left_col, right_row, right_col = get_range_lines(
        context.line.row,
        context.line.col,
        context.lookup_line.row,
        context.lookup_line.col,
        utils.opposite[context.direction]
      )

      if context.direction == utils.direction.left then
        left_col = left_col - left_count
        right_col = right_col + right_count - 1
      elseif context.direction == utils.direction.right then
        left_col = left_col - right_count
        right_col = right_col + left_count - 1
      end

      insert_undo()
      vim.api.nvim_buf_set_text(utils.bufnr, left_row, left_col, right_row, right_col, {})
    end

    return left_count > 0 and right_count > 0
  end

  return false
end

---@param row integer
---@param col integer
---@param direction string
local function delete_word(row, col, direction)
  local line = vim.api.nvim_get_current_line()
  local start_col, end_col = get_range_line(col, #line, direction)

  local context = {
    direction = direction,
    line = {
      text = line,
      slice = line:sub(start_col, end_col),
      row = row,
      col = col,
    },
    lookup_line = {
      valid = true,
    },
  }

  if col == 0 or col > #line then
    if M.config.delete_empty_lines_until_next_char then
      insert_undo()
      consume_spaces_and_lines(line, row, col, direction, "")
      return
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

  if delete_pattern(context, utils.seek_spaces[direction], 0) then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local config_filetype = store.filetypes[filetype]

  if config_filetype then
    for _, index in ipairs(config_filetype.rules) do
      if not context.lookup_line.valid then
        break
      end
      local item = store.rules.ft[index]
      if delete_pairs(context, item.pattern.left, item.pattern.right) then
        return
      end
    end

    for _, index in ipairs(config_filetype.patterns) do
      local item = store.patterns.ft[index]
      if delete_pattern(context, item.pattern[direction], 0) then
        return
      end
    end

    for _, index in ipairs(config_filetype.pairs) do
      if not context.lookup_line.valid then
        break
      end
      local item = store.pairs.ft[index]
      if delete_pairs(context, item.pattern.left, item.pattern.right) then
        return
      end
    end
  end

  for _, item in ipairs(store.rules.default) do
    if not context.lookup_line.valid then
      break
    end
    if not in_ignore_list(item, filetype) then
      if delete_pairs(context, item.pattern.left, item.pattern.right) then
        return
      end
    end
  end

  for _, item in ipairs(store.patterns.default) do
    if not in_ignore_list(item, filetype) then
      if delete_pattern(context, item.pattern[direction], 0) then
        return
      end
    end
  end

  for _, item in ipairs(store.pairs.default) do
    if not context.lookup_line.valid then
      break
    end
    if not in_ignore_list(item, filetype) then
      if delete_pairs(context, item.pattern.left, item.pattern.right) then
        return
      end
    end
  end

  if line:sub(col, col):match("%p") then
    if M.config.repeated_punctuation then
      if delete_pattern(context, M.config.seek_allowed_punctuations[direction], 0) then
        return
      end
    end
    if delete_pattern(context, M.config.seek_punctuation[direction], 0) then
      return
    end
  end

  if delete_pattern(context, M.config.seek_numbers[direction], 1) then
    return
  end

  if delete_pattern(context, M.config.seek_uppercases[direction], 1) then
    return
  end

  if delete_pattern(context, M.config.seek_lowercases[direction], 0) then
    return
  end
end

---@param row integer
---@param col integer
---@param direction string
local function delete(row, col, direction)
  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col, col)

  if char:match("%p") then
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    local config_filetype = store.filetypes[filetype]

    local start_col, end_col = get_range_line(col, #line, direction)

    local context = {
      direction = direction,
      line = {
        text = line,
        slice = line:sub(start_col, end_col),
        row = row,
        col = col,
      },
      lookup_line = {
        valid = true,
      },
    }

    if config_filetype then
      for _, index in ipairs(config_filetype.pairs) do
        if not context.lookup_line.valid then
          break
        end
        local item = store.pairs.ft[index]
        if delete_pairs(context, item.pattern.left, item.pattern.right) then
          return
        end
      end
    end

    for _, item in ipairs(store.pairs.default) do
      if not context.lookup_line.valid then
        break
      end
      if not in_ignore_list(item, filetype) then
        if delete_pairs(context, item.pattern.left, item.pattern.right) then
          return
        end
      end
    end
  end

  --- It's necessary to recreate the <bs>/<del> behavior
  --- because it's not possible to map this function to <bs>/<del>
  --- and call `nvim_feedkeys` as a fallback without an infinite loop.
  --- Other solutions like couting the empty spaces/tabs/lines not worked
  --- because of `nvim_srtwidth` was counting the tabs as spaces `tabwidth`
  --- generating way more <bs>/<del> than required deleting more than
  --- expected.
  local rows = vim.api.nvim_buf_line_count(0)
  if rows == 1 and #line == 0 or col > #line and row + 1 >= rows then
    return
  end

  local start_row, start_col = row, col
  local end_row, end_col = row, col

  if direction == utils.direction.right then
    start_col = col - 1

    if col > #line and row + 1 < rows then
      end_row = row + 1
      end_col = 0
    end
  elseif direction == utils.direction.left then
    if col > 0 then
      start_col = col - 1
    elseif row > 0 then
      start_row = row - 1
      line = vim.api.nvim_buf_get_lines(utils.bufnr, start_row, start_row + 1, true)[1]
      start_col = #line
    end
  end

  vim.api.nvim_buf_set_text(utils.bufnr, start_row, start_col, end_row, end_col, {})
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

M.join = function(opts)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  join_line(row - 1, opts)
end

return M
