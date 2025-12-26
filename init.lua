local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

vim.env.LANG = "en_US.UTF-8"

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

-- SETTINGS --
vim.opt.guifont = { "JetBrainsMono Nerd Font:h11" }
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.shiftround = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wildmode = "longest,list:longest,full"
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf8"
vim.opt.pumheight = 10
-- vim.opt.switchbuf = "useopen,split"
vim.opt.switchbuf = "uselast,useopen"
vim.opt.magic = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.opt.backspace = "indent,eol,start"
vim.opt.shortmess = "aoOtTIcF"
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.gdefault = true
vim.opt.cindent = false -- check
vim.opt.cino:append("L0,g0,l1,t0,w1,(0,w4,(s,m1")
-- vim.opt.cino:append("L0,g0,l1,t0,w1,w4,m1")
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 100
vim.opt.updatetime = 50
vim.opt.guicursor = "n:block-Cursor,i-ci:block-iCursor,v:block-vCursor"
vim.opt.winborder = "single"
vim.opt.isfname:append("(") -- " @windows: nextjs and sveltkit folder name pattern
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.history = 20

vim.wo.signcolumn = "no"
vim.wo.relativenumber = true
vim.wo.wrap = false

vim.bo.autoread = true
vim.bo.copyindent = true
vim.bo.grepprg = "rg"

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

local esc_normal_mode = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
  vim.snippet.stop()
  vim.cmd.nohl()
  vim.cmd.normal({ "", bang = true })
end

vim.keymap.set("n", "<esc>", esc_normal_mode)

vim.keymap.set({ "i", "s" }, "<esc>", function()
  vim.snippet.stop()
  return "<esc>"
end, { expr = true })

vim.keymap.set("i", "<s-enter>", "<c-o>O") -- new line up
vim.keymap.set("i", "<c-enter>", "<c-o>o") -- new line down

vim.keymap.set({ "n", "v" }, "<c-s>", "<cmd>w!<cr><esc>") -- save file

vim.keymap.set("n", "Y", "yg$") -- yank to end of line considering line wrap

vim.keymap.set({ "n", "v" }, "<PageUp>", "<c-u>zzzz", { noremap = true }) -- page up
vim.keymap.set({ "n", "v" }, "<PageDown>", "<c-d>zzzz", { noremap = true }) -- page down

vim.keymap.set("i", "<PageUp>", "<nop>", { noremap = true }) -- page up
vim.keymap.set("i", "<PageDown>", "<nop>", { noremap = true }) -- page down

vim.keymap.set("n", "\\", "<cmd>clo<cr>") -- close current window
vim.keymap.set("n", "|", "<cmd>vs<cr>") -- split vertical window
-- vim.keymap.set("n", "-", "<cmd>sp<cr>") -- split horizontal window
vim.keymap.set("n", "_", "<cmd>sp<cr>") -- split horizontal window
vim.keymap.set("n", "<c-9>", "<c-w>o") -- close other windows
vim.keymap.set("n", "<c-8>", "<c-w>r") -- rotate windows

-- resize windows
vim.keymap.set("n", "<c-=>", "<cmd>wincmd =<cr>") -- resize all windows
-- vim.keymap.set("n", "<leader>=", "<cmd>wincmd =<cr>")

vim.keymap.set("n", "<a-6>", [[<cmd>vertical   resize +2<cr>]]) -- make the window biger   vertically
vim.keymap.set("n", "<a-4>", [[<cmd>vertical   resize -2<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "<a-8>", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger  horizontally
vim.keymap.set("n", "<a-5>", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally

vim.keymap.set("n", "<left>", "<cmd>wincmd h<cr>") -- move to window left
vim.keymap.set("n", "<down>", "<cmd>wincmd j<cr>") -- move to window down
vim.keymap.set("n", "<up>", "<cmd>wincmd k<cr>") -- move to window up
vim.keymap.set("n", "<right>", "<cmd>wincmd l<cr>") -- move to window right

vim.keymap.set({ "i", "c" }, "<c-v>", [[<c-r>+]]) -- paste to command line mode

vim.keymap.set("v", "v", "V") -- visual line mode

vim.keymap.set("c", "<c-bs>", "<c-w>") -- delete previous word (cmd)

vim.keymap.set("n", "x", '"_x') -- delete current char without copying
vim.keymap.set("n", "<c-d>", '"_dd') -- delete line without copying
vim.keymap.set("v", "x", '"_d') -- delete char in visual mode without copying
vim.keymap.set({ "n", "v" }, "c", '"_c') -- change verb without copying

vim.keymap.set("n", "dx", '"_d') -- delete without copying to register @check working ok with default timeoutlen

vim.keymap.set("n", "*", [[<Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<cr>]]) -- highlight all occurencies of the current word
vim.keymap.set("v", "*", '"sy/\\V<c-r>s<cr>``') -- highlight all occurencies of the curren selection

vim.keymap.set({ "n", "i" }, "<c-;>", function()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local len = vim.fn.col("$") - 1
  vim.api.nvim_buf_set_text(0, row, len, row, len, { ";" })
end)

-- go to beginning of the line function like DOOM Emacs
local beginning_of_the_line = function()
  local old_pos = vim.fn.col(".")
  vim.fn.setpos(".", { 0, vim.fn.line("."), 0, 0 })
  vim.fn.execute("normal ^")
  if old_pos == vim.fn.col(".") then
    vim.fn.setpos(".", { 0, vim.fn.line("."), 0, 0 })
  end
end

vim.keymap.set("i", "<home>", beginning_of_the_line) -- go to beginning of the line
vim.keymap.set({ "n", "v" }, "(", beginning_of_the_line) -- go to beginning of the line
vim.keymap.set("n", ")", "$") -- go to end of line
vim.keymap.set("v", ")", "$h") -- go to end of line (for some reason it's goes to wrong place in visual mode)

vim.keymap.set("n", "<f4>", "<cmd>:e $MYVIMRC<cr>") -- open config file (vimrc or init.lua)
vim.keymap.set("n", "<f5>", "<cmd>so %<cr>") -- execute current file (vim or lua)
vim.keymap.set("n", "<f7>", "<cmd>:e ~/.config/ghostty/config<cr>") -- open ghostty config file (vimrc or init.lua)
vim.keymap.set("n", "<f11>", "<cmd>echo wordcount().words<cr>") -- execute current file (vim or lua)

-- duplicate line and lines
vim.keymap.set("n", "<c-c>", '"0yy"0p') -- duplicate line down
vim.keymap.set("v", "<c-c>", '"0y"0Pgv') -- like sublime duplicate line

-- duplicate and comment
vim.keymap.set("n", "<c-s-c>", function()
  vim.cmd([[norm "0yygc"0p]])
end)
vim.keymap.set("v", "<c-s-c>", function()
  vim.cmd([[norm gcgv"0y"0Pgvgc]])
end)

vim.keymap.set("n", "`", "<C-^>") -- back to last buffer

vim.keymap.set("n", "<f1>", "<cmd>Inspect<cr>") -- inspect current token treesitter
vim.keymap.set("n", "<f3>", "<cmd>InspectTree<cr>") -- inspect current token treesitter

-- when it's not in lsp
vim.keymap.set("n", "K", "<nop>")

-- -- add undo capabilities in insert mode
-- vim.keymap.set("i", "<space>", "<c-g>u<space>")
-- vim.keymap.set("i", "<enter>", "<c-g>u<enter>")
-- vim.keymap.set("i", "<tab>", "<c-g>u<tab>")
-- vim.keymap.set("i", "<bs>", "<c-g>u<bs>")
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

vim.keymap.set("n", "<c-i>", "<c-i>")

-- add mark after insert | <c-o> and <c-i>
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function(_)
    vim.cmd("normal! m'")
  end,
})

-- close quickfix menu after selecting choice
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf" },
  callback = function()
    vim.keymap.set("n", "<cr>", "<cr><cmd>cclose<cr>", { buffer = true })
    vim.keymap.set("n", "q", "<cmd>cclose<cr>", { buffer = true })
    vim.keymap.set("n", "<c-w>", "<cmd>cclose<cr>", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  command = "silent! checktime",
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  pattern = "*",
  command = "silent! redrawtabline",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "css",
    "javascript",
    "json",
    "typescript",
    "typescriptreact",
  },
  callback = function()
    if not vim.g.editorconfig then
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
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
  },
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
  end,
})

vim.keymap.set("n", "<", "<<", { nowait = true, remap = true }) -- indent left
vim.keymap.set("n", ">", ">>", { nowait = true, remap = true }) -- indent right

-- movements with timeout
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  pattern = "*",
  callback = function()
    vim.keymap.set({ "n", "v", "x" }, "[", function()
      vim.diagnostic.jump({ count = -1, float = false })
    end, { nowait = true, buffer = true }) -- paragraph up
    vim.keymap.set({ "n", "v", "x" }, "]", function()
      vim.diagnostic.jump({ count = 1, float = false })
    end, { nowait = true, buffer = true }) -- paragraph up
    -- move indentation
    vim.keymap.set({ "v", "x" }, "<", "<gv", { nowait = true, buffer = true, remap = true }) -- indent left in visual mode
    vim.keymap.set({ "v", "x" }, ">", ">gv", { nowait = true, buffer = true, remap = true }) -- indent right in visual mode
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "VisualYank", timeout = 200 })
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

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "elixir", "heex", "eex" },
--   callback = function()
--     vim.bo.cindent = false
--   end,
-- })

if vim.g.neovide then
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
local started_godot_server = false

-- paths to check for project.godot file
local paths_to_check = { "/", "/../" }
local godot_project_path = ""
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for _, value in pairs(paths_to_check) do
  if vim.uv.fs_stat(cwd .. value .. "project.godot") then
    godot_project_path = cwd .. value
    break
  end
end

local is_server_running = vim.uv.fs_stat(godot_project_path .. "/server.pipe")

local addr = godot_project_path .. "/server.pipe"
if vim.fn.has("win32") == 1 then
  addr = "127.0.0.1:6004"
end

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
-- GODOT END

vim.diagnostic.config({
  virtual_text = {
    prefix = "",
  },
  float = {
    show_header = false,
  },
  jump = {
    on_jump = function() end,
  },
  signs = {
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticLinehlError",
      [vim.diagnostic.severity.WARN] = "DiagnosticLinehlWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticLinehlInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticLinehlHint",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticNumhlError",
      [vim.diagnostic.severity.WARN] = "DiagnosticNumhlWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticNumhlInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticNumhlHint",
    },
  },
})
