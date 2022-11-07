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

    use({ "ojroques/nvim-bufdel" })

    use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })

    use({ "mg979/vim-visual-multi" })

    -- use({ "romgrk/barbar.nvim" })

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
config_global.ch = 0
-- config_global.guicursor = "i:block-iCursor"
config_global.guicursor = "i-ci:block-iCursor"

config_global.completeopt = { "menu", "menuone", "noselect" }
-- config_global.completeopt = { "menu", "noinsert", "menuone", "noselect" }

config_window.signcolumn = "no"
-- config_window.relativenumber = true
config_window.number = true
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
	-- ["Switch Mode"] = "<Tab>",
	["Align"] = "<c-a>",
	["Find Next"] = "]",
	["Find Prev"] = "[",
	["Goto Next"] = "}",
	["Goto Prev"] = "{",
	["Skip Region"] = "=",
	["Remove Region"] = "+",
    ["Add Cursor At Pos"] = "<enter>",
	-- ["I BS"] = "",
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
        next = "cycle", -- or 'alternate'
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
                    -- ["<c-n>"] = "move_selection_next",
                    -- ["<c-p>"] = "move_selection_previous",
                },
                i = {
                    ["<C-bs>"] = function()
                        vim.api.nvim_input("<c-s-w>")
                    end,
                    ["<c-j>"] = "move_selection_next",
                    ["<c-k>"] = "move_selection_previous",
                    -- ["<c-n>"] = "move_selection_next",
                    -- ["<c-p>"] = "move_selection_previous",
                    ["<esc>"] = actions.close,
                    -- ["<c-j>"] = actions.close
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
            "rust",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
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

    require "nvim-treesitter.configs".setup({
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
        },
    })

end

local ok, bufferline = pcall(require, "bufferline")
if ok then
    bufferline.setup({
        icons = false,
        animation = true,
        auto_hide = false,
        tabpages = true,
        closable = true,
        clickable = true,
        icon_custom_colors = false,

        icon_separator_active = '▎',
        icon_separator_inactive = '▎',
        icon_close_tab = '',
        icon_close_tab_modified = '',

        insert_at_end = false,
        insert_at_start = false,

        maximum_padding = 1,
        maximum_length = 30,

        semantic_letters = true,
        letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
        no_name_title = nil,
    })
end

-- MAPPING --

local map = vim.keymap.set

map("n", "<space>", "<nop>")

vim.g.mapleader = " "

map("n", "<esc>", "<cmd>nohl<cr><esc>")
-- map({"i", "c"}, "<c-j>", "<esc>")
-- map({"n", "i", "v", "c"}, "<c-j>", "<cmd>nohl<cr><esc>")

map("n", "<c-g>", "<cmd>LazyGit<cr>")
map("n", "<c-f>", "<cmd>NvimTreeToggle<cr>")
map("n", "<c-;>", "<cmd>NvimTreeFocus<cr>")

map("n", "<c-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<c-/>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<c-space>", "<cmd>lua require('telescope.builtin').buffers()<cr>")

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

map({ "n", "v" }, "<c-enter>", "<cmd>w!<CR><esc>")
map({ "n", "v" }, "<s-enter>", "<cmd>w!<CR><esc>")

-- map("n", "<f4>", "<cmd>:e ~/.config/nvim/init.lua<CR>")
map("n", "<f2>", "<cmd>:e $MYVIMRC<CR>")
map("n", "<f5>", "<cmd>so %<CR>")

map({ "n", "v" }, "<c-h>", "<c-w>h")
map({ "n", "v" }, "<c-j>", "<c-w>j")
map({ "n", "v" }, "<c-k>", "<c-w>k")
map({ "n", "v" }, "<c-l>", "<c-w>l")

-- map({ "n", "v" }, "<leader>h", "<c-w>h")
-- map({ "n", "v" }, "<leader>j", "<c-w>j")
-- map({ "n", "v" }, "<leader>k", "<c-w>k")
-- map({ "n", "v" }, "<leader>l", "<c-w>l")

map("n", "H", "<c-u>zz")
map("n", "L", "<c-d>zz")

map("n", "<c-t>", "zt")
map("n", "<c-b>", "zb")

map("n", "<c-=>", "<cmd>vs<cr>")
map("n", "<c-->", "<cmd>sp<cr>")
map("n", "<c-\\>", "<cmd>clo<cr>")
map("n", "<c-0>", "<c-w>o")
map("n", "<c-9>", "<c-w>r")

map("v", "z", "<Plug>Lightspeed_s")
map("v", "Z", "<Plug>Lightspeed_S")

map("v", "s", "<Plug>VSurround")

map('n', '<F3>', '<cmd>TSHighlightCapturesUnderCursor<cr>', {})

map("n", "<C-6>", "C-^")

map("n", "<c-w>", "<cmd>BufDel<CR>")

map("n", "ci_", '<cmd>set iskeyword-=_<cr>"_ciw<cmd>set iskeyword+=_<cr>')
map("n", "di_", '<cmd>set iskeyword-=_<cr>"_diw<cmd>set iskeyword+=_<cr>')
map("n", "vi_", "<cmd>set iskeyword-=_<cr>viw<cmd>set iskeyword+=_<cr>")

map("n", "ca_", '<cmd>set iskeyword-=_<cr>"_caw<cmd>set iskeyword+=_<cr>')
map("n", "da_", '<cmd>set iskeyword-=_<cr>"_daw<cmd>set iskeyword+=_<cr>')
map("n", "va_", "<cmd>set iskeyword-=_<cr>vaw<cmd>set iskeyword+=_<cr>")

vim.cmd([[

language en_US

" hi TSElement guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=italic cterm=italic

colorscheme gruvball-ish

autocmd FocusGained * silent! checktime

set cindent
" set cino+=L0,g0,N-s,(0,l1
set cino+=+0,L0,g0,N-s,(0,l1,t0
" set cino+=+0,L0,g0,(0,l1,t0
" set cino+=+0,L0,g0,l1,t0

" set guifont=JetBrains\ Mono\ NL:h11
autocmd VimEnter * GuiFont! JetBrains\ Mono\ NL:h11

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

autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType json setlocal shiftwidth=2 softtabstop=2 expandtab

fun! TrimWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()


nnoremap <silent> <c-s> <Plug>(VM-Reselect-Last)

" nnoremap <C-j> <Esc>:noh<cr>
" inoremap <C-j> <Esc>:noh<cr>
" vnoremap <C-j> <Esc>:noh<cr>
" snoremap <C-j> <Esc>:noh<cr>
" xnoremap <C-j> <Esc>:noh<cr>
" cnoremap <C-j> <C-c>:noh<cr>
" onoremap <C-j> <Esc>:noh<cr>
" lnoremap <C-j> <Esc>:noh<cr>
" tnoremap <C-j> <Esc>:noh<cr>
" map <c-j> <esc>:noh<cr>

nnoremap <leader><leader> <c-^>
]])
