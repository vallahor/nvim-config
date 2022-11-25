local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  use({ "nvim-lua/plenary.nvim" })
  use({ "nvim-telescope/telescope.nvim" })

  use { 'nvim-treesitter/playground' }
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  use({ "ggandor/lightspeed.nvim" })
  use({ "kdheepak/lazygit.nvim" })

  use({ "kyazdani42/nvim-tree.lua", tag = "nightly" })
  use({ 'numToStr/Comment.nvim' })

  use({ "tpope/vim-surround" })
  use({ "tpope/vim-repeat" })

  use({ "mg979/vim-visual-multi" })

  use({ "noib3/nvim-cokeline" })
  use({ "ojroques/nvim-bufdel" })

  use({ 'norcalli/nvim-colorizer.lua' })

  use({ 'kana/vim-arpeggio' })

  if packer_bootstrap then
    require("packer").sync()
  end
end)

-- SETTINGS --

local indent = 4

vim.opt.shiftwidth = indent
vim.opt.tabstop = indent
vim.opt.softtabstop = indent
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
vim.opt.shortmess = "aoOtTIc"
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.fsync = true
vim.opt.magic = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.gdefault = true
vim.opt.colorcolumn = "80"
-- vim.opt.cmdheight = 0
-- vim.opt.guicursor = "i-ci:block-iCursor" -- comment when using nvim-qt (new version)
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.opt.completeopt = { "menu", "noinsert", "menuone", "noselect" }
vim.opt.cindent = true
vim.opt.cino:append("L0,g0,l1,t0,w1,w4,(s,m1")

--
vim.o.timeoutlen = 250
-- vim.o.ttimeoutlen = 100

vim.wo.signcolumn = "no"
vim.wo.relativenumber = true
-- vim.wo.number = true
vim.wo.wrap = true

vim.bo.autoread = true
vim.bo.copyindent = true
vim.bo.grepprg = "rg"
vim.bo.swapfile = false

vim.g.VM_theme = "iceblue"
vim.g.VM_default_mappings = 0
vim.g.VM_custom_remaps = { ["-"] = "$" }
vim.g.VM_maps = {
  ["Reselect Last"] = "<c-s>",
  ["Find Under"] = "<c-u>",
  ["Find Subword Under"] = "<c-u>",
  ["Select All"] = "<c-s-u>",
  ["Add Cursor Down"] = "<m-j>",
  ["Add Cursor Up"] = "<m-k>",
  ["Switch Mode"] = "v",
  ["Align"] = "<c-a>",
  ["Find Next"] = "]",
  ["Find Prev"] = "[",
  ["Goto Next"] = "}",
  ["Goto Prev"] = "{",
  ["Skip Region"] = "=",
  ["Remove Region"] = "+",
  ["Add Cursor At Pos"] = "<enter>",
}

local ok, lightspeed = pcall(require, "lightspeed")
if ok then
  -- vim.g.lightspeed_no_default_keymaps = true
  lightspeed.setup({
    exit_after_idle_msecs = { unlabeled = 300, labeled = nil },
    --- s/x ---
    jump_to_unique_chars = { safety_timeout = 300 },
    ignore_case = true,
    repeat_ft_with_target_char = true,
  })
end

local ok, nvim_tree = pcall(require, "nvim-tree")
if  ok then
  nvim_tree.setup({
    renderer = {
      indent_markers = {
        enable = true,
        icons = {
          corner = "└ ",
          edge = "│ ",
          none = "  ",
        },
      },
      icons = {
        webdev_colors = false,
        show = {
          folder = true,
          file = false,
          folder_arrow = false,
        },
      },
    },
    git = {
      enable = false,
      ignore = false,
      timeout = 400,
    },
  })
end

local ok, nvim_comment = pcall(require, "Comment")
if ok then
  nvim_comment.setup({
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
      line = "<c-;>",
      block = "<c-/>",
    },
    opleader = {
      line = "<c-;>",
      block = "<c-/>",
    },
    mappings = {
      basic = true,
      extra = true,
    },
  })
end

local ok, bufdel = pcall(require, "bufdel")
if ok then
  bufdel.setup({
    next = "cycle",
    quit = false,
  })
end

local ok, telescope = pcall(require, "telescope")
if ok then
  local actions = require("telescope.actions")
  telescope.setup({
    defaults = {
      mappings = {
        n = {
          ["<c-p>"] = "move_selection_previous",
          ["<c-n>"] = "move_selection_next",
          ["jk"] = actions.close,
          ["kj"] = actions.close,
        },
        i = {
          ["<C-bs>"] = function()
            vim.api.nvim_input("<c-s-w>")
          end,
          ["<c-p>"] = "move_selection_previous",
          ["<c-n>"] = "move_selection_next",
          -- ["<esc>"] = actions.close,
          ["jk"] = actions.close,
          ["kj"] = actions.close,
        },
      },
      initial_mode = "insert",
      selection_strategy = "reset",
      path_display = { "absolute" },
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
  })
end

local ok, nvim_treesitter = pcall(require, "nvim-treesitter.configs")
if ok then
  nvim_treesitter.setup({
    ensure_installed = {
      "lua",
      "c",
      "cpp",
      "zig",
      "query",
      "python",
      "typescript",
      "javascript",
      "rust",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = false,
    },
  })

  require "nvim-treesitter.configs".setup({
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    },
  })

end

local ok, cokeline = pcall(require, "cokeline")
if ok then
  cokeline.setup({
    components = {
      {
        text = "   ",
      },
      {
        text = function(buffer)
          return buffer.filename .. " "
        end,
        style = function(buffer)
          return buffer.is_focused and "bold" or nil
        end,
      },
      {
        text = function(buffer)
          if buffer.is_modified then
            return "●"
          end
          return " "
        end,

      },
      {
        text = " ",
      },
    },
  })
end

require'colorizer'.setup()

-- MAPPING --

local map = vim.keymap.set

-- map("n", "<space>", "<nop>")

vim.g.mapleader = " "

map("n", "<esc>", "<cmd>nohl<cr><esc>")
map("n", "<c-j>", "<cmd>nohl<cr><esc>")
map("n", "<leader><leader>", "<cmd>nohl<cr><esc>")
-- map("c", "jk", "<c-c>")
-- map("c", "kj", "<c-c>")
map({"i", "v", "s", "x", "o", "l", "t"}, "<c-j>", "<esc>")
map({"i", "v", "s", "x", "o", "l", "t"}, "<c-k>", "<esc>")

map("n", "<c-g>", "<cmd>LazyGit<cr>")
map("n", "<leader>ft", "<cmd>NvimTreeToggle<cr>")
-- map("n", "<c-;>", "<cmd>NvimTreeFocus<cr>")

map("n", "<c-f>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<c-s>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")

map("c", "<c-v>", '<c-r>*')

map("v", "v", "V")

map({ "i", "c" }, "<c-bs>", "<c-w>")

map("n", "x", '"_x')
map("v", "x", '"_d')
map({ "n", "v" }, "c", '"_c')
map("v", "p", '"_dP')

map("n", "*", "*``")
map("v", "*", '"sy/\\V<c-r>s<cr>``')

map({ "n", "v" }, "<leader>0", "0")
map({ "n", "v" }, "-", "$")
map({ "n", "v" }, "0", "^")

map("n", "j", "v:count ? 'j^' : 'gj'", { expr = true })
map("n", "k", "v:count ? 'k^' : 'gk'", { expr = true })

map({ "n", "v" }, "<c-enter>", "<cmd>w!<CR><esc>")

-- map("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
map("n", "<f4>", "<cmd>:e $MYVIMRC<CR>")
map("n", "<f5>", "<cmd>so %<CR>")

map({ "n", "v" }, "<leader>h", "<c-w>h")
map({ "n", "v" }, "<leader>j", "<c-w>j")
map({ "n", "v" }, "<leader>k", "<c-w>k")
map({ "n", "v" }, "<leader>l", "<c-w>l")

map("n", "<c-p>", "<c-u>zz")
map("n", "<c-n>", "<c-d>zz")

map("n", "<c-\\>", "<cmd>clo<cr>")
map("n", "<c-=>", "<cmd>vs<cr>")
map("n", "<c-->", "<cmd>sp<cr>")
map("n", "<c-0>", "<c-w>o")
map("n", "<c-9>", "<c-w>r")

map("v", "s", "<Plug>Lightspeed_s")
map("v", "S", "<Plug>Lightspeed_S")

map("v", "<c-s>", "<Plug>(VM-Reselect-Last)")

map("v", "z", "<Plug>VSurround")

map('n', '<F3>', '<cmd>TSHighlightCapturesUnderCursor<cr>')

map("n", "<c-6>", "<C-^>")

map("n", "ci_", '<cmd>set iskeyword-=_<cr>"_ciw<cmd>set iskeyword+=_<cr>')
map("n", "di_", '<cmd>set iskeyword-=_<cr>"_diw<cmd>set iskeyword+=_<cr>')
map("n", "vi_", "<cmd>set iskeyword-=_<cr>viw<cmd>set iskeyword+=_<cr>")

map("n", "ca_", '<cmd>set iskeyword-=_<cr>"_caw<cmd>set iskeyword+=_<cr>')
map("n", "da_", '<cmd>set iskeyword-=_<cr>"_daw<cmd>set iskeyword+=_<cr>')
map("n", "va_", "<cmd>set iskeyword-=_<cr>vaw<cmd>set iskeyword+=_<cr>")

-- tab
map("n", "<c-,>", "<Plug>(cokeline-focus-prev)")
map("n", "<c-.>", "<Plug>(cokeline-focus-next)")
-- Re-order to previous/next
map("n", "<a-,>", "<Plug>(cokeline-switch-prev)")
map("n", "<a-.>", "<Plug>(cokeline-switch-next)")
-- close
map("n", "<c-w>", "<cmd>BufDel<CR>")

map("n", "<leader>dm", ":delmarks ")

if vim.g.neovide then
    vim.opt.guifont= "JetBrains Mono NL:h12"
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_cursor_animation_length=0
    vim.g.neovide_remember_window_size = true
end

if (vim.fn.has("gui_running") and not vim.g.neovide) then
    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        command = "GuiFont! JetBrains Mono NL:h13"
    })
end

vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    command = "silent! checktime"
})

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "delmarks 0-9"
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.lua", "*.html" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end
})

vim.cmd([[
language en_US
filetype on

" colorscheme gruvball-ish

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

let g:lightspeed_last_motion = ''
augroup lightspeed_last_motion
autocmd!
autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
augroup end
map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
map <expr> , g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"

autocmd BufRead *.scm set filetype=query

fun! TrimWhitespace()
let l:save = winsaveview()
keeppatterns %s/\s\+$//e
call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

noremap <silent> <expr> ' "'".toupper(nr2char(getchar()))
noremap <silent> <expr> m "m".toupper(nr2char(getchar()))
sunmap '
sunmap m

" Still need to escape in default way
" let g:VM_maps["Exit"] = '<C-j>'

]])

local ok, theme = pcall(require, "theme")
if ok then
    theme.colorscheme()
end

if not (vim.g.arpeggio_timeoutlen ~= nil) then
    vim.cmd[[
    call arpeggio#map('i', '', 0, 'jk', '<Esc>')
    call arpeggio#map('i', '', 0, 'kj', '<Esc>')
    call arpeggio#map('v', '', 0, 'jk', '<Esc>')
    call arpeggio#map('v', '', 0, 'kj', '<Esc>')
    call arpeggio#map('s', '', 0, 'jk', '<Esc>')
    call arpeggio#map('s', '', 0, 'kj', '<Esc>')
    call arpeggio#map('x', '', 0, 'jk', '<Esc>')
    call arpeggio#map('x', '', 0, 'kj', '<Esc>')
    call arpeggio#map('c', '', 0, 'jk', '<c-c>')
    call arpeggio#map('c', '', 0, 'kj', '<c-c>')
    call arpeggio#map('o', '', 0, 'jk', '<Esc>')
    call arpeggio#map('o', '', 0, 'kj', '<Esc>')
    call arpeggio#map('l', '', 0, 'jk', '<Esc>')
    call arpeggio#map('l', '', 0, 'kj', '<Esc>')
    call arpeggio#map('t', '', 0, 'kj', '<Esc>')
    call arpeggio#map('t', '', 0, 'kj', '<Esc>')
    ]]
end
