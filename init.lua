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

  use({ "kyazdani42/nvim-tree.lua" })
  use({ 'numToStr/Comment.nvim' })

  use({ "tpope/vim-surround" })
  use({ "tpope/vim-repeat" })

  use({ "mg979/vim-visual-multi" })

  use({ "noib3/nvim-cokeline" })
  use({ "ojroques/nvim-bufdel" })

  if packer_bootstrap then
    require("packer").sync()
  end
end)

-- SETTINGS --

local config_global = vim.opt
local config_buffer = vim.bo
local config_window = vim.wo

local indent = 4
config_global.shiftwidth = indent
config_global.tabstop = indent
config_global.softtabstop = indent

config_global.expandtab = true
config_global.smartindent = true
config_global.autoindent = true
config_global.hidden = true
config_global.ignorecase = true
config_global.shiftround = true
config_global.splitright = true
config_global.splitbelow = true
config_global.termguicolors = true
config_global.wildmode = "longest,list:longest,full"
config_global.clipboard = "unnamedplus"
config_global.encoding = "utf8"
config_global.pumheight = 10
config_global.switchbuf = "useopen,split"
config_global.magic = true
config_global.lazyredraw = true
config_global.smartcase = true
config_global.inccommand = "nosplit"
config_global.backspace = "indent,eol,start"
config_global.shortmess = "aoOtTIc"
config_global.mouse = "a"
config_global.mousefocus = true
config_global.fsync = true
config_global.magic = true
config_global.cursorline = true
config_global.scrolloff = 3
config_global.backup = false
config_global.gdefault = true
-- config_global.ch = 0
-- config_global.guicursor = "i-ci:block-iCursor" -- comment when using nvim-qt (new version)

config_global.completeopt = { "menu", "menuone", "noselect" }
-- config_global.completeopt = { "menu", "noinsert", "menuone", "noselect" }

config_window.signcolumn = "no"
config_window.relativenumber = true
-- config_window.number = true
config_window.wrap = true
config_buffer.autoread = true
config_buffer.copyindent = true
config_buffer.grepprg = "rg"
config_buffer.swapfile = false

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
      line = "gcc",
      block = "gbc",
    },
    opleader = {
      line = "gc",
      block = "gb",
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
          ["<c-j>"] = "move_selection_next",
          ["<c-k>"] = "move_selection_previous",
        },
        i = {
          ["<C-bs>"] = function()
            vim.api.nvim_input("<c-s-w>")
          end,
          ["<c-j>"] = "move_selection_next",
          ["<c-k>"] = "move_selection_previous",
          -- ["<esc>"] = actions.close,
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

-- MAPPING --

local map = vim.keymap.set

map("n", "<space>", "<nop>")

vim.g.mapleader = " "

map("n", "<esc>", "<cmd>nohl<cr><esc>")

map("n", "<leader>g", "<cmd>LazyGit<cr>")
map("n", "<leader>ft", "<cmd>NvimTreeToggle<cr>")
map("n", "<c-;>", "<cmd>NvimTreeFocus<cr>")

map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>ps", "<cmd>lua require('telescope.builtin').live_grep()<cr>")

map("c", "<c-v>", '<c-r>*')

map("v", "v", 'V')
map("n", "L", '<c-v>')

map({ "i", "c" }, "<c-bs>", "<c-w>")

map("n", "x", '"_x')
map("v", "x", '"_d')
map({ "n", "v" }, "c", '"_c')
map("v", "p", '"_dP')

map("n", "*", "*``")
map("v", "*", '"sy/\\V<c-r>s<cr>``')

map({ "n", "v" }, "-", "$")
map({ "n", "v" }, "<leader>0", "0")
map({ "n", "v" }, "0", "^")

map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

map({ "n", "v" }, "<leader>fs", "<cmd>w!<CR><esc>")

-- map("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
map("n", "<f2>", "<cmd>:e $MYVIMRC<CR>")
map("n", "<f5>", "<cmd>so %<CR>")

map({ "n", "v" }, "<leader>h", "<c-w>h")
map({ "n", "v" }, "<leader>j", "<c-w>j")
map({ "n", "v" }, "<leader>k", "<c-w>k")
map({ "n", "v" }, "<leader>l", "<c-w>l")

map("n", "<c-k>", "<c-u>zz")
map("n", "<c-j>", "<c-d>zz")

map("n", "+", "<cmd>vs<cr>")
map("n", "_", "<cmd>sp<cr>")
map("n", "|", "<cmd>clo<cr>")
map("n", "<leader>do", "<c-w>o")
map("n", "<leader>wr", "<c-w>r")

map("v", "z", "<Plug>Lightspeed_s")
map("v", "Z", "<Plug>Lightspeed_S")

map("v", "s", "<Plug>VSurround")

map('n', '<F3>', '<cmd>TSHighlightCapturesUnderCursor<cr>')

map("n", "^", "<C-^>")

map("n", "ci_", '<cmd>set iskeyword-=_<cr>"_ciw<cmd>set iskeyword+=_<cr>')
map("n", "di_", '<cmd>set iskeyword-=_<cr>"_diw<cmd>set iskeyword+=_<cr>')
map("n", "vi_", "<cmd>set iskeyword-=_<cr>viw<cmd>set iskeyword+=_<cr>")

map("n", "ca_", '<cmd>set iskeyword-=_<cr>"_caw<cmd>set iskeyword+=_<cr>')
map("n", "da_", '<cmd>set iskeyword-=_<cr>"_daw<cmd>set iskeyword+=_<cr>')
map("n", "va_", "<cmd>set iskeyword-=_<cr>vaw<cmd>set iskeyword+=_<cr>")

map("n", "<c-,>", "<<")
map("n", "<c-.>", ">>")

-- tab
map("n", "<", "<Plug>(cokeline-focus-prev)")
map("n", ">", "<Plug>(cokeline-focus-next)")
-- Re-order to previous/next
map("n", "<a-,>", "<Plug>(cokeline-switch-prev)")
map("n", "<a-.>", "<Plug>(cokeline-switch-next)")
-- close
map("n", "<c-w>", "<cmd>BufDel<CR>")
map("n", "<leader>dd", "<cmd>BufDel<CR>")

map("n", "<leader>,", "<c-i>")
map("n", "<leader>.", "<c-o>")

map("n", "<leader>dm", ":delmarks ")

map("n", "U", "<c-r>")

vim.cmd([[
language en_US

filetype on

colorscheme gruvball-ish

autocmd FocusGained * silent! checktime

" set guifont=JetBrains\ Mono\ NL:h13
if has("gui_running")
  autocmd VimEnter * GuiFont! JetBrains\ Mono\ NL:h13
endif

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

autocmd BufEnter *.scm set filetype=query

fun! TrimWhitespace()
let l:save = winsaveview()
keeppatterns %s/\s\+$//e
call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

nnoremap <silent> <c-s> <Plug>(VM-Reselect-Last)

set cindent
" set cino+=L0,g0,N-s,(0,l1,t0
set cino+=L0,g0,l1,t0,(0,w1,w4,(s,m1
" set cino+=L0,g0,l1,t0,w1,w4,(s,m1

noremap <silent> <expr> ' "'".toupper(nr2char(getchar()))
noremap <silent> <expr> m "m".toupper(nr2char(getchar()))
sunmap '
sunmap m

autocmd VimEnter * delmarks 0-9
]])

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = {"*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.lua", "*.html"},
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end
})

