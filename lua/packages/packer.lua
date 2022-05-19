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
	use({ "lewis6991/spellsitter.nvim" })

	use({ "chaoren/vim-wordmotion" })
	use({ "neovim/nvim-lspconfig" })

	use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })
	use({ "justinmk/vim-sneak" })
	use({ "mg979/vim-visual-multi" })

	use({ "numToStr/Comment.nvim" })

	use({ "nvim-lua/plenary.nvim" })
	use({ "nvim-telescope/telescope.nvim" })

	use({ "sbdchd/neoformat" })

	use({ "L3MON4D3/LuaSnip" })
	use({ "hrsh7th/nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "petertriho/cmp-git" })

	-- using only when doing some kind of frontend stuff
	-- use({ "windwp/nvim-autopairs" })
	-- use({ "windwp/nvim-ts-autotag" })
	-- use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	use({ "kdheepak/lazygit.nvim" })

	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons",
		},
	})

	use({ "ziglang/zig.vim" })

	-- use({ "rebelot/heirline.nvim" })
	use({ "rafcamlet/tabline-framework.nvim" })

	if packer_bootstrap then
		require("packer").sync()
	end
end)
