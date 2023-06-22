-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- add list of plugins to install
return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- lua function that many plugins use
	use("nvim-lua/plenary.nvim")

	use("bluz71/vim-nightfly-guicolors") -- colorscheme
	use("christoomey/vim-tmux-navigator") -- navigate between vim and tmux panes
	use("szw/vim-maximizer") -- maximize vim window

	-- essential plugins
	-- use("tpope/vim-commentary") -- comment out lines
	-- use("tpope/vim-repeat") -- repeat plugin commands
	-- use("tpope/vim-fugitive") -- git commands in nvim
	-- use("tpope/vim-rhubarb") -- github commands in nvim
	use("tpope/vim-surround") -- surround text with brackets, quotes, etc
	use("vim-scripts/ReplaceWithRegister") -- replace text with yanked text
	use("numToStr/Comment.nvim") -- comment out lines
	use("nvim-tree/nvim-tree.lua") -- file explorer
	use("kyazdani42/nvim-web-devicons") -- icons for nvim-tree
	use("nvim-lualine/lualine.nvim") -- status line
	use("akinsho/bufferline.nvim")
	use("moll/vim-bbye")
	use("rcarriga/nvim-notify") -- fancy notification

	-- fuzzy finding w/ telescope
	use({
		"AckslD/nvim-neoclip.lua",
		requires = {
			{ "tami5/sqlite.lua", module = "sqlite" },
			-- you'll need at least one of these
			{ "nvim-telescope/telescope.nvim" },
			-- {'ibhagwan/fzf-lua'},
		},
	})
	use("cljoly/telescope-repo.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
	use("nvim-telescope/telescope-media-files.nvim")
	use("jvgrootveld/telescope-zoxide")

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths

	-- -- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- -- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

	-- -- configuring lsp servers
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		requires = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	}) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	-- -- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand sid

	-- terminal
	use("akinsho/toggleterm.nvim") -- show terminal inside nvim

	-- dashboard
	-- https://github.com/nvimdev/dashboard-nvim
	use("glepnir/dashboard-nvim")

	-- multi cursor
	use("mg979/vim-visual-multi")

	-- firenvim for chrome
	use({
		"glacambre/firenvim",
		run = function()
			vim.fn["firenvim#install"](0)
		end,
	})

	-- hop easy-motion
	use({
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
	})

	--copilota
	use("github/copilot.vim")
	vim.g.copilot_node_command = "~/.nvm/versions/node/v16.20.0/bin/node"

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
