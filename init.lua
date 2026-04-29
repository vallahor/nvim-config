local g = vim.g
local bo = vim.bo
local v = vim.v
local cmd = vim.cmd
local schedule = vim.schedule
local opt = vim.opt
local wo = vim.wo

local keymap_set = vim.keymap.set
local resize = cmd.resize
local wincmd = cmd.wincmd
local normal = cmd.normal
local redraw = cmd.redraw
local undo = cmd.undo
local redo = cmd.redo
local cc = cmd.cc
local cclose = cmd.cclose
local checktime = cmd.checktime
local redrawstatus = cmd.redrawstatus
local nohl = cmd.nohl
local edit = cmd.edit
local source = cmd.source

local nvim_set_option_value = vim.api.nvim_set_option_value
local nvim_get_current_win = vim.api.nvim_get_current_win
local nvim_get_current_buf = vim.api.nvim_get_current_buf
local nvim_win_get_buf = vim.api.nvim_win_get_buf
local nvim_get_mode = vim.api.nvim_get_mode
local nvim_feedkeys = vim.api.nvim_feedkeys
local nvim_win_set_cursor = vim.api.nvim_win_set_cursor
local nvim_set_hl = vim.api.nvim_set_hl
local nvim_win_get_cursor = vim.api.nvim_win_get_cursor
local nvim_list_wins = vim.api.nvim_list_wins
local nvim_win_get_config = vim.api.nvim_win_get_config
local nvim_win_close = vim.api.nvim_win_close
local nvim_create_autocmd = vim.api.nvim_create_autocmd

local snippet_stop = vim.snippet.stop

local get_parser = vim.treesitter.get_parser

local get_col = vim.fn.col
local setpos = vim.fn.setpos
local getpos = vim.fn.getpos
local getregionpos = vim.fn.getregionpos
local matchaddpos = vim.fn.matchaddpos
local matchdelete = vim.fn.matchdelete
local winsaveview = vim.fn.winsaveview
local winrestview = vim.fn.winrestview

local setreg = vim.fn.setreg
local expand = vim.fn.expand

local diag_jump = vim.diagnostic.jump

local line = vim.fn.line

local string_format = string.format

local comment = require("vim._comment")

vim.env.LANG = "en_US.UTF-8"

-- SETTINGS --
opt.guifont = { "JetBrainsMono NF:h11" }
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.smarttab = true
opt.smartcase = true
opt.autoindent = true
opt.hidden = true
opt.ignorecase = true
opt.shiftround = true
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"
opt.pumheight = 10
opt.switchbuf = "useopen,uselast"
opt.inccommand = "nosplit"
opt.backspace = "indent,eol,start"
opt.shortmess:append("aoOtTIcF")
opt.mouse = "a"
opt.mousefocus = true
opt.cursorline = true
opt.backup = false
opt.writebackup = false
opt.cindent = false -- check
opt.cino:append("L0,g0,l1,t0,w1,(0,w4,(s,m1")
opt.winborder = "rounded"
opt.isfname:append("(") -- " @windows: nextjs and sveltekit folder name pattern
opt.swapfile = false
opt.wrap = false
opt.history = 20
opt.timeout = false
-- opt.timeoutlen = 200
opt.autoread = true

wo.signcolumn = "no"
wo.relativenumber = true
wo.wrap = false

opt.linespace = 5
opt.cmdheight = 1
opt.showcmdloc = "statusline"

-- work around on python default configs
g.python_indent = {
  disable_parentheses_indenting = false,
  closed_paren_align_last_line = false,
  searchpair_timeout = 150,
  continue = 4,
  open_paren = 4,
  nested_paren = 4,
}

-- MAPPING --
local function esc_normal_mode()
  local wins = nvim_list_wins()
  for i = 1, #wins do
    local win = wins[i]
    if #nvim_win_get_config(win).relative > 0 then
      nvim_win_close(win, false)
    end
  end
  snippet_stop()
  nohl()
  normal({ "", bang = true })
end

keymap_set("n", "<esc>", esc_normal_mode)

pcall(vim.keymap.del, "n", "gcc")
keymap_set("n", "gc", function()
  local row = nvim_win_get_cursor(0)[1]
  comment.toggle_lines(row, row)
end, { noremap = true, silent = true })

keymap_set({ "i", "s" }, "<esc>", function()
  snippet_stop()
  return "<esc>"
end, { expr = true })

-- vim.keymap.set("i", "<s-enter>", "<c-o>O") -- new line up
-- vim.keymap.set("i", "<c-enter>", "<c-o>o") -- new line down

keymap_set({ "n", "v" }, "<s-s>", function()
  cmd.write({ bang = true, mods = { silent = true } })
end) -- save file

keymap_set("n", "\\", cmd.close) -- close current window
keymap_set("n", "|", cmd.vsplit) -- split vertical window
keymap_set("n", "_", cmd.split) -- split horizontal window
keymap_set("n", "<c-9>", "<c-w>o") -- close other windows
keymap_set("n", "<c-8>", "<c-w>r") -- rotate windows

-- resize windows
keymap_set("n", "<c-=>", function()
  wincmd({ "=", mods = { silent = true } })
end) -- resize all windows

keymap_set("n", "<c-6>", function()
  resize({ "+2", mods = { vertical = true } })
end) -- make the window biger   vertically
keymap_set("n", "<c-4>", function()
  resize({ "-2", mods = { vertical = true } })
end) -- make the window smaller vertically
keymap_set("n", "<c-8>", function()
  resize({ "+2", mods = { horizontal = true } })
end) -- make the window bigger  horizontally
keymap_set("n", "<c-5>", function()
  resize({ "-2", mods = { horizontal = true } })
end) -- make the window smaller horizontally

local function _wincmd(dir)
  wincmd({ dir, mods = { silent = true } })
end

keymap_set("n", "<left>", function()
  _wincmd("h")
end) -- move to window left
keymap_set("n", "<down>", function()
  _wincmd("j")
end) -- move to window down
keymap_set("n", "<up>", function()
  _wincmd("k")
end) -- move to window up
keymap_set("n", "<right>", function()
  _wincmd("l")
end) -- move to window right

keymap_set("n", "<cr>", "<nop>")

keymap_set("n", "Y", "yg$") -- yank to end of line considering line wrap

keymap_set({ "n", "v" }, "<PageUp>", "<c-u>zzzz", { noremap = true }) -- page up
keymap_set({ "n", "v" }, "<PageDown>", "<c-d>zzzz", { noremap = true }) -- page down

keymap_set("i", "<PageUp>", "<nop>", { noremap = true }) -- page up
keymap_set("i", "<PageDown>", "<nop>", { noremap = true }) -- page down

keymap_set({ "i", "c" }, "<c-v>", [[<c-r>+]]) -- paste to command line mode

keymap_set("n", "u", function()
  undo({ mods = { silent = true } })
  redrawstatus()
end)

keymap_set("n", "<C-r>", function()
  redo({ mods = { silent = true } })
  redrawstatus()
end)

keymap_set("v", "v", "V", { noremap = true }) -- visual line mode

keymap_set("c", "<c-bs>", "<c-w>") -- delete previous word (cmd)

keymap_set("n", "x", '"_x') -- delete current char without copying
keymap_set("n", "<c-d>", '"_dd') -- delete line without copying
keymap_set("v", "x", '"_d') -- delete char in visual mode without copying
keymap_set({ "n", "v" }, "c", '"_c') -- change verb without copying

keymap_set("n", "dx", '"_d') -- delete without copying to register @check working ok with default timeoutlen

keymap_set("n", "*", function()
  setreg("/", "\\<" .. expand("<cword>") .. "\\>")
  opt.hlsearch = true
end)
keymap_set("v", "*", '"sy/\\V<c-r>s<cr>``') -- highlight all occurencies of the curren selection

-- go to beginning of the line function like DOOM Emacs
local function beginning_of_the_line()
  local old_pos = get_col(".")
  normal("^")
  if old_pos == get_col(".") then
    setpos(".", { 0, line("."), 0, 0 })
  end
end

keymap_set("i", "<home>", beginning_of_the_line) -- go to beginning of the line
keymap_set({ "n", "v" }, "(", beginning_of_the_line) -- go to beginning of the line
keymap_set("n", ")", "$") -- go to end of line
keymap_set("v", ")", "$h") -- go to end of line (for some reason it's goes to wrong place in visual mode)

-- duplicate line and lines
keymap_set("n", "<c-c>", function()
  normal('"0yy"0p')
end) -- duplicate line down
keymap_set("v", "<c-c>", function()
  normal('"0y"0Pgv')
end) -- like sublime duplicate line

-- duplicate and comment
keymap_set("n", "<c-s-c>", function()
  normal('0yygc"0p')
end)
keymap_set("v", "<c-s-c>", function()
  normal('gcgv"0y"0Pgvgc')
end)

keymap_set("n", "<f4>", function()
  edit("$MYVIMRC")
end) -- open config file (vimrc or init.lua)
keymap_set("n", "<f5>", function()
  source("%")
end) -- execute current file (vim or lua)
keymap_set("n", "<f8>", function()
  edit("~/.config/ghostty/config")
end) -- open ghostty config file (vimrc or init.lua)
keymap_set("n", "<f11>", function()
  vim.notify("Words: " .. vim.fn.wordcount().words)
end) -- Count words of the current buffer

keymap_set("n", "`", "<C-^>") -- back to last buffer

keymap_set("n", "<f1>", cmd.Inspect) -- inspect current token treesitter
keymap_set("n", "<f3>", cmd.InspectTree) -- inspect current token treesitter

-- when it's not in lsp
keymap_set("n", "K", "<nop>")

-- -- add undo capabilities in insert mode
-- keymap_set("i", "<space>", "<c-g>u<space>")
-- keymap_set("i", "<enter>", "<c-g>u<enter>")
-- keymap_set("i", "<tab>", "<c-g>u<tab>")
-- keymap_set("i", "<bs>", "<c-g>u<bs>")
-- keymap_set("i", "<c-bs>", "<c-g>u<c-bs>")
-- keymap_set("i", "[", "[<c-g>u")
-- keymap_set("i", "{", "{<c-g>u")
-- keymap_set("i", "(", "(<c-g>u")
-- keymap_set("i", "]", "]<c-g>u")
-- keymap_set("i", "}", "}<c-g>u")
-- keymap_set("i", ")", ")<c-g>u")
-- keymap_set("i", ",", ",<c-g>u")
-- keymap_set("i", ".", ".<c-g>u")

-- visual mode - paste without copying
keymap_set({ "v", "x" }, "p", "P")

-- Open mini.pick buffer selection if not do this.
keymap_set("n", "<c-i>", "<c-i>")

-- closes the current window and buffer
-- to close the current buffer and not the window use <c-w>
keymap_set("n", "<c-s-x>", cmd.bdelete()) -- close current buffer and window -- not work with ghostty (combination in use)

-- close quickfix menu after selecting choice
nvim_create_autocmd("FileType", {
  pattern = { "qf" },
  callback = function()
    local function enter_and_close()
      cc(line("."))
      cclose()
    end
    keymap_set("n", "<cr>", enter_and_close, { buffer = true })
    keymap_set("n", "o", enter_and_close, { buffer = true })
    keymap_set("n", "q", cclose, { buffer = true })
    keymap_set("n", "<esc>", cclose, { buffer = true })
  end,
})

nvim_create_autocmd("FocusGained", {
  callback = function()
    checktime({ mods = { silent = true } })
  end,
})

nvim_create_autocmd("FileType", {
  pattern = {
    "css",
    "javascript",
    "json",
    "typescript",
    "typescriptreact",
  },
  callback = function(args)
    if not g.editorconfig then
      nvim_set_option_value("shiftwidth", 2, { buf = args.buf })
      nvim_set_option_value("tabstop", 2, { buf = args.buf })
    end
  end,
})

nvim_create_autocmd("FileType", {
  pattern = {
    "eex",
    "heex",
    "elixir",
    "html",
    "lua",
    "vue",
    "svelte",
  },
  callback = function(args)
    nvim_set_option_value("shiftwidth", 2, { buf = args.buf })
    nvim_set_option_value("tabstop", 2, { buf = args.buf })
  end,
})

keymap_set("n", "<", "<<", { nowait = true, remap = true }) -- indent left
keymap_set("n", ">", ">>", { nowait = true, remap = true }) -- indent right

local cow = require("close_other_window")
keymap_set({ "n", "v" }, "<c-left>", cow.left)
keymap_set({ "n", "v" }, "<c-down>", cow.down)
keymap_set({ "n", "v" }, "<c-up>", cow.up)
keymap_set({ "n", "v" }, "<c-right>", cow.right)

local sb = require("swap_buffer")
keymap_set({ "n", "v" }, "<s-left>", sb.left)
keymap_set({ "n", "v" }, "<s-down>", sb.down)
keymap_set({ "n", "v" }, "<s-up>", sb.up)
keymap_set({ "n", "v" }, "<s-right>", sb.right)

-- movements with timeout
nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  pattern = "*",
  callback = function()
    keymap_set({ "n", "v", "x" }, "[", function()
      diag_jump({ count = -1, float = false })
    end, { nowait = true, buffer = true }) -- previous diagnostic
    keymap_set({ "n", "v", "x" }, "]", function()
      diag_jump({ count = 1, float = false })
    end, { nowait = true, buffer = true }) -- next diagnostic

    -- move indentation
    keymap_set({ "v", "x" }, "<", function()
      normal({ "<gv", bang = true })
    end, { nowait = true, buffer = true })

    keymap_set({ "v", "x" }, ">", function()
      normal({ ">gv", bang = true })
    end, { nowait = true, buffer = true })
  end,
})

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

vim.filetype.add({
  pattern = {
    ["*.gs"] = "glsl",
    ["*.vs"] = "glsl",
    ["*.fs"] = "glsl",
    ["*.vert"] = "glsl",
    ["*.frag"] = "glsl",
    ["*.geom"] = "glsl",
    ["*.scm"] = "query",
    [".*%.blade%.php"] = "blade",
  },
})

nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = winsaveview()
    cmd([[keeppatterns %s/\s+$//e]])
    winrestview(save)
  end,
})

if g.neovide then
  g.neovide_input_ime = false
  g.neovide_cursor_animation_length = 0
  g.neovide_scroll_animation_length = 0
  g.neovide_cursor_trail_size = 0.0
  g.neovide_position_animation_length = 0.0
  g.neovide_refresh_rate = 144
  g.neovide_cursor_animate_in_insert_mode = false
  g.neovide_cursor_animate_in_command_line = false
end

-- GODOT BEGIN
-- vim_godot.{bat|sh}: {file} {line} {col}
-- batch file to run as the external editor
-- @echo off
-- setlocal
-- set FILE=%1
-- set LINE=%2
-- set COL=%3
-- set "FILE=%FILE:\=/%"

-- set SERVER=127.0.0.1:6004

-- netstat -ano | findstr :6004 >nul
-- if %ERRORLEVEL% NEQ 0 (
--     start C:\apps\neovide\neovide.exe --no-vsync -- +":e %FILE%" +":call cursor(%LINE%,%COL%)"
-- ) else (
--     nvim --server %SERVER% --remote-send "<esc>:e %FILE%<cr>:call cursor(%LINE%,%COL%)<cr>"
-- )
-- endlocal

-- paths to check for project.godot file
if false then
  local godot_project_path = ""

  local paths_to_check = { "/", "/../" }
  local cwd = vim.fn.getcwd()
  -- iterate over paths and check
  for _, value in pairs(paths_to_check) do
    if vim.uv.fs_stat(cwd .. value .. "project.godot") then
      godot_project_path = cwd .. value
      break
    end
  end

  if godot_project_path ~= "" then
    local is_server_running = vim.uv.fs_stat(godot_project_path .. "/server.pipe")

    local addr = godot_project_path .. "/server.pipe"
    if vim.fn.has("win32") == 1 then
      addr = "127.0.0.1:6004"
    end

    local started_godot_server = false
    if vim.fn.filereadable(cwd .. "/project.godot") == 1 and not is_server_running then
      if v.servername ~= addr then
        local ok = pcall(function()
          vim.fn.serverstart(addr)
        end)

        if ok then
          started_godot_server = true
        end
      end
    end

    nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if started_godot_server then
          pcall(function()
            vim.fn.serverstop(addr)
          end)
        end
      end,
    })
  end
end
-- GODOT END

-- nvim_set_hl(0, "@attribute.gdscript", { fg = "#9B668F" })
nvim_set_hl(0, "@attribute.gdscript", { fg = "#96674E" })
-- nvim_set_hl(0, "@string.special.url.gdscript", { fg = "#926C83" })
nvim_set_hl(0, "@string.special.url.gdscript", { fg = "#9B668F" })

nvim_set_hl(0, "DiagnosticLineNumhlError", { fg = "#a1495c", bg = "#221418" })
nvim_set_hl(0, "DiagnosticLineNumhlWarn", { fg = "#a1495c", bg = "#221c12" })
nvim_set_hl(0, "DiagnosticLineNumhlInfo", { fg = "#a1495c", bg = "#1c1a1c" })
nvim_set_hl(0, "DiagnosticLineNumhlHint", { fg = "#a1495c", bg = "#1a1a1a" })

nvim_set_hl(0, "CursorVisualNr", { fg = "#a1495c", bg = "#2d1524" })
nvim_set_hl(0, "VisualNr", { fg = "#493441", bg = "#2d1524" })
vim.o.statuscolumn = "%!v:lua.StatusColumn()"

---@type table<integer?, table<string, boolean|integer>>
local visual_state = {}

local function update_visual_cursor(buf)
  local cursor_start = line("v")
  local cursor_end = line(".")
  if cursor_start > cursor_end then
    cursor_start, cursor_end = cursor_end, cursor_start
  end

  visual_state[buf].visual_start = cursor_start
  visual_state[buf].visual_end = cursor_end
end

nvim_create_autocmd("ModeChanged", {
  callback = function(ev)
    local m = nvim_get_mode().mode
    local in_visual = m == "v" or m == "V" or m == "\x16"

    visual_state[ev.buf] = {
      in_visual = in_visual,
    }

    if in_visual then
      update_visual_cursor(ev.buf)
    end
  end,
})

nvim_create_autocmd("CursorMoved", {
  callback = function(ev)
    local state = visual_state[ev.buf]
    if not state or not state.in_visual then
      return
    end

    update_visual_cursor(ev.buf)
  end,
})

nvim_create_autocmd("BufWipeout", {
  callback = function(ev)
    visual_state[ev.buf] = nil
  end,
})

function _G.StatusColumn()
  local hl = " "
  local relnum = v.relnum
  local win = g.statusline_winid
  local state = visual_state[nvim_win_get_buf(win)]

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

-- Uses `visual_state[buf]` to get the visual position
-- cached, instead of calculating it everytime.
local move_direction_up = 2
local move_direction_down = 1
local function move_lines(direction)
  local state = visual_state[nvim_get_current_buf()]
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

-- Better highlight
-- https://coolors.co/gradient-palette/291c28-1e141d?number=7
nvim_set_hl(0, "CursorHidden", { blend = 100, bg = "#121112" })
nvim_set_hl(0, "CursorLineInative", { bg = "#20151F" })
nvim_set_hl(0, "CursorLineNrInative", { fg = "#a1495c", bg = "#20151F" })

local guicursor_default = "n:block-Cursor,i-ci-c:block-iCursor,v:block-vCursor"
local guicursor_hidden = "n:block-Cursor,i-ci-c:block-iCursor,v:block-vCursor,a:CursorHidden/lCursorHidden"
local cursor_line_active = "CursorLine:CursorLine,CursorLineNr:CursorLineNr"
local cursor_line_inactive = "CursorLine:CursorLineInative,CursorLineNr:CursorLineNrInative"

nvim_set_option_value("guicursor", guicursor_default, {})

local ignore_file_types = { NvimTree = true }
nvim_create_autocmd("WinEnter", {
  callback = function()
    if ignore_file_types[bo.filetype] then
      nvim_set_option_value("guicursor", guicursor_hidden, {})
    else
      nvim_set_option_value("guicursor", guicursor_default, {})
    end
  end,
})

local cmdline_active = false
nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    if ignore_file_types[bo.filetype] then
      cmdline_active = true
      schedule(function()
        if cmdline_active then
          nvim_set_option_value("guicursor", guicursor_default, {})
          redraw()
        end
      end)
      return
    end
    redraw()
  end,
})

nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    cmdline_active = false
    if ignore_file_types[bo.filetype] then
      nvim_set_option_value("guicursor", guicursor_hidden, {})
    end
  end,
})

nvim_create_autocmd("WinEnter", {
  callback = function()
    nvim_set_option_value("winhighlight", cursor_line_active, { win = nvim_get_current_win() })
  end,
})

nvim_create_autocmd("WinLeave", {
  callback = function()
    nvim_set_option_value("winhighlight", cursor_line_inactive, { win = nvim_get_current_win() })
  end,
})

nvim_create_autocmd("FileType", {
  pattern = { "help", "text", "man" },
  callback = function()
    nvim_set_option_value("statuscolumn", "", { win = 0 })
    nvim_set_option_value("number", true, { win = 0 })
  end,
})
