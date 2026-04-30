local cmd = vim.cmd
local normal = cmd.normal

local keymap_set = vim.keymap.set
local nvim_get_current_win = vim.api.nvim_get_current_win

local line = vim.fn.line

local string_format = string.format
local visual_state = require("visual_state")
-- Uses `visual_state[win]` to get the visual position
-- cached, instead of calculating it everytime.
local move_direction_up = 2
local move_direction_down = 1
local function move_lines(direction)
  local state = visual_state[nvim_get_current_win()]
  if not state then
    return
  end

  local vstart = state.visual_start
  local vend = state.visual_end
  if direction == move_direction_down and vend >= line("$") or direction == move_direction_up and vstart <= 1 then
    return
  end

  normal({ "\27", bang = true })
  cmd(string_format("%d,%dm %d", vstart, vend, direction == move_direction_down and vend + 1 or vstart - 2))
  normal({ "gv=gv", bang = true })
end

keymap_set("x", "<Down>", function()
  move_lines(move_direction_down)
end, { silent = true })
keymap_set("x", "<Up>", function()
  move_lines(move_direction_up)
end, { silent = true })
