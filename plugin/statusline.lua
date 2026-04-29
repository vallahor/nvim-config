local bo = vim.bo
local g = vim.g

local nvim_get_current_win = vim.api.nvim_get_current_win
local nvim_get_mode = vim.api.nvim_get_mode
local string_gsub = string.gsub

local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

vim.api.nvim_set_hl(0, "StatuslineModeNormal", { link = "Cursor" })
vim.api.nvim_set_hl(0, "StatuslineModeInsert", { fg = "#121112", bg = "#b1314c" })
vim.api.nvim_set_hl(0, "StatuslineModeVisual", { fg = "NONE", bg = "#471A37" })
vim.api.nvim_set_hl(0, "StatuslineModeReplace", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "StatuslineModeCommand", { link = "DiffText" })
vim.api.nvim_set_hl(0, "StatuslineModeOther", { link = "IncSearch" })

local modes = setmetatable({
  ["n"] = { short = "N", hl = "%#StatuslineModeNormal#" },
  ["v"] = { short = "V", hl = "%#StatuslineModeVisual#" },
  ["V"] = { short = "V-L", hl = "%#StatuslineModeVisual#" },
  [CTRL_V] = { short = "V-B", hl = "%#StatuslineModeVisual#" },
  ["s"] = { short = "S", hl = "%#StatuslineModeVisual#" },
  ["S"] = { short = "S-L", hl = "%#StatuslineModeVisual#" },
  [CTRL_S] = { short = "S-B", hl = "%#StatuslineModeVisual#" },
  ["i"] = { short = "I", hl = "%#StatuslineModeInsert#" },
  ["R"] = { short = "R", hl = "%#StatuslineModeReplace#" },
  ["c"] = { short = "C", hl = "%#StatuslineModeCommand#" },
  ["r"] = { short = "P", hl = "%#StatuslineModeOther#" },
  ["!"] = { short = "Sh", hl = "%#StatuslineModeOther#" },
  ["t"] = { short = "T", hl = "%#StatuslineModeOther#" },
  ["no"] = { short = "O", hl = "%#StatuslineModeOther#" },
}, {
  __index = function()
    return { short = "U", hl = "%#StatuslineModeOther#" }
  end,
})

local filename_cache = {}

local function update_filename(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if bo[buf].buftype == "terminal" then
    filename_cache[buf] = "%t"
    return
  end
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
  filename_cache[buf] = (fname ~= "" and string_gsub(fname, "\\", "/") .. " " or "") .. "%m%r"
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufFilePost" }, {
  callback = function(ev)
    update_filename(ev.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  callback = function(ev)
    filename_cache[ev.buf] = nil
  end,
})

local function get_filename()
  local buf = vim.api.nvim_win_get_buf(g.statusline_winid)
  return filename_cache[buf] or ""
end

function _G.StatusLine()
  local win = g.statusline_winid
  if vim.b[vim.api.nvim_win_get_buf(win)].statusline_disable then
    return ""
  end

  if not (win == nvim_get_current_win()) then
    return "%#StatuslineModeNormal# - %#StatusLineNC# %< "
      .. get_filename()
      .. " %=%#StatusLineNC# %S  %{&filetype} %#StatuslineModeNormal# L%l/%L C%c "
  end

  local mode_info = modes[nvim_get_mode().mode]
  return mode_info.hl
    .. " "
    .. mode_info.short
    .. " %#StatusLineNC# %<"
    .. get_filename()
    .. " %=%#StatusLineNC# %S  %{&filetype} "
    .. mode_info.hl
    .. " L%l/%L C%c "
end

vim.o.statusline = "%!v:lua.StatusLine()"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "neo-tree", "SidebarNvim" },
  callback = function()
    vim.b.statusline_disable = true
  end,
})
