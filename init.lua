local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
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

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

-- SETTINGS --

-- vim.opt.guifont = { "JetBrains Mono:h12" }
vim.opt.guifont = { "JetBrains Mono:h11" }
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
vim.opt.termguicolors = true
vim.opt.wildmode = "longest,list:longest,full"
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf8"
vim.opt.pumheight = 10
vim.opt.switchbuf = "useopen,split"
vim.opt.magic = true
vim.opt.lazyredraw = true
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
vim.opt.cindent = true
vim.opt.cino:append("L0,g0,l1,t0,w1,(0,w4,(s,m1")
-- vim.opt.timeoutlen = 200 -- @check why I'm using that timeoutlen (maybe jk kj escaping thing)
vim.opt.updatetime = 100
vim.opt.guicursor = "i-ci:block-iCursor"
vim.opt.guicursor = "n:block-Cursor,i-ci:block-iCursor,v:block-vCursor"

vim.opt.cmdheight = 0
vim.opt.laststatus = 2
vim.opt.showcmdloc = "statusline"

vim.wo.signcolumn = "no"
vim.wo.relativenumber = true
-- vim.wo.number = true
vim.wo.wrap = false

vim.bo.autoread = true
vim.bo.copyindent = true
vim.bo.grepprg = "rg"
vim.bo.swapfile = false

vim.g.user_emmet_install_global = 0

-- work around on python default configs
-- check why in the other project indents are a complete mess
-- vim.g.python_indent = {
--   disable_parentheses_indenting = false,
--   closed_paren_align_last_line = false,
--   searchpair_timeout = 150,
--   continue = 4,
--   open_paren = 4,
--   nested_paren = 4,
-- }

-- MAPPING --

-- vim.keymap.set("n", "<leader><leader>", "<cmd>nohl<cr><esc>")
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr><esc>", { silent = true }) -- nohighlight

vim.keymap.set({ "n", "v" }, "<c-enter>", "<cmd>w!<CR><esc>", { silent = true }) -- save file

vim.keymap.set("n", "Y", "yg$") -- yank to end of line considering line wrap

vim.keymap.set("n", "<c-i>", "<c-i>zz") -- center <c-i>
vim.keymap.set("n", "<c-o>", "<c-o>zz") -- center <c-o>

vim.keymap.set({ "n", "v" }, "H", "<c-u>zz", { noremap = true }) -- page up
vim.keymap.set({ "n", "v" }, "L", "<c-d>zz", { noremap = true }) -- page down

vim.keymap.set("n", "\\", "<cmd>clo<cr>", { silent = true }) -- close current window
vim.keymap.set("n", "|", "<cmd>vs<cr>", { silent = true }) -- split vertical window
vim.keymap.set("n", "-", "<cmd>sp<cr>", { silent = true }) -- split horizontal window
vim.keymap.set("n", "<c-9>", "<c-w>o") -- close other windows
vim.keymap.set("n", "<c-8>", "<c-w>r") -- rotate windows

-- closes the current window and buffer
-- to close the current buffer <c-w> and not the window
vim.keymap.set("n", "<a-w>", "<cmd>bd<cr>", { silent = true }) -- close current buffer and window

-- resize windows
vim.keymap.set("n", "<c-0>", "<cmd>wincmd =<cr>", { silent = true }) -- resize all windows

vim.keymap.set("n", "<a-s-right>", [[<cmd>vertical   resize +2<cr>]], { silent = true }) -- make the window biger   vertically
vim.keymap.set("n", "<a-s-left>", [[<cmd>vertical   resize -2<cr>]], { silent = true }) -- make the window smaller vertically
vim.keymap.set("n", "<a-s-up>", [[<cmd>horizontal resize +2<cr>]], { silent = true }) -- make the window bigger  horizontally
vim.keymap.set("n", "<a-s-down>", [[<cmd>horizontal resize -2<cr>]], { silent = true }) -- make the window smaller horizontally

-- vim.keymap.set("n", "<leader>=", "<c-w>=")

vim.keymap.set({ "n", "v" }, "<left>", "<cmd>wincmd h<cr>", { silent = true }) -- move to window left
vim.keymap.set({ "n", "v" }, "<down>", "<cmd>wincmd j<cr>", { silent = true }) -- move to window down
vim.keymap.set({ "n", "v" }, "<up>", "<cmd>wincmd k<cr>", { silent = true }) -- move to window up
vim.keymap.set({ "n", "v" }, "<right>", "<cmd>wincmd l<cr>", { silent = true }) -- move to window right

vim.keymap.set("c", "<c-v>", "<c-r>*") -- paste to command line mode

vim.keymap.set("v", "v", "V") -- visual line mode

vim.keymap.set({ "i", "c" }, "<c-bs>", "<c-w>") -- delete previous word

vim.keymap.set("n", "x", '"_x') -- delete current char without copying
vim.keymap.set("n", "<c-d>", '"_dd') -- delete line without copying
vim.keymap.set("v", "x", '"_d') -- delete char in visual mode without copying
vim.keymap.set({ "n", "v" }, "c", '"_c') -- change verb without copying

vim.keymap.set("n", "dx", '"_d') -- delete without copying to register @check working ok with default timeoutlen

vim.keymap.set("n", "*", "*``") -- highlight all occurencies of the current word
vim.keymap.set("v", "*", '"sy/\\V<c-r>s<cr>``') -- highlight all occurencies of the curren selection

-- go to beginning of the line function like DOOM Emacs
local beginning_of_the_line = function()
  local old_pos = vim.fn.col(".")
  vim.fn.setpos(".", { 0, vim.fn.line("."), 0, 0 })
  vim.fn.execute("normal ^")
  if old_pos == vim.fn.col(".") then
    vim.fn.setpos(".", { 0, vim.fn.line("."), 0, 0 })
  end
end

vim.keymap.set({ "n", "v" }, "(", beginning_of_the_line) -- go to beginning of the line
vim.keymap.set("n", ")", "$") -- go to end of line
vim.keymap.set("v", ")", "$h") -- go to end of line (for some reason it's goes to wrong place in visual mode)

-- vim.keymap.set("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<f4>", "<cmd>:e $MYVIMRC<CR>", { silent = true }) -- open config file (vimrc or init.lua)
vim.keymap.set("n", "<f5>", "<cmd>so %<CR>", { silent = true }) -- execute current file (vim or lua)

-- duplicate line and lines
vim.keymap.set("n", "<c-p>", '"0yy"0P') -- duplicate line up
vim.keymap.set("n", "<c-n>", '"0yy"0p') -- duplicate line down

vim.keymap.set("v", "<c-p>", '"0y"0P') -- duplicate selection up
vim.keymap.set("v", "<c-n>", function()
  local init_pos = vim.fn.line("v")
  vim.cmd([[noautocmd normal! "0ygv]])
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "v", false)
  local end_pos = vim.fn.line(".")
  vim.fn.setpos(".", { 0, math.max(init_pos, end_pos), 0, 0 })
  local lines = vim.split(vim.fn.getreg("0"), "\n", { trimempty = true })
  vim.api.nvim_put(lines, "l", true, false)
  vim.cmd([[noautocmd normal! gv]])
end) -- duplicate selection down

vim.keymap.set("n", "_", "<C-^>") -- back to last buffer

vim.keymap.set("n", "<f3>", ":Inspect<CR>") -- inspect current token treesitter

-- move lines @note: the visual ones are bellow
vim.keymap.set("n", "<", "<<") -- indent left
vim.keymap.set("n", ">", ">>") -- indent right

vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  command = "silent! checktime",
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.svelte", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.html", "*.css", "*.lua" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    -- vim.opt_local.wrap = true
  end,
})

-- movements with timeout
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  pattern = "*",
  callback = function()
    -- move indentation
    vim.keymap.set("v", "<", "<gv", { nowait = true, buffer = true, remap = true }) -- indent left in visual mode
    vim.keymap.set("v", ">", ">gv", { nowait = true, buffer = true, remap = true }) -- indent right in visual mode
  end,
})

if vim.opt.cmdheight:get() == 0 then
  -- show macro recording
  vim.api.nvim_create_autocmd("RecordingEnter", {
    pattern = "*",
    callback = function()
      vim.opt_local.cmdheight = 1
    end,
  })

  vim.api.nvim_create_autocmd("RecordingLeave", {
    pattern = "*",
    callback = function()
      local timer = vim.loop.new_timer()
      timer:start(
        50,
        0,
        vim.schedule_wrap(function()
          vim.opt_local.cmdheight = 0
        end)
      )
    end,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = function()
      vim.schedule(function()
        vim.cmd("redraw")
      end)
    end,
  })
end

-- vimscript stuff
vim.cmd([[
language en_US
filetype on

" @windows: nextjs and sveltkit folder name pattern
set isfname+=(

" visual mode - paste without copying
vnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> p 'pgv"'.v:register.'y`>'

" delete trailing spaces
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

" no help
map <f1> <nop>

" highlight when yanking
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END

" @check if I'll used it without LSP
hi! ErrorBg   guibg=#351C1D
hi! WarningBg guibg=#3A2717
hi! InfoBg    guibg=#2B2627
hi! HintBg    guibg=#2B2627

" " @check: do we really need the number fg highlight?
hi! ErrorLineBg   guifg=#a23343 guibg=#351C1D
hi! WarningLineBg guifg=#AF7C55 guibg=#3A2717
hi! InfoLineBg    guifg=#A8899C guibg=#2B2627
hi! HintLineBg    guifg=#A98D92 guibg=#2B2627
hi! HintLineBg    guifg=#A98D92

" :h diagnostic-signs
sign define DiagnosticSignError text=E texthl=DiagnosticSignError linehl=ErrorBg   numhl=ErrorLineBg
sign define DiagnosticSignWarn  text=W texthl=DiagnosticSignWarn  linehl=WarningBg numhl=WarningLineBg
sign define DiagnosticSignInfo  text=I texthl=DiagnosticSignInfo  linehl=InforBg   numhl=InfoLineBg
sign define DiagnosticSignHint  text=H texthl=DiagnosticSignHint  linehl=HintBg    numhl=HintLineBg
sign define DiagnosticSignHint  text=H texthl=DiagnosticSignHint  numhl=HintLineBg
sign define DiagnosticSignHint  text=H numhl=HintLineBg

autocmd! BufNewFile,BufRead *.vs,*.fs,*.vert,*.frag set ft=glsl

" when autocomplete active it limit the height
set pumblend=15


" move lines
xnoremap K :<C-u>silent! '<,'>move-2<CR>gv=gv
xnoremap J :<C-u>silent! '<,'>move'>+<CR>gv=gv

" c indent
" autocmd BufWinEnter,BufEnter,BufRead *.c,*.cpp,*.h set cino=L0,g0,l1,t0,w1,(0,w4,(s,m1

autocmd BufWritePre *.templ lua vim.lsp.buf.format()

]])

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.0
  vim.opt.linespace = 2
end

-- windows terminal, works with others terminals
--
-- {
--     "command":
--     {
--         "action": "sendInput",
--         "input": "\u0017"
--     },
--     "keys": "ctrl+backspace"
-- },
--
-- 13 is the ascii code the 5u is control 2u is shift
-- {
--     "command":
--     {
--         "action": "sendInput",
--         "input": "\u001b[13;5u"
--     },
--     "keys": "ctrl+enter"
-- },
