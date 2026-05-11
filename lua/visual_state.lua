local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_get_current_win = vim.api.nvim_get_current_win
local nvim_win_get_config = vim.api.nvim_win_get_config
local nvim_get_mode = vim.api.nvim_get_mode
local line = vim.fn.line

---@type table<integer, table<string, boolean|integer>?>
local M = {}

local function update_visual_cursor(state)
  local cursor_start = line("v")
  local cursor_end = line(".")
  if cursor_start > cursor_end then
    cursor_start, cursor_end = cursor_end, cursor_start
  end

  state.visual_start = cursor_start
  state.visual_end = cursor_end
end

nvim_create_autocmd("ModeChanged", {
  callback = function()
    local state = M[nvim_get_current_win()]
    if not state then
      return
    end

    local m = nvim_get_mode().mode
    state.in_visual = m == "v" or m == "V" or m == "\x16"

    if state.in_visual then
      update_visual_cursor(state)
    end
  end,
})

nvim_create_autocmd("CursorMoved", {
  callback = function()
    local state = M[nvim_get_current_win()]
    if not state or not state.in_visual then
      return
    end

    update_visual_cursor(state)
  end,
})

local function init_state()
  local win = nvim_get_current_win()
  if #nvim_win_get_config(win).relative == 0 then
    M[win] = { in_visual = false }
  end
end

nvim_create_autocmd("VimEnter", {
  once = true,
  callback = init_state,
})

nvim_create_autocmd("WinNew", {
  callback = init_state,
})

nvim_create_autocmd("WinClosed", {
  callback = function(ev)
    M[tonumber(ev.match)] = nil
  end,
})

return M
