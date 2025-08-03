local M = {}

local function swap_buffer(direction)
  local old_buf = vim.api.nvim_get_current_buf()
  local old_win = vim.api.nvim_get_current_win()

  vim.cmd(string.format("wincmd %s", direction))
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_buf(old_win, buf)
  vim.api.nvim_win_set_buf(win, old_buf)

  vim.api.nvim_set_current_win(old_win)
end

M.left = function()
  swap_buffer("h")
end

M.down = function()
  swap_buffer("j")
end

M.up = function()
  swap_buffer("k")
end

M.right = function()
  swap_buffer("l")
end

return M
