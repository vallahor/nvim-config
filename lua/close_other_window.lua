local M = {}

local function close_other_window(direction)
  local old_win = vim.api.nvim_get_current_win()
  vim.cmd(string.format("wincmd %s", direction))
  local win = vim.api.nvim_get_current_win()

  vim.api.nvim_set_current_win(old_win)
  if #vim.api.nvim_list_wins() > 1 and old_win ~= win then
    vim.api.nvim_win_close(win, false)
  end
end

M.left = function()
  close_other_window("h")
end

M.down = function()
  close_other_window("j")
end

M.up = function()
  close_other_window("k")
end

M.right = function()
  close_other_window("l")
end

return M
