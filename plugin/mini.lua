vim.pack.add({ "https://github.com/echasnovski/mini.icons" })

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
