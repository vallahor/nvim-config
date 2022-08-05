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
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "ziglang/zig.vim" })
	use({ "ray-x/go.nvim" })

	-- @motion
	use({ "chaoren/vim-wordmotion" })
	use({ "ggandor/lightspeed.nvim" })
	use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })

	-- @ui
	use({ "romgrk/barbar.nvim" })
	use({ "ojroques/nvim-bufdel" })
	use({ "rebelot/heirline.nvim" })
	use({ "lewis6991/gitsigns.nvim", tag = "release" })
	use({ "kyazdani42/nvim-tree.lua" })

	use({ "sbdchd/neoformat" })
	use({ "kdheepak/lazygit.nvim" })

	-- @check
	-- use({ "nvim-lua/plenary.nvim" })
	-- use({ "nvim-telescope/telescope.nvim" })
	-- use({ "windwp/nvim-autopairs" })
	-- use({ "neovim/nvim-lspconfig" })
	-- use({ "nvim-treesitter/playground" })
	-- use({ "numToStr/Comment.nvim" })

	if packer_bootstrap then
		require("packer").sync()
	end
end)
