local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

require('packer').startup(function(use)
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'neovim/nvim-lspconfig' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-repeat' }
  use { 'justinmk/vim-sneak' }
  use { 'junegunn/vim-easy-align' }
  use { 'terryma/vim-expand-region' }
  use { 'chaoren/vim-wordmotion' }
  use { 'rockerBOO/boo-colorscheme-nvim', branch = 'main' }
  use {
    'numToStr/Comment.nvim',
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/nvim-cmp' }

  use { 'windwp/nvim-autopairs', }

  use { 'mattn/emmet-vim' }

  use { 'mg979/vim-visual-multi' }

  if packer_bootstrap then
    require('packer').sync()
  end
end)


vim.cmd [[ 
"let g:user_emmet_leader_key='<C-y>'
let g:user_emmet_install_global = 0
autocmd FileType tsx,jsx,html EmmetInstall
]]

require('nvim-autopairs').setup {}
require('Comment').setup()
