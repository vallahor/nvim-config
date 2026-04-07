local api, fn, bo = vim.api, vim.fn, vim.bo
local floor, strwidth, fnamemodify = math.floor, fn.strwidth, fn.fnamemodify

local function get_hex(group, attr)
  local ok, val = pcall(api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or not val then
    return
  end
  local n = (attr == "fg") and val.fg or val.bg
  return n and string.format("#%06x", n)
end

local dim_fg = "#7e706c"
local focused_bg = "#3f303f"
local hidden_bg = "#191319"

local function set_hls()
  local normal_fg = get_hex("Normal", "fg")
  local win_sep_fg = get_hex("WinSeparator", "fg")
  local errors_fg = get_hex("DiagnosticError", "fg")
  local warning_fg = get_hex("DiagnosticWarn", "fg")
  local hl = api.nvim_set_hl
  hl(0, "MiniTablineCurrent", { fg = normal_fg, bg = focused_bg })
  hl(0, "MiniTablineVisible", { fg = dim_fg, bg = hidden_bg })
  hl(0, "MiniTablineHidden", { fg = dim_fg, bg = hidden_bg })
  hl(0, "MiniTablineModifiedCurrent", { fg = normal_fg, bg = focused_bg, italic = true })
  hl(0, "MiniTablineModifiedVisible", { fg = dim_fg, bg = hidden_bg, italic = true })
  hl(0, "MiniTablineModifiedHidden", { fg = dim_fg, bg = hidden_bg, italic = true })
  hl(0, "MiniTablineFill", { bg = hidden_bg })
  hl(0, "MiniTablineSidebarLabelFocused", { fg = normal_fg, bg = focused_bg })
  hl(0, "MiniTablineSidebarLabelHidden", { fg = normal_fg, bg = hidden_bg })
  hl(0, "MiniTablineSidebarSep", { fg = win_sep_fg, bg = hidden_bg })
  hl(0, "MiniTablineDiagError", { fg = errors_fg, bg = focused_bg })
  hl(0, "MiniTablineDiagErrorHid", { fg = errors_fg, bg = hidden_bg })
  hl(0, "MiniTablineDiagWarn", { fg = warning_fg, bg = focused_bg })
  hl(0, "MiniTablineDiagWarnHid", { fg = warning_fg, bg = hidden_bg })
  hl(0, "MiniTablineDiagModifiedError", { fg = errors_fg, bg = focused_bg, italic = true })
  hl(0, "MiniTablineDiagModifiedErrorHid", { fg = errors_fg, bg = hidden_bg, italic = true })
  hl(0, "MiniTablineDiagModifiedWarn", { fg = warning_fg, bg = focused_bg, italic = true })
  hl(0, "MiniTablineDiagModifiedWarnHid", { fg = warning_fg, bg = hidden_bg, italic = true })
end

set_hls()
api.nvim_create_autocmd("ColorScheme", { callback = set_hls })

local buf_order = {}
local buf_lookup = {}

for _, b in ipairs(api.nvim_list_bufs()) do
  if bo[b].buflisted then
    buf_order[#buf_order + 1] = b
    buf_lookup[b] = true
  end
end

api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local b = api.nvim_get_current_buf()
    if not bo[b].buflisted then
      return
    end
    if buf_lookup[b] then
      return
    end

    vim.schedule(function()
      if not api.nvim_buf_is_valid(b) then
        return
      end
      if buf_lookup[b] then
        return
      end
      buf_order[#buf_order + 1] = b
      buf_lookup[b] = true
      vim.cmd.redrawtabline()
    end)
  end,
})

local function make_unique(namemap)
  local counts = {}
  for _, n in pairs(namemap) do
    counts[n] = (counts[n] or 0) + 1
  end
  for b, n in pairs(namemap) do
    if counts[n] > 1 then
      local fullname = api.nvim_buf_get_name(b)
      if fullname ~= "" then
        namemap[b] = fnamemodify(fullname, ":~:."):gsub("^%./", "")
      end
    end
  end
end

local cached_pad = -1
local cached_spaces = ""
local function spaces(n)
  if cached_pad ~= n then
    cached_pad = n
    cached_spaces = string.rep(" ", n)
  end
  return cached_spaces
end

-- nvim_tree
local nvim_tree_view = require("nvim-tree.view")
local explorer_label = "Explorer"
local explorer_label_len = strwidth(explorer_label)

-- [severity][modified+1][focused+1]
---@type table<integer, table<integer, table<integer, string>>>
local diag_hl_map = {
  [1] = {
    { "%#MiniTablineDiagErrorHid#", "%#MiniTablineDiagError#" },
    { "%#MiniTablineDiagModifiedErrorHid#", "%#MiniTablineDiagModifiedError#" },
  },
  [2] = {
    { "%#MiniTablineDiagWarnHid#", "%#MiniTablineDiagWarn#" },
    { "%#MiniTablineDiagModifiedWarnHid#", "%#MiniTablineDiagModifiedWarn#" },
  },
}

local focus_idx = 1
local diag_filter = { severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR } }

-- tabline
function _G.make_tabline()
  local cur_win = api.nvim_get_current_win()
  local tree_winnr = nvim_tree_view.get_winnr() --[[@as integer?]]
  local in_tree = tree_winnr ~= nil and cur_win == tree_winnr
  local cur_buf = in_tree and -1 or api.nvim_get_current_buf()

  -- Sidebar
  local sidebar = ""
  local sidebar_width = 0
  if tree_winnr then
    sidebar_width = api.nvim_win_get_width(tree_winnr)
    local pad = math.max(0, floor((sidebar_width - explorer_label_len) / 2))
    local sidebar_hl = in_tree and "%#MiniTablineSidebarLabelFocused#" or "%#MiniTablineSidebarLabelHidden#"
    local pad_spaces = spaces(pad)
    sidebar = sidebar_hl .. pad_spaces .. explorer_label .. pad_spaces .. "%#MiniTablineSidebarSep#│"
  end

  -- Names
  local names = {}
  for _, b in ipairs(buf_order) do
    local name = api.nvim_buf_get_name(b)
    local tail = name ~= "" and fnamemodify(name, ":t") or ""
    names[b] = tail ~= "" and tail or "[No Name]"
  end
  make_unique(names)

  -- Visible windows
  local visible_bufs = {}
  for _, w in ipairs(api.nvim_list_wins()) do
    visible_bufs[api.nvim_win_get_buf(w)] = true
  end

  local avail = vim.o.columns - sidebar_width - (tree_winnr and 1 or 0)
  local tabs = {}
  local total_w = 0

  for i, b in ipairs(buf_order) do
    local label = " " .. names[b] .. " "
    local w = strwidth(label)
    local focused = b == cur_buf
    local visible = visible_bufs[b] and not focused
    local modified = bo[b].modified

    ---@type string?
    local hl
    local counts = vim.diagnostic.count(b, diag_filter)
    local sev = (counts[1] and counts[1] > 0) and 1 or (counts[2] and counts[2] > 0) and 2 or nil
    if sev then
      hl = diag_hl_map[sev][modified and 2 or 1][focused and 2 or 1]
    else
      if modified then
        hl = focused and "%#MiniTablineModifiedCurrent#"
          or visible and "%#MiniTablineModifiedVisible#"
          or "%#MiniTablineModifiedHidden#"
      else
        hl = focused and "%#MiniTablineCurrent#" or visible and "%#MiniTablineVisible#" or "%#MiniTablineHidden#"
      end
    end

    if focused then
      focus_idx = i
    end
    tabs[#tabs + 1] = { str = hl .. label, w = w }
    total_w = total_w + w
  end

  focus_idx = math.max(1, math.min(focus_idx, #tabs))
  if #tabs == 0 then
    return sidebar .. "%#MiniTablineFill#"
  end
  local result_tabs = tabs
  if total_w > avail then
    local kept = { tabs[focus_idx] }
    local w = tabs[focus_idx].w
    local lo, hi = focus_idx - 1, focus_idx + 1
    while true do
      local added = false
      if hi <= #tabs and w + tabs[hi].w <= avail then
        w = w + tabs[hi].w
        kept[#kept + 1] = tabs[hi]
        hi = hi + 1
        added = true
      end
      if lo >= 1 and w + tabs[lo].w <= avail then
        w = w + tabs[lo].w
        table.insert(kept, 1, tabs[lo])
        lo = lo - 1
        added = true
      end
      if not added then
        break
      end
    end
    result_tabs = kept
  end

  local parts = { sidebar }
  for _, t in ipairs(result_tabs) do
    parts[#parts + 1] = t.str
  end
  parts[#parts + 1] = "%#MiniTablineFill#"
  return table.concat(parts)
end

vim.opt.tabline = "%!v:lua.make_tabline()"
vim.opt.showtabline = 2

-- navigation
local function is_nvim_tree()
  return api.nvim_get_current_win() == nvim_tree_view.get_winnr()
end

local function get_current_index()
  local cur = api.nvim_get_current_buf()
  for i, b in ipairs(buf_order) do
    if b == cur then
      return i
    end
  end
  return 1
end

local function prev_tab()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i > 1 then
    api.nvim_set_current_buf(buf_order[i - 1] --[[@as integer]])
  end
end

local function next_tab()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i < #buf_order then
    api.nvim_set_current_buf(buf_order[i + 1] --[[@as integer]])
  end
end

local function move_to_begin()
  if is_nvim_tree() then
    return
  end
  api.nvim_set_current_buf(buf_order[1] --[[@as integer]])
end

local function move_to_end()
  if is_nvim_tree() then
    return
  end
  api.nvim_set_current_buf(buf_order[#buf_order] --[[@as integer]])
end

local function swap(i, j)
  buf_order[i], buf_order[j] = buf_order[j], buf_order[i]
  vim.cmd.redrawtabline()
end

local function move_tab_left()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i > 1 then
    swap(i, i - 1)
  end
end

local function move_tab_right()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i < #buf_order then
    swap(i, i + 1)
  end
end

local function move_tab_begin()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i > 1 then
    local b = table.remove(buf_order, i)
    table.insert(buf_order, 1, b)
    vim.cmd.redrawtabline()
  end
end

local function move_tab_end()
  if is_nvim_tree() then
    return
  end
  local i = get_current_index()
  if i < #buf_order then
    local b = table.remove(buf_order, i)
    buf_order[#buf_order + 1] = b
    vim.cmd.redrawtabline()
  end
end

local function buf_delete(bufnr, force)
  bufnr = bufnr == 0 and api.nvim_get_current_buf() or bufnr

  local idx
  for i, b in ipairs(buf_order) do
    if b == bufnr then
      idx = i
      break
    end
  end
  if not idx then
    return
  end

  buf_lookup[bufnr] = nil
  table.remove(buf_order, idx)

  local fallback = buf_order[idx] or buf_order[idx - 1]
  if not fallback then
    fallback = api.nvim_create_buf(true, false)
    buf_order[#buf_order + 1] = fallback
    buf_lookup[fallback] = true
  end

  local wins = vim.tbl_filter(function(win)
    return api.nvim_win_get_buf(win) == bufnr
  end, api.nvim_list_wins())

  if #wins > 0 then
    for _, win in ipairs(wins) do
      if api.nvim_win_is_valid(win) and api.nvim_buf_is_valid(fallback) then
        api.nvim_win_set_buf(win, fallback)
      end
    end
  end

  if api.nvim_buf_is_valid(bufnr) then
    api.nvim_buf_delete(bufnr, { force = force })
  end
end

vim.keymap.set("n", "<home>", prev_tab, { silent = true })
vim.keymap.set("n", "<end>", next_tab, { silent = true })
vim.keymap.set("n", "<s-home>", move_to_begin, { silent = true })
vim.keymap.set("n", "<s-end>", move_to_end, { silent = true })
vim.keymap.set("n", "<c-home>", move_tab_left, { silent = true })
vim.keymap.set("n", "<c-end>", move_tab_right, { silent = true })
vim.keymap.set("n", "<c-s-home>", move_tab_begin, { silent = true })
vim.keymap.set("n", "<c-s-end>", move_tab_end, { silent = true })

vim.keymap.set("n", "<c-w>", function()
  buf_delete(0, false)
end, { silent = true })
vim.keymap.set("n", "<c-x>", function()
  buf_delete(0, true)
end, { silent = true })
