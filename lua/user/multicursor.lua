local api = vim.api

local M = {
  ns = api.nvim_create_namespace("nvim.multicursor"),
}

function M.has()
  return #api.nvim_buf_get_extmarks(0, M.ns, 0, -1, { limit = 1 }) > 0
end

function M.feed(keys)
  api.nvim_feedkeys(vim.keycode(keys), "ni", false)
end

local function cell_end(row, col)
  local line = api.nvim_buf_get_lines(0, row, row + 1, true)[1] or ""
  if col >= #line then
    return col + 1
  end
  return col + vim.str_byteindex(line:sub(col + 1), 1)
end

function M.set_cursor(id, row, col)
  api.nvim_buf_set_extmark(0, M.ns, row, col, {
    id = id,
    end_row = row,
    end_col = cell_end(row, col),
    right_gravity = true,
    end_right_gravity = false,
    ui_watched = true,
    strict = false,
  })
end

return M
