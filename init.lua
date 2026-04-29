local g = vim.g
local cmd = vim.cmd
local opt = vim.opt
local wo = vim.wo
local fn = vim.fn

local keymap_set = vim.keymap.set
local resize = cmd.resize
local wincmd = cmd.wincmd
local normal = cmd.normal

local checktime = cmd.checktime
local nohl = cmd.nohl

local nvim_set_option_value = vim.api.nvim_set_option_value
local nvim_set_hl = vim.api.nvim_set_hl
local nvim_win_get_cursor = vim.api.nvim_win_get_cursor
local nvim_list_wins = vim.api.nvim_list_wins
local nvim_win_get_config = vim.api.nvim_win_get_config
local nvim_win_close = vim.api.nvim_win_close
local nvim_create_autocmd = vim.api.nvim_create_autocmd

local snippet_stop = vim.snippet.stop

local diag_jump = vim.diagnostic.jump
local winsaveview = fn.winsaveview
local winrestview = fn.winrestview

local comment = require("vim._comment")

vim.env.LANG = "en_US.UTF-8"

-- SETTINGS --
opt.guifont = { "JetBrainsMono NF:h11" }
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.smartcase = true
opt.ignorecase = true
opt.shiftround = true
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"
opt.pumheight = 10
opt.switchbuf = "useopen,uselast"
opt.shortmess:append("aoOtTIcF")
opt.cursorline = true
opt.cino:append("L0,g0,l1,t0,w1,(0,w4,(s,m1")
opt.winborder = "rounded"
opt.isfname:append("(") -- " @windows: nextjs and sveltekit folder name pattern
opt.swapfile = false
opt.wrap = false
opt.timeout = false

wo.signcolumn = "no"
wo.relativenumber = true

opt.linespace = 5

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
  cmd.undo({ mods = { silent = true } })
  cmd.redrawstatus()
end)

keymap_set("n", "<C-r>", function()
  cmd.redo({ mods = { silent = true } })
  cmd.redrawstatus()
end)

keymap_set("v", "v", "V", { noremap = true }) -- visual line mode

keymap_set("c", "<c-bs>", "<c-w>") -- delete previous word (cmd)

keymap_set("n", "x", '"_x') -- delete current char without copying
keymap_set("n", "<c-d>", '"_dd') -- delete line without copying
keymap_set("v", "x", '"_d') -- delete char in visual mode without copying
keymap_set({ "n", "v" }, "c", '"_c') -- change verb without copying

keymap_set("n", "dx", '"_d') -- delete without copying to register @check working ok with default timeoutlen

keymap_set("n", "*", function()
  fn.setreg("/", "\\<" .. fn.expand("<cword>") .. "\\>")
  opt.hlsearch = true
end)
keymap_set("v", "*", '"sy/\\V<c-r>s<cr>``') -- highlight all occurencies of the curren selection

-- go to beginning of the line function like DOOM Emacs
local function beginning_of_the_line()
  local old_pos = fn.col(".")
  normal("^")
  if old_pos == fn.col(".") then
    fn.setpos(".", { 0, fn.line("."), 0, 0 })
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
  cmd.edit("$MYVIMRC")
end) -- open config file (vimrc or init.lua)
keymap_set("n", "<f5>", function()
  cmd.source("%")
end) -- execute current file (vim or lua)
keymap_set("n", "<f8>", function()
  cmd.edit("~/.config/ghostty/config")
end) -- open ghostty config file (vimrc or init.lua)
keymap_set("n", "<f11>", function()
  vim.notify("Words: " .. fn.wordcount().words)
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
keymap_set("n", "<c-s-x>", cmd.bdelete) -- close current buffer and window -- not work with ghostty (combination in use)

-- close quickfix menu after selecting choice
nvim_create_autocmd("FileType", {
  pattern = { "qf" },
  callback = function()
    local function enter_and_close()
      cmd.cc(fn.line("."))
      cmd.cclose()
    end
    keymap_set("n", "<cr>", enter_and_close, { buffer = true })
    keymap_set("n", "o", enter_and_close, { buffer = true })
    keymap_set("n", "q", cmd.cclose, { buffer = true })
    keymap_set("n", "<esc>", cmd.cclose, { buffer = true })
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

keymap_set({ "n", "v", "x" }, "[", function()
  diag_jump({ count = -1, float = false })
end, { nowait = true })

keymap_set({ "n", "v", "x" }, "]", function()
  diag_jump({ count = 1, float = false })
end, { nowait = true })

keymap_set({ "v", "x" }, "<", function()
  normal({ "<gv", bang = true })
end, { nowait = true })

keymap_set({ "v", "x" }, ">", function()
  normal({ ">gv", bang = true })
end, { nowait = true })

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
  local v = vim.v
  local godot_project_path = ""

  local paths_to_check = { "/", "/../" }
  local cwd = fn.getcwd()
  local fs_stat = vim.uv.fs_stat

  -- iterate over paths and check
  for i = 1, #paths_to_check do
    local value = paths_to_check[i]
    if fs_stat(cwd .. value .. "project.godot") then
      godot_project_path = cwd .. value
      break
    end
  end

  if godot_project_path ~= "" then
    local is_server_running = fs_stat(godot_project_path .. "/server.pipe")

    local addr = godot_project_path .. "/server.pipe"
    if fn.has("win32") == 1 then
      addr = "127.0.0.1:6004"
    end

    local started_godot_server = false
    if fn.filereadable(cwd .. "/project.godot") == 1 and not is_server_running then
      if v.servername ~= addr then
        local ok = pcall(function()
          fn.serverstart(addr)
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
            fn.serverstop(addr)
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
