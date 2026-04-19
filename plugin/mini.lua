vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })
-- Statusline

-- https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/statusline.lua#L557
local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

local modes = setmetatable({
  ["n"] = { short = "N", hl = "MiniStatuslineModeNormal" },
  ["v"] = { short = "V", hl = "MiniStatuslineModeVisual" },
  ["V"] = { short = "V-L", hl = "MiniStatuslineModeVisual" },
  [CTRL_V] = { short = "V-B", hl = "MiniStatuslineModeVisual" },
  ["s"] = { short = "S", hl = "MiniStatuslineModeVisual" },
  ["S"] = { short = "S-L", hl = "MiniStatuslineModeVisual" },
  [CTRL_S] = { short = "S-B", hl = "MiniStatuslineModeVisual" },
  ["i"] = { short = "I", hl = "MiniStatuslineModeInsert" },
  ["R"] = { short = "R", hl = "MiniStatuslineModeReplace" },
  ["c"] = { short = "C", hl = "MiniStatuslineModeCommand" },
  ["r"] = { short = "P", hl = "MiniStatuslineModeOther" },
  ["!"] = { short = "Sh", hl = "MiniStatuslineModeOther" },
  ["t"] = { short = "T", hl = "MiniStatuslineModeOther" },
  ["no"] = { short = "O", hl = "MiniStatuslineModeOther" },
}, {
  __index = function()
    return { short = "U", hl = "MiniStatuslineModeOther" }
  end,
})

local MiniStatusline = require("mini.statusline")
local location = "L%l/%L C%c"
local get_filename = function()
  if vim.bo.buftype == "terminal" then
    return "%t"
  end
  local fname = vim.fn.expand("%:.")
  return (fname ~= "" and fname .. " " or "") .. "%m%r"
end
MiniStatusline.setup({
  use_icons = false,
  content = {
    active = function()
      local mode_info = modes[vim.api.nvim_get_mode().mode]
      local mode, mode_hl = mode_info.short, mode_info.hl

      local filename = get_filename()

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { strings = { "%S" } },
        { strings = { vim.bo.filetype } },
        { hl = mode_hl, strings = { location } },
      })
    end,
    inactive = function()
      local filename = get_filename()
      return MiniStatusline.combine_groups({
        { hl = "MiniStatuslineModeNormal", strings = { "-" } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { strings = { "%S" } },
        { strings = { vim.bo.filetype } },
        { hl = "MiniStatuslineModeNormal", strings = { location } },
      })
    end,
  },
})

-- -- Buf Remove
-- local bufremove = require("mini.bufremove")
-- bufremove.setup()
--
-- vim.keymap.set("n", "<c-w>", function()
--   _G.MiniBufremove.delete(0, false)
-- end, { nowait = true })
-- vim.keymap.set("n", "<c-x>", function()
--   _G.MiniBufremove.delete(0, true)
-- end, { nowait = true })

-- closes the current window and buffer
-- to close the current buffer and not the window use <c-w>
vim.keymap.set("n", "<c-s-x>", vim.cmd.bdelete()) -- close current buffer and window -- not work with ghostty (combination in use)

-- Cursor Word
require("mini.cursorword").setup({
  delay = 0,
})

vim.api.nvim_set_hl(0, "MiniCursorword", {
  sp = "none",
  fg = "none",
  bg = "#2D2829",
})
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {
  sp = "none",
  fg = "none",
  bg = "#2D2829",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "neo-tree", "SidebarNvim" },
  callback = function()
    vim.b.ministatusline_disable = true
    vim.b.minicursorword_disable = true
  end,
})

local MiniIcons = require("mini.icons")
MiniIcons.setup()
MiniIcons.mock_nvim_web_devicons()

vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = "#51a0cf" })
vim.api.nvim_set_hl(0, "MiniIconsBlue", { fg = "#51a0cf" })
vim.api.nvim_set_hl(0, "MiniIconsCyan", { fg = "#00bfff" })
vim.api.nvim_set_hl(0, "MiniIconsGreen", { fg = "#8fbc8f" })
vim.api.nvim_set_hl(0, "MiniIconsGrey", { fg = "#9e9e9e" })
vim.api.nvim_set_hl(0, "MiniIconsOrange", { fg = "#d18b5f" })
vim.api.nvim_set_hl(0, "MiniIconsPurple", { fg = "#9b59b6" })
vim.api.nvim_set_hl(0, "MiniIconsRed", { fg = "#cc6666" })
vim.api.nvim_set_hl(0, "MiniIconsWhite", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = "#f0c674" })

local devicons = require("nvim-web-devicons")
local _get_icon = devicons.get_icon
devicons.get_icon = function(name, ext, opts)
  local icon, hl = _get_icon(name, ext, opts)
  if icon then
    return icon, hl
  end
  local dir_icon, dir_hl = MiniIcons.get("directory", name or "")
  return dir_icon, dir_hl
end
