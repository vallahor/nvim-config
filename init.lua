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

    -- @languages
    use { 'nvim-treesitter/playground' }
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use({ "vim-kind/vim-kind" })
    -- use({ "ziglang/zig.vim" })

    use({ "ggandor/lightspeed.nvim" })
    use({ "kdheepak/lazygit.nvim" })

    use({ "kyazdani42/nvim-tree.lua" })
    use({ 'numToStr/Comment.nvim' })

    use({ "ojroques/nvim-bufdel" })

    use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })

    use({ "sbdchd/neoformat" })


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
-- config_global.timeoutlen = 0
config_global.shortmess = "aoOtTIc"
config_global.mouse = "a"
config_global.mousefocus = true
config_global.fsync = true
config_global.magic = true
config_global.cursorline = true
config_global.scrolloff = 3
config_global.backup = false
-- config_global.guicursor = "i:block-iCursor"
config_global.gdefault = true
-- config_global.cmdheight = 1

config_window.signcolumn = "no"
config_window.number = true
config_window.wrap = true
config_buffer.autoread = true
config_buffer.copyindent = true
config_buffer.grepprg = "rg"
config_buffer.swapfile = false

vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.lua", command = ":Neoformat stylua" })
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.ml", command = ":Neoformat ocamlformat" })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css", "*.scss", "*.json" },
	command = ":Neoformat prettier",
})

vim.g.neoformat_only_msg_on_error = 1

local ok, nvim_treesitter = pcall(require, "nvim-treesitter.configs")
if ok then
    nvim_treesitter.setup({
        ensure_installed = {
            "lua",
            "bash",
            "c",
            "cpp",
            "javascript",
            "typescript",
            "zig",
            "jsonc",
            "query",
            "python",
            "rust",
            "ocaml",
        },
        highlight = {
            enable = true,
        },
        indent = {
            enable = false,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "m",
                node_incremental = "m",
                node_decremental = "M",
                scope_incremental = "<c-/>",
            },
        },


    })
end

require("nvim-treesitter.highlight").set_custom_captures({
  ["js.named_import"] = "TSLiteral",
  ["js.import"] = "TSLiteral",
  ["js.keyword"] = "TSOperator",
  ["js.keyword_bold"] = "TSInclude",
  ["js.arrow_func"] = "TSKeyword",
  ["js.opening_element"] = "TSElement",
  ["js.closing_element"] = "TSElement",
  ["js.self_closing_element"] = "TSElement",
  ["zig.assignop"] = "TSOperator",
})

require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
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
  }
}

vim.cmd [[colorscheme gruvball]]

local ok, lightspeed = pcall(require, "lightspeed")
-- vim.g.lightspeed_no_default_keymaps = true

if ok then
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
            enable = false,
            icons = {
                corner = "└ ",
                edge = "│ ",
                none = "  ",
            },
        },
        icons = {
            webdev_colors = false,
            show = {
                folder = false,
                file = false,
                folder_arrow = true,
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
    nvim_comment.setup()
    local ft = require('Comment.ft')
    ft.set('kind', '//%s')
end

local ok, bufdel = pcall(require, "bufdel")
if ok then
    bufdel.setup({
        next = "cycle", -- or 'alternate'
        quit = false,
    })
end

-- MAPPING --

local map = vim.keymap.set

map("n", "<space>", "<nop>")

vim.g.mapleader = " "

map("n", "<c-w>", "<cmd>BufDel<CR>")

map("n", "<esc>", "<cmd>nohl<cr><esc>")

map("n", "<c-g>", "<cmd>LazyGit<cr>")
map("n", "<c-s>", "<cmd>NvimTreeToggle<cr>")
map("n", "<c-;>", "<cmd>NvimTreeFocus<cr>")

map("c", "<c-v>", '<c-r>"')

map("v", "v", 'V')

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

map({ "n", "v" }, "<c-enter>", "<cmd>w!<CR>")
map({ "n", "v" }, "<s-enter>", "<cmd>w!<CR>")

map("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
map("n", "<f2>", "<cmd>:e $MYVIMRC<CR>")
map("n", "<f5>", "<cmd>so %<CR>")

map("n", "<c-f>", ":e ")
map("n", "<c-space>", ":b ")

-- map("n", "<c-c>", "<cmd>!kind %:p<cr>")
map("n", "<c-c>", "<cmd>!kind2 run %:p<cr>")

map({ "n", "v" }, "<c-h>", "<c-w>h")
map({ "n", "v" }, "<c-j>", "<c-w>j")
map({ "n", "v" }, "<c-k>", "<c-w>k")
map({ "n", "v" }, "<c-l>", "<c-w>l")

map({ "n", "v" }, "<c-p>", "{")
map({ "n", "v" }, "<c-n>", "}")

-- map({ "n", "v" }, "[", "{")
-- map({ "n", "v" }, "]", "}")

-- map({ "n", "v" }, "<c-n>", "}")
-- map({ "n", "v" }, "<c-p>", "{")
--
-- map({ "n", "v" }, "{", "<c-u>")
-- map({ "n", "v" }, "}", "<c-d>")

-- map("n", "H", "<c-u>zz")
-- map("n", "L", "<c-d>zz")

map("n", "<c-t>", "zt")
map("n", "<c-b>", "zb")

map("n", "<c-=>", "<cmd>vs<cr>")
map("n", "<c-->", "<cmd>sp<cr>")
map("n", "<c-]>", "<cmd>clo<cr>")
map("n", "<c-0>", "<c-w>o")
map("n", "<c-9>", "<c-w>r")

map("v", "z", "<Plug>Lightspeed_s")
map("v", "Z", "<Plug>Lightspeed_S")

map("v", "s", "<Plug>VSurround")

map('n', '<F3>', '<cmd>TSHighlightCapturesUnderCursor<cr>', {})

-- vim.opt.guifont = { "JetBrains Mono:h12" }

vim.cmd([[

set guifont=JetBrains\ Mono:h12

" call GuiWindowMaximized(1)

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

"" Highlight extra whitespace.
"" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
"highlight ExtraWhitespace ctermbg=lightred guibg=lightred
"" Show trailing whitespace and spaces before a tab:
"match ExtraWhitespace /\s\+$\| \+\ze\t/

" au BufEnter *.scm set filetype=query

autocmd FileType python setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType json setlocal shiftwidth=2 softtabstop=2 expandtab

autocmd FileType kind setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType kind setlocal syntax=on

autocmd BufEnter *.kind2 set ft=kind

 autocmd BufEnter *.kind2 setlocal shiftwidth=2 softtabstop=2 expandtab
"autocmd FileType kind2 setlocal shiftwidth=2 softtabstop=2 expandtab
" autocmd FileType kind2 setlocal syntax=on

fun! TrimWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

]])

