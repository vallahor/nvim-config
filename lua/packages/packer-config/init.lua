local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

require('packer').startup(function(use)
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/playground' }
  use { 'neovim/nvim-lspconfig' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-repeat' }
  use { 'justinmk/vim-sneak' }
  use { 'terryma/vim-expand-region' }
  use { 'chaoren/vim-wordmotion' }
  use { 'numToStr/Comment.nvim', }
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
  use { 'ms-jpq/coq_nvim' }
  use { 'windwp/nvim-autopairs', }
  use { 'mattn/emmet-vim' }
  use { 'mg979/vim-visual-multi' }
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use { 'sbdchd/neoformat' }
  use { 'ms-jpq/chadtree' }
  use 'bluz71/vim-nightfly-guicolors'

  if packer_bootstrap then
    require('packer').sync()
  end
end)


vim.cmd [[ 
let g:user_emmet_install_global = 0
autocmd FileType tsx,jsx,html EmmetInstall
]]

-- vim.cmd [[
-- augroup fmt
--   autocmd!
--   autocmd BufWritePre * undojoin | Neoformat
-- augroup END
-- ]]

require('nvim-autopairs').setup {}
require('Comment').setup()

require('neogit').setup {}

require "telescope".setup {
  defaults = {
    mappings = {
      i = {
        ["<C-bs>"] = function()
          vim.api.nvim_input "<c-s-w>"
        end,
      },
    },
  }
}

local chadtree_settings = {
  theme = {
    icon_glyph_set = "ascii"
  }
}


vim.api.nvim_set_var("chadtree_settings", chadtree_settings)


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
