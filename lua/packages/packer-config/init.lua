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
  use { 'windwp/nvim-autopairs', }
  use { 'mattn/emmet-vim' }
  use { 'mg979/vim-visual-multi' }
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use { 'sbdchd/neoformat' }
  use { 'ms-jpq/chadtree' }

  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-path' }
  use { 'hrsh7th/nvim-cmp' }

  use { 'windwp/nvim-ts-autotag' }

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

local cmp = require('cmp')
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' }
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ["<c-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert, select = false })
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<c-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert, select = false })
      end
    end, { "i", "s" }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },

  snippet = {
    -- We recommend using *actual* snippet engine.
    -- It's a simple implementation so it might not work in some of the cases.
    expand = function(args)
      local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
      local indent = string.match(line_text, '^%s*')
      local replace = vim.split(args.body, '\n', true)
      local surround = string.match(line_text, '%S.*') or ''
      local surround_end = surround:sub(col)

      replace[1] = surround:sub(0, col - 1) .. replace[1]
      replace[#replace] = replace[#replace] .. (#surround_end > 1 and ' ' or '') .. surround_end
      if indent ~= '' then
        for i, line in ipairs(replace) do
          replace[i] = indent .. line
        end
      end

      vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
    end,
  },

}
