local bo = vim.bo
local cmd = vim.cmd
local schedule = vim.schedule
local redraw = cmd.redraw

local nvim_set_option_value = vim.api.nvim_set_option_value
local nvim_get_current_win = vim.api.nvim_get_current_win
local nvim_set_hl = vim.api.nvim_set_hl
local nvim_create_autocmd = vim.api.nvim_create_autocmd

-- Better highlight
-- https://coolors.co/gradient-palette/291c28-1e141d?number=7
nvim_set_hl(0, "CursorHidden", { blend = 100, bg = "#121112" })
nvim_set_hl(0, "CursorLineInative", { bg = "#20151F" })
nvim_set_hl(0, "CursorLineNrInative", { fg = "#a1495c", bg = "#20151F" })

local guicursor_default = vim.g.user_guicursor_default
local guicursor_hidden = vim.g.user_guicursor_hidden
local cursor_line_active = "CursorLine:CursorLine,CursorLineNr:CursorLineNr"
local cursor_line_inactive = "CursorLine:CursorLineInative,CursorLineNr:CursorLineNrInative"

nvim_set_option_value("guicursor", guicursor_default, {})

local ignore_file_types = { NvimTree = true }
local function update_window_cursors()
  local current_win = nvim_get_current_win()

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local cursor_line = win == current_win and cursor_line_active or cursor_line_inactive
    nvim_set_option_value("winhighlight", cursor_line, { win = win })
  end

  local bufnr = vim.api.nvim_win_get_buf(current_win)
  local guicursor = ignore_file_types[bo[bufnr].filetype] and guicursor_hidden or guicursor_default
  nvim_set_option_value("guicursor", guicursor, {})
end

local update_scheduled = false
local function schedule_window_cursor_update()
  if update_scheduled then
    return
  end

  update_scheduled = true
  schedule(function()
    update_scheduled = false
    update_window_cursors()
  end)
end

nvim_create_autocmd({ "WinEnter", "WinLeave", "WinNew", "BufEnter", "TabEnter" }, {
  callback = schedule_window_cursor_update,
})

schedule_window_cursor_update()

local cmdline_active = false
nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    if ignore_file_types[bo.filetype] then
      cmdline_active = true
      schedule(function()
        if cmdline_active then
          nvim_set_option_value("guicursor", guicursor_default, {})
          redraw()
        end
      end)
      return
    end
    redraw()
  end,
})

nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    cmdline_active = false
    if ignore_file_types[bo.filetype] then
      nvim_set_option_value("guicursor", guicursor_hidden, {})
    end
  end,
})

return {
  guicursor_default,
  guicursor_hidden,
}
