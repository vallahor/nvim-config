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

local guicursor_default = "n:block-Cursor,i-ci-c:block-iCursor,v:block-vCursor"
local guicursor_hidden = "n:block-Cursor,i-ci-c:block-iCursor,v:block-vCursor,a:CursorHidden/lCursorHidden"
local cursor_line_active = "CursorLine:CursorLine,CursorLineNr:CursorLineNr"
local cursor_line_inactive = "CursorLine:CursorLineInative,CursorLineNr:CursorLineNrInative"

nvim_set_option_value("guicursor", guicursor_default, {})

local ignore_file_types = { NvimTree = true }
nvim_create_autocmd("WinEnter", {
  callback = function()
    if ignore_file_types[bo.filetype] then
      nvim_set_option_value("guicursor", guicursor_hidden, {})
    else
      nvim_set_option_value("guicursor", guicursor_default, {})
    end
  end,
})

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

nvim_create_autocmd("WinEnter", {
  callback = function()
    nvim_set_option_value("winhighlight", cursor_line_active, { win = nvim_get_current_win() })
  end,
})

nvim_create_autocmd("WinLeave", {
  callback = function()
    nvim_set_option_value("winhighlight", cursor_line_inactive, { win = nvim_get_current_win() })
  end,
})
