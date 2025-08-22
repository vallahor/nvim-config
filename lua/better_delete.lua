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
    ["left"] = "%s*$",
    ["right"] = "^%s*",
  },
  seek_punctuations = {
    ["left"] = "%p*$",
    ["right"] = "^%p*",
  },
  seek_numbers = {
    ["left"] = "%d*$",
    ["right"] = "^%d*",
  },
  seek_uppercases = {
    ["left"] = "%u*$",
    ["right"] = "^%u*",
  },
  seek_lowercases = {
    ["left"] = "%u?%l*[%d%u]?$",
    ["right"] = "^%u?%l*%d?",
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

local function get_col(start_col, end_col, direction)
  if direction == utils.direction.left then
    return start_col
  end
  return end_col
end

---@param slice string
---@param col integer
---@param direction any
---@return string
---@return integer
local function seek_spaces(slice, col, direction)
  local match = slice:match(M.config.seek_spaces[direction])
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

---@param cache table
---@param pattern string
---@return boolean
local function delete_pattern(cache, pattern, min)
  local count = count_pattern(cache.line.slice, pattern)

  if count > min then
    local start_col, end_col = calc_col(cache.line.col, count, cache.direction)
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

  local left_count = count_pattern(cache.line.slice, left_pattern)

  if left_count > 0 then
    -- we should account the end of file and begin of file
    -- so we dont run the delete pair again to other pairs and rules
    if not cache.lookup_line.slice then
      local col = cache.line.col + utils.direction_step[utils.opposite[cache.direction]]
      local slice = nil
      local row = 0
      slice, row, col = eat_empty_lines(cache.line.text, cache.line.row, col, utils.opposite[cache.direction])
      if not slice then
        return false
      end
      cache.lookup_line.slice = slice
      cache.lookup_line.row = row
      cache.lookup_line.col = col
    end

    local right_count = count_pattern(cache.lookup_line.slice, right_pattern)

    if right_count > 0 then
      local sr, sc, er, ec = get_range_lines(
        cache.line.row,
        cache.line.col,
        cache.lookup_line.row,
        cache.lookup_line.col,
        utils.opposite[cache.direction]
      )
      if cache.direction == utils.direction.left then
        sc = sc - left_count
        ec = ec + right_count - 1
      elseif cache.direction == utils.direction.right then
        sc = sc - right_count
        ec = ec + left_count - 1
      end
      insert_undo()
      vim.api.nvim_buf_set_text(utils.bufnr, sr, sc, er, ec, {})
    end

    return left_count > 0 and right_count > 0
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

  local cache = {
    direction = direction,
    line = {
      text = line,
      slice = new_line,
      row = row,
      col = col,
    },
    lookup_line = {},
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

  local char = line:sub(col, col)

  if delete_pattern(cache, M.config.seek_spaces[direction], 0) then
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
      if delete_pattern(cache, item.pattern[direction], 0) then
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
      if delete_pattern(cache, item.pattern[direction], 0) then
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
    if delete_pattern(cache, M.config.seek_punctuations[direction], 1) then
      return
    end
  end

  local col_peek = 0

  -- Digits
  if M.config.passthrough_numbers then
    col_peek = count_pattern(new_line, "%d")
  elseif delete_pattern(cache, M.config.seek_numbers[direction], 1) then
    return
  end

  -- Uppercase
  if M.config.passthrough_uppercase then
    col_peek = count_pattern(new_line, "%u")
  elseif delete_pattern(cache, M.config.seek_uppercases[direction], 1) then
    return
  end

  -- start_col, end_col = calc_col(start_col, end_col, col_peek, direction)
  if delete_pattern(cache, M.config.seek_lowercases[direction], 0) then
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

    local start_col, end_col = get_range_line(col, #line, direction)

    local cache = {
      direction = direction,
      line = {
        text = line,
        slice = line:sub(start_col, end_col),
        row = row,
        col = col,
      },
      lookup_line = {},
    }

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

M.join = function(opts)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  join_line(row - 1, opts)
end

return M
