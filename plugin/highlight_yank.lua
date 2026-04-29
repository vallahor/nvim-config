local v = vim.v

local nvim_get_current_win = vim.api.nvim_get_current_win
local nvim_create_autocmd = vim.api.nvim_create_autocmd

local getpos = vim.fn.getpos
local getregionpos = vim.fn.getregionpos
local matchaddpos = vim.fn.matchaddpos
local matchdelete = vim.fn.matchdelete

nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    local yank = v.event
    if yank.operator ~= "y" then
      return
    end

    local pos1, pos2 = getpos("'["), getpos("']")
    local region_list = getregionpos(pos1, pos2, { type = yank.regtype, eol = true })

    local positions = {}
    for i = 1, #region_list do
      local region = region_list[i]
      local srow, scol, ecol = region[1][2], region[1][3], region[2][3]
      positions[#positions + 1] = { srow, scol, ecol - scol + 1 }
    end

    local win = nvim_get_current_win()
    local id = matchaddpos("VisualYank", positions, 999) --[[@as integer]]

    vim.defer_fn(function()
      pcall(matchdelete, id, win)
    end, 200)
  end,
})
