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
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })
	use({ "nvim-treesitter/playground" })

	use({ "neovim/nvim-lspconfig" })
	use({ "tami5/lspsaga.nvim" })

	use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })
	use({ "justinmk/vim-sneak" })
	use({ "chaoren/vim-wordmotion" })

	use({ "numToStr/Comment.nvim" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
	use({ "windwp/nvim-autopairs" })
	use({ "mg979/vim-visual-multi" })

	use({ "sbdchd/neoformat" })

	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/nvim-cmp" })

	use({ "L3MON4D3/LuaSnip" })

	use({ "windwp/nvim-ts-autotag" })

	use({ "kdheepak/lazygit.nvim" })

	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
