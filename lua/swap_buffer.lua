function Swap(direction)
  local old_buf = vim.api.nvim_get_current_buf()
  local old_win = vim.api.nvim_get_current_win()

  vim.cmd(string.format("wincmd %s", direction))
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_buf(old_win, buf)
  vim.api.nvim_win_set_buf(win, old_buf)

  vim.api.nvim_set_current_win(old_win)
end

function Swap_left()
  Swap("h")
end

function Swap_down()
  Swap("j")
end

function Swap_up()
  Swap("k")
end

function Swap_right()
  Swap("l")
end
