local v = vim.v
local cmd = vim.cmd

local keymap_set = vim.keymap.set
local normal = cmd.normal
local nvim_get_mode = vim.api.nvim_get_mode
local nvim_feedkeys = vim.api.nvim_feedkeys
local nvim_win_set_cursor = vim.api.nvim_win_set_cursor

local get_parser = vim.treesitter.get_parser

local get_col = vim.fn.col
local setpos = vim.fn.setpos

local line = vim.fn.line

local _select = require("vim.treesitter._select")
---@type { [1]:integer, [2]:integer, [3]:integer, [4]:integer }[]
local stack = {}

local function decrement_selection()
  local m = nvim_get_mode().mode
  if not (m == "v" or m == "V" or m == "\x16") then
    return
  end

  local range = stack[#stack]
  stack[#stack] = nil

  if #stack == 0 then
    nvim_feedkeys("\27", "nx", true)
    if range ~= nil then
      nvim_win_set_cursor(0, { range[1] + 1, range[2] })
    end
    return
  end

  normal({ "v\27", bang = true })
  setpos("'<", { 0, range[1] + 1, range[2] + 1, 0 })
  setpos("'>", { 0, range[3] + 1, range[4], 0 })
  normal({ "gv", bang = true })
end

local function increment_selection()
  if not get_parser(nil, nil, { error = false }) then
    return
  end

  if nvim_get_mode().mode ~= "v" then
    stack = {}
  end

  local vline, vcol = line("v"), get_col("v")
  local cline, ccol = line("."), get_col(".")

  stack[#stack + 1] = { vline - 1, vcol - 1, cline - 1, ccol }
  _select.select_parent(v.count1)
end

keymap_set({ "n", "v", "o" }, "M", decrement_selection, { noremap = true })
keymap_set({ "n", "x", "o" }, "m", increment_selection, { noremap = true })
keymap_set("x", "<Esc>", function()
  stack = {}
  return "<esc>"
end, { expr = true })
