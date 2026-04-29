vim.env.LANG = "en_US.UTF-8"

-- SETTINGS --
vim.opt.guifont = { "JetBrainsMono NF:h11" }
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.shiftround = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.pumheight = 10
vim.opt.switchbuf = "useopen,uselast"
vim.opt.inccommand = "nosplit"
vim.opt.backspace = "indent,eol,start"
vim.opt.shortmess:append("aoOtTIcF")
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.cursorline = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.cindent = false -- check
vim.opt.cino:append("L0,g0,l1,t0,w1,(0,w4,(s,m1")
vim.opt.winborder = "rounded"
vim.opt.isfname:append("(") -- " @windows: nextjs and sveltekit folder name pattern
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.history = 20
-- vim.opt.timeout = false
vim.opt.timeoutlen = 200
vim.opt.autoread = true
-- vim.opt.incsearch = false

vim.wo.signcolumn = "no"
vim.wo.relativenumber = true
vim.wo.wrap = false

vim.opt.linespace = 5
vim.opt.cmdheight = 1
vim.opt.showcmdloc = "statusline"

-- work around on python default configs
vim.g.python_indent = {
  disable_parentheses_indenting = false,
  closed_paren_align_last_line = false,
  searchpair_timeout = 150,
  continue = 4,
  open_paren = 4,
  nested_paren = 4,
}

-- MAPPING --

local function esc_normal_mode()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == "win" or config.relative == "laststatus" then
      vim.api.nvim_win_close(win, false)
    end
  end
  vim.snippet.stop()
  vim.cmd.nohl()
  vim.cmd.normal({ "", bang = true })
end

vim.keymap.set("n", "<esc>", esc_normal_mode)

pcall(vim.keymap.del, "n", "gcc")
vim.keymap.set("n", "gc", function()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  require("vim._comment").toggle_lines(row, row)
end, { noremap = true, silent = true })

vim.keymap.set({ "i", "s" }, "<esc>", function()
  vim.snippet.stop()
  return "<esc>"
end, { expr = true })

-- vim.keymap.set("i", "<s-enter>", "<c-o>O") -- new line up
-- vim.keymap.set("i", "<c-enter>", "<c-o>o") -- new line down

vim.keymap.set({ "n", "v" }, "<s-s>", function()
  vim.cmd.write({ bang = true, mods = { silent = true } })
end) -- save file

vim.keymap.set("n", "\\", vim.cmd.close) -- close current window
vim.keymap.set("n", "|", vim.cmd.vsplit) -- split vertical window
vim.keymap.set("n", "_", vim.cmd.split) -- split horizontal window
vim.keymap.set("n", "<c-9>", "<c-w>o") -- close other windows
vim.keymap.set("n", "<c-8>", "<c-w>r") -- rotate windows

-- resize windows
vim.keymap.set("n", "<c-=>", function()
  vim.cmd.wincmd({ "=", mods = { silent = true } })
end) -- resize all windows

vim.keymap.set("n", "<c-6>", function()
  vim.cmd.resize({ "+2", mods = { vertical = true } })
end) -- make the window biger   vertically
vim.keymap.set("n", "<c-4>", function()
  vim.cmd.resize({ "-2", mods = { vertical = true } })
end) -- make the window smaller vertically
vim.keymap.set("n", "<c-8>", function()
  vim.cmd.resize({ "+2", mods = { horizontal = true } })
end) -- make the window bigger  horizontally
vim.keymap.set("n", "<c-5>", function()
  vim.cmd.resize({ "-2", mods = { horizontal = true } })
end) -- make the window smaller horizontally

local function wincmd(dir)
  vim.cmd.wincmd({ dir, mods = { silent = true } })
end

vim.keymap.set("n", "<left>", function()
  wincmd("h")
end) -- move to window left
vim.keymap.set("n", "<down>", function()
  wincmd("j")
end) -- move to window down
vim.keymap.set("n", "<up>", function()
  wincmd("k")
end) -- move to window up
vim.keymap.set("n", "<right>", function()
  wincmd("l")
end) -- move to window right

vim.keymap.set("n", "<cr>", "<nop>")

vim.keymap.set("n", "Y", "yg$") -- yank to end of line considering line wrap

vim.keymap.set({ "n", "v" }, "<PageUp>", "<c-u>zzzz", { noremap = true }) -- page up
vim.keymap.set({ "n", "v" }, "<PageDown>", "<c-d>zzzz", { noremap = true }) -- page down

vim.keymap.set("i", "<PageUp>", "<nop>", { noremap = true }) -- page up
vim.keymap.set("i", "<PageDown>", "<nop>", { noremap = true }) -- page down

vim.keymap.set({ "i", "c" }, "<c-v>", [[<c-r>+]]) -- paste to command line mode

vim.keymap.set("n", "u", function()
  vim.cmd.undo({ mods = { silent = true } })
  vim.cmd.redrawstatus()
end)

vim.keymap.set("n", "<C-r>", function()
  vim.cmd.redo({ mods = { silent = true } })
  vim.cmd.redrawstatus()
end)

vim.keymap.set("v", "v", "V", { noremap = true }) -- visual line mode

vim.keymap.set("c", "<c-bs>", "<c-w>") -- delete previous word (cmd)

vim.keymap.set("n", "x", '"_x') -- delete current char without copying
vim.keymap.set("n", "<c-d>", '"_dd') -- delete line without copying
vim.keymap.set("v", "x", '"_d') -- delete char in visual mode without copying
vim.keymap.set({ "n", "v" }, "c", '"_c') -- change verb without copying

vim.keymap.set("n", "dx", '"_d') -- delete without copying to register @check working ok with default timeoutlen

vim.keymap.set("n", "*", function()
  vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
  vim.opt.hlsearch = true
end)
vim.keymap.set("v", "*", '"sy/\\V<c-r>s<cr>``') -- highlight all occurencies of the curren selection

-- go to beginning of the line function like DOOM Emacs
local function beginning_of_the_line()
  local old_pos = vim.fn.col(".")
  vim.cmd.normal("^")
  if old_pos == vim.fn.col(".") then
    vim.fn.setpos(".", { 0, vim.fn.line("."), 0, 0 })
  end
end

vim.keymap.set("i", "<home>", beginning_of_the_line) -- go to beginning of the line
vim.keymap.set({ "n", "v" }, "(", beginning_of_the_line) -- go to beginning of the line
vim.keymap.set("n", ")", "$") -- go to end of line
vim.keymap.set("v", ")", "$h") -- go to end of line (for some reason it's goes to wrong place in visual mode)

-- duplicate line and lines
vim.keymap.set("n", "<c-c>", function()
  vim.cmd.normal('"0yy"0p')
end) -- duplicate line down
vim.keymap.set("v", "<c-c>", function()
  vim.cmd.normal('"0y"0Pgv')
end) -- like sublime duplicate line

-- duplicate and comment
vim.keymap.set("n", "<c-s-c>", function()
  vim.cmd.normal('0yygc"0p')
end)
vim.keymap.set("v", "<c-s-c>", function()
  vim.cmd.normal('gcgv"0y"0Pgvgc')
end)

vim.keymap.set("n", "<f4>", function()
  vim.cmd.edit("$MYVIMRC")
end) -- open config file (vimrc or init.lua)
vim.keymap.set("n", "<f5>", function()
  vim.cmd.source("%")
end) -- execute current file (vim or lua)
vim.keymap.set("n", "<f8>", function()
  vim.cmd.edit("~/.config/ghostty/config")
end) -- open ghostty config file (vimrc or init.lua)
vim.keymap.set("n", "<f11>", function()
  vim.notify("Words: " .. vim.fn.wordcount().words)
end) -- Count words of the current buffer

vim.keymap.set("n", "`", "<C-^>") -- back to last buffer

vim.keymap.set("n", "<f1>", vim.cmd.Inspect) -- inspect current token treesitter
vim.keymap.set("n", "<f3>", vim.cmd.InspectTree) -- inspect current token treesitter

-- when it's not in lsp
vim.keymap.set("n", "K", "<nop>")

-- -- add undo capabilities in insert mode
-- vim.keymap.set("i", "<space>", "<c-g>u<space>")
-- vim.keymap.set("i", "<enter>", "<c-g>u<enter>")
-- vim.keymap.set("i", "<tab>", "<c-g>u<tab>")
-- vim.keymap.set("i", "<bs>", "<c-g>u<bs>")
-- vim.keymap.set("i", "<c-bs>", "<c-g>u<c-bs>")
-- vim.keymap.set("i", "[", "[<c-g>u")
-- vim.keymap.set("i", "{", "{<c-g>u")
-- vim.keymap.set("i", "(", "(<c-g>u")
-- vim.keymap.set("i", "]", "]<c-g>u")
-- vim.keymap.set("i", "}", "}<c-g>u")
-- vim.keymap.set("i", ")", ")<c-g>u")
-- vim.keymap.set("i", ",", ",<c-g>u")
-- vim.keymap.set("i", ".", ".<c-g>u")

-- visual mode - paste without copying
vim.keymap.set({ "v", "x" }, "p", "P")

-- Open mini.pick buffer selection if not do this.
vim.keymap.set("n", "<c-i>", "<c-i>")

-- closes the current window and buffer
-- to close the current buffer and not the window use <c-w>
vim.keymap.set("n", "<c-s-x>", vim.cmd.bdelete()) -- close current buffer and window -- not work with ghostty (combination in use)

-- close quickfix menu after selecting choice
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf" },
  callback = function()
    local function enter_and_close()
      vim.cmd.cc(vim.fn.line("."))
      vim.cmd.cclose()
    end
    vim.keymap.set("n", "<cr>", enter_and_close, { buffer = true })
    vim.keymap.set("n", "o", enter_and_close, { buffer = true })
    vim.keymap.set("n", "q", vim.cmd.cclose, { buffer = true })
    vim.keymap.set("n", "<esc>", vim.cmd.cclose, { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    vim.cmd.checktime({ mods = { silent = true } })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "css",
    "javascript",
    "json",
    "typescript",
    "typescriptreact",
  },
  callback = function(args)
    if not vim.g.editorconfig then
      vim.api.nvim_set_option_value("shiftwidth", 2, { buf = args.buf })
      vim.api.nvim_set_option_value("tabstop", 2, { buf = args.buf })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
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
    vim.api.nvim_set_option_value("shiftwidth", 2, { buf = args.buf })
    vim.api.nvim_set_option_value("tabstop", 2, { buf = args.buf })
  end,
})

vim.keymap.set("n", "<", "<<", { nowait = true, remap = true }) -- indent left
vim.keymap.set("n", ">", ">>", { nowait = true, remap = true }) -- indent right

local cow = require("close_other_window")
vim.keymap.set({ "n", "v" }, "<c-left>", cow.left)
vim.keymap.set({ "n", "v" }, "<c-down>", cow.down)
vim.keymap.set({ "n", "v" }, "<c-up>", cow.up)
vim.keymap.set({ "n", "v" }, "<c-right>", cow.right)

local sb = require("swap_buffer")
vim.keymap.set({ "n", "v" }, "<s-left>", sb.left)
vim.keymap.set({ "n", "v" }, "<s-down>", sb.down)
vim.keymap.set({ "n", "v" }, "<s-up>", sb.up)
vim.keymap.set({ "n", "v" }, "<s-right>", sb.right)

-- movements with timeout
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  pattern = "*",
  callback = function()
    vim.keymap.set({ "n", "v", "x" }, "[", function()
      vim.diagnostic.jump({ count = -1, float = false })
    end, { nowait = true, buffer = true }) -- previous diagnostic
    vim.keymap.set({ "n", "v", "x" }, "]", function()
      vim.diagnostic.jump({ count = 1, float = false })
    end, { nowait = true, buffer = true }) -- next diagnostic

    -- move indentation
    vim.keymap.set({ "v", "x" }, "<", function()
      vim.cmd.normal({ "<gv", bang = true })
    end, { nowait = true, buffer = true })

    vim.keymap.set({ "v", "x" }, ">", function()
      vim.cmd.normal({ ">gv", bang = true })
    end, { nowait = true, buffer = true })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    local yank = vim.v.event
    if yank.operator ~= "y" then
      return
    end

    local pos1, pos2 = vim.fn.getpos("'["), vim.fn.getpos("']")
    local region_list = vim.fn.getregionpos(pos1, pos2, { type = yank.regtype, eol = true })

    local positions = {}
    for _, region in ipairs(region_list) do
      local srow, scol, ecol = region[1][2], region[1][3], region[2][3]
      positions[#positions + 1] = { srow, scol, ecol - scol + 1 }
    end

    local win = vim.api.nvim_get_current_win()
    local id = vim.fn.matchaddpos("VisualYank", positions, 999) --[[@as integer]]

    vim.defer_fn(function()
      pcall(vim.fn.matchdelete, id, win)
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

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s+$//e]])
    vim.fn.winrestview(save)
  end,
})

if vim.g.neovide then
  vim.g.neovide_input_ime = false
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0.0
  vim.g.neovide_position_animation_length = 0.0
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_in_command_line = false
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
      if vim.v.servername ~= addr then
        local ok = pcall(function()
          vim.fn.serverstart(addr)
        end)

        if ok then
          started_godot_server = true
        end
      end
    end

    vim.api.nvim_create_autocmd("VimLeavePre", {
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

-- vim.api.nvim_set_hl(0, "@attribute.gdscript", { fg = "#9B668F" })
vim.api.nvim_set_hl(0, "@attribute.gdscript", { fg = "#96674E" })
-- vim.api.nvim_set_hl(0, "@string.special.url.gdscript", { fg = "#926C83" })
vim.api.nvim_set_hl(0, "@string.special.url.gdscript", { fg = "#9B668F" })

vim.api.nvim_set_hl(0, "DiagnosticLineNumhlError", { fg = "#a1495c", bg = "#221418" })
vim.api.nvim_set_hl(0, "DiagnosticLineNumhlWarn", { fg = "#a1495c", bg = "#221c12" })
vim.api.nvim_set_hl(0, "DiagnosticLineNumhlInfo", { fg = "#a1495c", bg = "#1c1a1c" })
vim.api.nvim_set_hl(0, "DiagnosticLineNumhlHint", { fg = "#a1495c", bg = "#1a1a1a" })

vim.api.nvim_set_hl(0, "CursorVisualNr", { fg = "#a1495c", bg = "#2d1524" })
vim.api.nvim_set_hl(0, "VisualNr", { fg = "#493441", bg = "#2d1524" })
vim.o.statuscolumn = "%!v:lua.StatusColumn()"

---@type table<integer?, table<string, boolean|integer>>
local visual_state = {}

local function update_visual_cursor(buf)
  local cursor_start = vim.fn.line("v")
  local cursor_end = vim.fn.line(".")
  if cursor_start > cursor_end then
    cursor_start, cursor_end = cursor_end, cursor_start
  end

  visual_state[buf].visual_start = cursor_start
  visual_state[buf].visual_end = cursor_end
end

vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function(ev)
    local m = vim.api.nvim_get_mode().mode
    local in_visual = m == "v" or m == "V" or m == "\x16"

    visual_state[ev.buf] = {
      in_visual = in_visual,
    }

    if in_visual then
      update_visual_cursor(ev.buf)
    end
  end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function(ev)
    local state = visual_state[ev.buf]
    if not state or not state.in_visual then
      return
    end

    update_visual_cursor(ev.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  callback = function(ev)
    visual_state[ev.buf] = nil
  end,
})

function _G.StatusColumn()
  local hl = " "
  local relnum = vim.v.relnum
  local win = vim.g.statusline_winid
  local state = visual_state[vim.api.nvim_win_get_buf(win)]

  if state and state.in_visual and win == vim.api.nvim_get_current_win() then
    if relnum == 0 then
      hl = "%#CursorVisualNr# "
    else
      local lnum = vim.v.lnum
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
  local state = visual_state[vim.api.nvim_get_current_buf()]
  if not state then
    return
  end

  local vstart = state.visual_start
  local vend = state.visual_end
  if
    direction == move_direction_down and vend >= vim.fn.line("$") or direction == move_direction_up and vstart <= 1
  then
    return
  end

  vim.cmd.normal({ "\27", bang = true })
  vim.cmd(string.format("%d,%dm %d", vstart, vend, direction == move_direction_down and vend + 1 or vstart - 2))
  vim.cmd.normal({ "gv=gv", bang = true })
end

vim.keymap.set("x", "<Down>", function()
  move_lines(move_direction_down)
end, { silent = true })
vim.keymap.set("x", "<Up>", function()
  move_lines(move_direction_up)
end, { silent = true })

local _select = require("vim.treesitter._select")
---@type { [1]:integer, [2]:integer, [3]:integer, [4]:integer }[]
local stack = {}

local function decrement_selection()
  local m = vim.api.nvim_get_mode().mode
  if not (m == "v" or m == "V" or m == "\x16") then
    return
  end

  local range = stack[#stack]
  stack[#stack] = nil

  if #stack == 0 then
    vim.api.nvim_feedkeys("\27", "nx", true)
    if range ~= nil then
      vim.api.nvim_win_set_cursor(0, { range[1] + 1, range[2] })
    end
    return
  end

  vim.cmd.normal({ "v\27", bang = true })
  vim.fn.setpos("'<", { 0, range[1] + 1, range[2] + 1, 0 })
  vim.fn.setpos("'>", { 0, range[3] + 1, range[4], 0 })
  vim.cmd.normal({ "gv", bang = true })
end

local function increment_selection()
  if not vim.treesitter.get_parser(nil, nil, { error = false }) then
    return
  end

  if vim.api.nvim_get_mode().mode ~= "v" then
    stack = {}
  end

  local vline, vcol = vim.fn.line("v"), vim.fn.col("v")
  local cline, ccol = vim.fn.line("."), vim.fn.col(".")

  stack[#stack + 1] = { vline - 1, vcol - 1, cline - 1, ccol }
  _select.select_parent(vim.v.count1)
end

vim.keymap.set({ "n", "v", "o" }, "M", decrement_selection, { noremap = true })
vim.keymap.set({ "n", "x", "o" }, "m", increment_selection, { noremap = true })
vim.keymap.set("x", "<Esc>", function()
  stack = {}
  return "<esc>"
end, { expr = true })

-- Better highlight
-- https://coolors.co/gradient-palette/291c28-1e141d?number=7
vim.api.nvim_set_hl(0, "CursorHidden", { blend = 100, bg = "#121112" })
vim.api.nvim_set_hl(0, "CursorLineInative", { bg = "#20151F" })
vim.api.nvim_set_hl(0, "CursorLineNrInative", { fg = "#a1495c", bg = "#20151F" })

local guicursor_default = "n:block-Cursor,i-ci-c:block-iCursor,v:block-vCursor"
local guicursor_hidden = "n:block-Cursor,i-ci-c:block-iCursor,v:block-vCursor,a:CursorHidden/lCursorHidden"
local cursor_line_active = "CursorLine:CursorLine,CursorLineNr:CursorLineNr"
local cursor_line_inactive = "CursorLine:CursorLineInative,CursorLineNr:CursorLineNrInative"

-- highlights = {
--   visible = {
--     default = "",
--     modified = "",
--   },
--   focused = {
--     default = "",
--     modified = "",
--   },
--   diagnostics = {
--     error = {
--       visible = { default = "", modified = "" },
--       focused = { default = "", modified = "" },
--     },
--     warn = {
--       visible = { default = "", modified = "" },
--       focused = { default = "", modified = "" },
--     },
--   },
-- }

vim.api.nvim_set_option_value("guicursor", guicursor_default, {})

local ignore_file_types = { NvimTree = true }
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if ignore_file_types[vim.bo.filetype] then
      vim.api.nvim_set_option_value("guicursor", guicursor_hidden, {})
    else
      vim.api.nvim_set_option_value("guicursor", guicursor_default, {})
    end
  end,
})

local cmdline_active = false
vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    if ignore_file_types[vim.bo.filetype] then
      cmdline_active = true
      vim.schedule(function()
        if cmdline_active then
          vim.api.nvim_set_option_value("guicursor", guicursor_default, {})
          vim.cmd.redraw()
        end
      end)
      return
    end
    vim.cmd.redraw()
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    cmdline_active = false
    if ignore_file_types[vim.bo.filetype] then
      vim.api.nvim_set_option_value("guicursor", guicursor_hidden, {})
    end
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    vim.api.nvim_set_option_value("winhighlight", cursor_line_active, { win = vim.api.nvim_get_current_win() })
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    vim.api.nvim_set_option_value("winhighlight", cursor_line_inactive, { win = vim.api.nvim_get_current_win() })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "text", "man" },
  callback = function()
    vim.api.nvim_set_option_value("statuscolumn", "", { win = 0 })
    vim.api.nvim_set_option_value("number", true, { win = 0 })
  end,
})
