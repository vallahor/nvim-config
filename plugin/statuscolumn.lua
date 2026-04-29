local g = vim.g
local v = vim.v
local nvim_get_current_win = vim.api.nvim_get_current_win
local nvim_set_hl = vim.api.nvim_set_hl
local nvim_set_option_value = vim.api.nvim_set_option_value
local nvim_create_autocmd = vim.api.nvim_create_autocmd

local visual_state = require("visual_state")

nvim_set_hl(0, "CursorVisualNr", { fg = "#a1495c", bg = "#2d1524" })
nvim_set_hl(0, "VisualNr", { fg = "#493441", bg = "#2d1524" })
vim.o.statuscolumn = "%!v:lua.StatusColumn()"

function _G.StatusColumn()
  local hl = " "
  local relnum = v.relnum
  local win = g.statusline_winid
  local state = visual_state[win]

  if state and state.in_visual and win == nvim_get_current_win() then
    if relnum == 0 then
      hl = "%#CursorVisualNr# "
    else
      local lnum = v.lnum
      if lnum >= state.visual_start and lnum <= state.visual_end then
        hl = "%#VisualNr# "
      end
    end
  end

  return hl .. (relnum < 10 and " " .. relnum or relnum)
end

nvim_create_autocmd("FileType", {
  pattern = { "help", "text", "man" },
  callback = function()
    nvim_set_option_value("statuscolumn", "", { win = 0 })
    nvim_set_option_value("number", true, { win = 0 })
  end,
})
