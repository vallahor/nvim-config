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

api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local normal_fg = get_hex("Normal", "fg")
    local win_sep_fg = get_hex("WinSeparator", "fg")
    local errors_fg = get_hex("DiagnosticError", "fg")
    local warning_fg = get_hex("DiagnosticWarn", "fg")
    local hl = api.nvim_set_hl
    hl(0, "TablineCurrent", { fg = normal_fg, bg = focused_bg })
    hl(0, "TablineVisible", { fg = dim_fg, bg = hidden_bg })
    hl(0, "TablineHidden", { fg = dim_fg, bg = hidden_bg })
    hl(0, "TablineModifiedCurrent", { fg = normal_fg, bg = focused_bg, italic = true })
    hl(0, "TablineModifiedVisible", { fg = dim_fg, bg = hidden_bg, italic = true })
    hl(0, "TablineModifiedHidden", { fg = dim_fg, bg = hidden_bg, italic = true })
    hl(0, "TablineFill", { bg = hidden_bg })
    hl(0, "TablineSidebarLabelFocused", { fg = normal_fg, bg = focused_bg })
    hl(0, "TablineSidebarLabelHidden", { fg = normal_fg, bg = hidden_bg })
    hl(0, "TablineSidebarSep", { fg = win_sep_fg, bg = hidden_bg })
    hl(0, "TablineDiagError", { fg = errors_fg, bg = focused_bg })
    hl(0, "TablineDiagErrorHid", { fg = errors_fg, bg = hidden_bg })
    hl(0, "TablineDiagWarn", { fg = warning_fg, bg = focused_bg })
    hl(0, "TablineDiagWarnHid", { fg = warning_fg, bg = hidden_bg })
    hl(0, "TablineDiagModifiedError", { fg = errors_fg, bg = focused_bg, italic = true })
    hl(0, "TablineDiagModifiedErrorHid", { fg = errors_fg, bg = hidden_bg, italic = true })
    hl(0, "TablineDiagModifiedWarn", { fg = warning_fg, bg = focused_bg, italic = true })
    hl(0, "TablineDiagModifiedWarnHid", { fg = warning_fg, bg = hidden_bg, italic = true })
  end,
})

local buf_order = {}
local buf_lookup = {}

for _, b in ipairs(api.nvim_list_bufs()) do
  if bo[b].buflisted then
    buf_order[#buf_order + 1] = b
    buf_lookup[b] = true
  end
end

local buf_index = {}

-- Rebuild this whenever buf_order changes
local function update_buf_index()
  for i, b in ipairs(buf_order) do
    buf_index[b] = i
  end
end

-- Optimized current buffer lookup
local function get_current_index()
  return buf_index[api.nvim_get_current_buf()] or 1
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
      update_buf_index()
      vim.cmd.redrawtabline()
    end)
  end,
})

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
    { "%#TablineDiagErrorHid#", "%#TablineDiagError#" },
    { "%#TablineDiagModifiedErrorHid#", "%#TablineDiagModifiedError#" },
  },
  [2] = {
    { "%#TablineDiagWarnHid#", "%#TablineDiagWarn#" },
    { "%#TablineDiagModifiedWarnHid#", "%#TablineDiagModifiedWarn#" },
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
    local sidebar_hl = in_tree and "%#TablineSidebarLabelFocused#" or "%#TablineSidebarLabelHidden#"
    local pad_spaces = spaces(pad)
    sidebar = sidebar_hl .. pad_spaces .. explorer_label .. pad_spaces .. "%#TablineSidebarSep#│"
  end

  -- local names = {}
  -- local seen = {}
  --
  -- for _, b in ipairs(buf_order) do
  --   local bufname = api.nvim_buf_get_name(b)
  --   local tail = bufname ~= "" and fnamemodify(bufname, ":t") or "[No Name]"
  --   local display = " " .. tail .. " "
  --
  --   if seen[display] then
  --     local full_display = " " .. fnamemodify(bufname, ":~:."):gsub("^%./", "") .. " "
  --     names[b] = { name = full_display, w = strwidth(full_display) }
  --   else
  --     names[b] = { name = display, w = strwidth(display) }
  --     seen[display] = true
  --   end
  -- end

  -- local names = {}
  -- local counts = {}
  --
  -- for _, b in ipairs(buf_order) do
  --   local bufname = api.nvim_buf_get_name(b)
  --   local tail = bufname ~= "" and fnamemodify(bufname, ":t") or "[No Name]"
  --   counts[tail] = (counts[tail] or 0) + 1
  -- end
  --
  -- for _, b in ipairs(buf_order) do
  --   local bufname = api.nvim_buf_get_name(b)
  --   local tail = bufname ~= "" and fnamemodify(bufname, ":t") or "[No Name]"
  --
  --   local display
  --   if counts[tail] > 1 then
  --     display = " " .. fnamemodify(bufname, ":~:."):gsub("^%./", "") .. " "
  --   else
  --     display = " " .. tail .. " "
  --   end
  --
  --   names[b] = { name = display, w = strwidth(display) }
  -- end

  local names = {}
  local counts = {}

  for _, b in ipairs(buf_order) do
    local bufname = api.nvim_buf_get_name(b)
    local tail = bufname ~= "" and fnamemodify(bufname, ":t") or "[No Name]"
    counts[tail] = (counts[tail] or 0) + 1
    names[b] = { bufname = bufname, tail = tail }
  end

  for _, info in pairs(names) do
    local display
    if counts[info.tail] > 1 and info.bufname ~= "" then
      display = " " .. fnamemodify(info.bufname, ":~:."):gsub("^%./", "") .. " "
    else
      display = " " .. info.tail .. " "
    end
    info.name = display
    info.w = strwidth(display)
  end

  -- Visible windows
  local visible_bufs = {}
  for _, w in ipairs(api.nvim_list_wins()) do
    visible_bufs[api.nvim_win_get_buf(w)] = true
  end

  local avail = vim.o.columns - sidebar_width - (tree_winnr and 1 or 0)
  local tabs = {}
  local total_w = 0

  for i, b in ipairs(buf_order) do
    local label = names[b].name
    local w = names[b].w
    local focused = b == cur_buf
    local visible = visible_bufs[b] and not focused
    local modified = bo[b].modified

    ---@type string?
    local hl
    local diagnostic_count = vim.diagnostic.count(b, diag_filter)
    local sev = (diagnostic_count[1] and diagnostic_count[1] > 0) and 1
      or (diagnostic_count[2] and diagnostic_count[2] > 0) and 2
      or nil
    if sev then
      hl = diag_hl_map[sev][modified and 2 or 1][focused and 2 or 1]
    else
      if modified then
        hl = focused and "%#TablineModifiedCurrent#"
          or visible and "%#TablineModifiedVisible#"
          or "%#TablineModifiedHidden#"
      else
        hl = focused and "%#TablineCurrent#" or visible and "%#TablineVisible#" or "%#TablineHidden#"
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
    return sidebar .. "%#TablineFill#"
  end

  local ghost_space = 4
  local result_tabs = tabs
  if total_w > avail then
    local kept = { tabs[focus_idx] }
    local w = tabs[focus_idx].w
    local lo, hi = focus_idx - 1, focus_idx + 1

    while true do
      local added = false
      if hi <= #tabs and w + tabs[hi].w <= avail - ghost_space then
        w = w + tabs[hi].w
        kept[#kept + 1] = tabs[hi]
        hi = hi + 1
        added = true
      end
      if lo >= 1 and w + tabs[lo].w <= avail - ghost_space then
        w = w + tabs[lo].w
        table.insert(kept, 1, tabs[lo])
        lo = lo - 1
        added = true
      end
      if not added then
        break
      end
    end

    if lo >= 1 then
      table.insert(kept, 1, { str = " %#TablineHidden#…", w = 1 })
    end
    if hi <= #tabs then
      table.insert(kept, { str = "%#TablineHidden#… ", w = 1 })
    end

    result_tabs = kept
  end

  local n = #result_tabs
  local parts = {}
  parts[1] = sidebar
  for i = 1, n do
    parts[i + 1] = result_tabs[i].str
  end
  parts[n + 2] = "%#TablineFill#"
  return table.concat(parts, "")
end

vim.opt.tabline = "%!v:lua.make_tabline()"
vim.opt.showtabline = 2

-- navigation
local function is_nvim_tree()
  return api.nvim_get_current_win() == nvim_tree_view.get_winnr()
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
  update_buf_index()
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
    update_buf_index()
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
    update_buf_index()
    vim.cmd.redrawtabline()
  end
end

local function buf_delete(bufnr, force)
  bufnr = bufnr == 0 and api.nvim_get_current_buf() or bufnr

  local idx = buf_index[bufnr]
  if not idx then
    return
  end

  buf_lookup[bufnr] = nil
  table.remove(buf_order, idx)
  update_buf_index()

  local fallback = buf_order[idx] or buf_order[idx - 1]
  if not fallback then
    fallback = api.nvim_create_buf(true, false)
    buf_order[#buf_order + 1] = fallback
    buf_lookup[fallback] = true
    update_buf_index()
  end

  for _, win in ipairs(api.nvim_list_wins()) do
    if api.nvim_win_get_buf(win) == bufnr and api.nvim_win_is_valid(win) and api.nvim_buf_is_valid(fallback) then
      api.nvim_win_set_buf(win, fallback)
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
