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

local packer_bootstrap = ensure_packer()

require("packer").reset()
require("packer").init({
	compile_path = vim.fn.stdpath("data") .. "/site/plugin/packer_compiled.lua",
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "solid" })
		end,
	},
})

local use = require("packer").use

-- Packer can manage itself.
use("wbthomason/packer.nvim")

-- Monokai theme
use({
	"tanvirtin/monokai.nvim",
	config = function()
		require("user/plugins/monokai")
	end,
})

-- Commenting support using 'n'`gcc`
use("tpope/vim-commentary")

-- Add, change, and delete surrounding text.
-- `cs'"` will change surrounding to ""
-- Even works with html and shit. Refer to docs for more
use("tpope/vim-surround")

-- Useful commands like :Rename and :SudoWrite.
use("tpope/vim-eunuch")

-- Pairs of handy bracket mappings, like [b and ]b.
use("tpope/vim-unimpaired")

-- Indent autodetection with editorconfig support.
use("tpope/vim-sleuth")

-- Allow plugins to enable repeating of commands.
use("tpope/vim-repeat")

-- Add more languages.
use("sheerun/vim-polyglot")

-- Navigate seamlessly between Vim windows and Tmux panes.
use("christoomey/vim-tmux-navigator")

-- Jump to the last location when opening a file.
use("farmergreg/vim-lastplace")

-- Enable * searching with visually selected text.
use("nelstrom/vim-visual-star-search")

-- Automatically create parent dirs when saving.
use("jessarcher/vim-heritage")

-- Detect prisma filetypes
use("prisma/vim-prisma")

-- Text objects for HTML attributes.
use({
	"whatyouhide/vim-textobj-xmlattr",
	requires = "kana/vim-textobj-user",
})

-- Automatically set the working directory to the project root.
use({
	"airblade/vim-rooter",
	setup = function()
		-- Instead of this running every time we open a file, we'll just run it once when Vim starts.
		vim.g.rooter_manual_only = 1
	end,
	config = function()
		vim.cmd("Rooter")
	end,
})

-- Automatically add closing brackets, quotes, etc.
use({
	"windwp/nvim-autopairs",
	-- This was written in lua so we do this config thing
	config = function()
		require("nvim-autopairs").setup()
	end,
})

-- Add smooth scrolling to avoid jarring jumps
use({
	"karb94/neoscroll.nvim",
	config = function()
		require("neoscroll").setup()
	end,
})

-- All closing buffers without closing the split window.
use({
	"famiu/bufdelete.nvim",
})

-- Split arrays and methods onto multiple lines, or join them back up.
-- we use keys `gS` to split and `gJ` to join backup
use({
	"AndrewRadev/splitjoin.vim",
	config = function()
		vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
		vim.g.splitjoin_trailing_comma = 1
		vim.g.splitjoin_php_method_chain_full = 1
	end,
})

-- Automatically fix indentation when pasting code.
use({
	"sickill/vim-pasta",
	config = function()
		vim.g.pasta_disabled_filetypes = { "fugitive" }
	end,
})

-- Fuzzy finder
use({
	"nvim-telescope/telescope.nvim",
	requires = {
		"nvim-lua/plenary.nvim",
		"kyazdani42/nvim-web-devicons",
		"nvim-telescope/telescope-live-grep-args.nvim",
		"kdheepak/lazygit.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
	},
	config = function()
		require("user/plugins/telescope")
	end,
})

-- File tree sidebar
use({
	"kyazdani42/nvim-tree.lua",
	requires = "kyazdani42/nvim-web-devicons",
	config = function()
		require("user/plugins/nvim-tree")
	end,
})

-- A Status line.
use({
	"nvim-lualine/lualine.nvim",
	requires = "kyazdani42/nvim-web-devicons",
	config = function()
		require("user/plugins/lualine")
	end,
})

-- Display indentation lines.
use({
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		require("user/plugins/indent-blankline")
	end,
})

-- Add a dashboard.
use({
	"glepnir/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("user/plugins/dashboard")
	end,
})

-- Git integration.
use({
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({ current_line_blame = true })
	end,
})

--- Floating terminal.
use({
	"voldikss/vim-floaterm",
	config = function()
		vim.g.floaterm_width = 0.8
		vim.g.floaterm_height = 0.8
		vim.keymap.set("n", "<C-t>", ":FloatermToggle<CR>")
		vim.keymap.set("t", "<C-t>", "<C-\\><C-n>:FloatermToggle<CR>")
		vim.cmd([[
		    highlight link Floaterm CursorLine
			highlight link FloatermBorder CursorLineBg
		]])
	end,
})

-- Improved syntax highlighting
use({
	"nvim-treesitter/nvim-treesitter",
	run = function()
		require("nvim-treesitter.install").update({ with_sync = true })
	end,
	requires = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("user/plugins/treesitter")
	end,
})

-- Language Server Protocol.
use({
	"neovim/nvim-lspconfig",
	requires = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"b0o/schemastore.nvim",
		-- null-ls plugins
		"jose-elias-alvarez/null-ls.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		require("user/plugins/lspconfig")
	end,
})

-- Completion
use({
	"hrsh7th/nvim-cmp",
	requires = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind-nvim",
	},
	config = function()
		require("user/plugins/cmp")
	end,
})

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if packer_bootstrap then
	require("packer").sync()
end

-- automatically updates the plugins whenever plugin.lua updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])
