vim.pack.add({
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/echasnovski/mini.pick",
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

local MiniPick = require("mini.pick")

local function picker_window()
  local height = math.max(1, math.floor(vim.o.lines * 0.8))
  local width = math.max(1, math.floor(vim.o.columns * 0.8))

  return {
    anchor = "NW",
    border = vim.o.winborder ~= "" and vim.o.winborder or "rounded",
    height = height,
    width = width,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  }
end

local function get_marked_or_current()
  local matches = MiniPick.get_picker_matches()
  return #matches.marked > 0 and matches.marked or { matches.current }
end

local function open_marked_buffers()
  local target = MiniPick.get_picker_state().windows.target

  for _, item in ipairs(get_marked_or_current()) do
    if item and vim.api.nvim_buf_is_valid(item.bufnr) then
      vim.api.nvim_win_set_buf(target, item.bufnr)
    end
  end

  return true
end

local function delete_marked_buffers()
  local errors = {}

  for _, item in ipairs(get_marked_or_current()) do
    if item and vim.api.nvim_buf_is_valid(item.bufnr) then
      local ok, err = pcall(vim.api.nvim_buf_delete, item.bufnr, {})
      if not ok then
        table.insert(errors, err)
      end
    end
  end

  if #errors > 0 then
    vim.schedule(function()
      vim.notify(table.concat(errors, "\n"), vim.log.levels.ERROR, { title = "Delete buffers" })
    end)
  end

  return true
end

MiniPick.setup({
  mappings = {
    choose = "<CR>",
    move_up = "<Up>",
    move_down = "<Down>",
    scroll_up = "<PageUp>",
    scroll_down = "<PageDown>",
    stop = "<Esc>",
    mark = "<S-Space>",
    mark_all = "<C-a>",
    delete_all = { char = "<C-d>", func = delete_marked_buffers },
  },
  options = {
    content_from_bottom = false,
  },
  window = {
    config = picker_window,
    prompt_caret = "▏",
    prompt_prefix = "",
  },
})

local function set_picker_theme()
  local hl = vim.api.nvim_set_hl
  hl(0, "MiniPickBorder", { link = "FloatBorder" })
  hl(0, "MiniPickBorderBusy", { link = "FloatBorder" })
  hl(0, "MiniPickBorderText", { link = "TabLineActive" })
  hl(0, "MiniPickCursor", { link = "CursorLine" })
  hl(0, "MiniPickHeader", { link = "TabLineActive" })
  hl(0, "MiniPickIconDirectory", { link = "MiniIndentscopeSymbol" })
  hl(0, "MiniPickIconFile", { link = "FloatNormal" })
  hl(0, "MiniPickMatchCurrent", { link = "CursorLine" })
  hl(0, "MiniPickMatchMarked", { link = "MiniIndentscopeSymbol" })
  hl(0, "MiniPickMatchRanges", { link = "CurSearch" })
  hl(0, "MiniPickNormal", { link = "FloatNormal" })
  hl(0, "MiniPickPreviewLine", { link = "CursorLine" })
  hl(0, "MiniPickPreviewRegion", { link = "CurSearch" })
  hl(0, "MiniPickPrompt", { link = "FloatNormal" })
  hl(0, "MiniPickPromptCaret", { link = "CurSearch" })
  hl(0, "MiniPickPromptPrefix", { link = "TabLineActive" })
end

set_picker_theme()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_picker_theme })

local function map_buffer_picker()
  vim.keymap.set("n", "<Tab>", function()
    MiniPick.builtin.buffers()
  end)
end

map_buffer_picker()
vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = map_buffer_picker })
