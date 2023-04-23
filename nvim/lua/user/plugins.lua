local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Monokai theme
	{
		"tanvirtin/monokai.nvim",
		config = function()
			require("user/plugins/monokai")
		end,
	},

	-- Commenting support using 'n'`gcc`
	{ "tpope/vim-commentary" },

	-- Add, change, and delete surrounding text.
	-- `cs'"` will change surrounding to ""
	-- Even works with html and shit. Refer to docs for more
	{ "tpope/vim-surround" },

	-- Useful commands like :Rename and :SudoWrite.
	{ "tpope/vim-eunuch" },

	-- Pairs of handy bracket mappings, like [b and ]b.
	{ "tpope/vim-unimpaired" },

	-- Indent autodetection with editorconfig support.
	{ "tpope/vim-sleuth" },

	-- Allow plugins to enable repeating of commands.
	{ "tpope/vim-repeat" },

	-- Navigate seamlessly between Vim windows and Tmux panes.
	{ "christoomey/vim-tmux-navigator" },

	-- Jump to the last location when opening a file.
	{ "farmergreg/vim-lastplace" },

	-- Enable * searching with visually selected text.
	{ "nelstrom/vim-visual-star-search" },

	-- Automatically create parent dirs when saving.
	{ "jessarcher/vim-heritage" },

	-- Detect prisma filetypes
	{ "prisma/vim-prisma" },

	-- Text objects for HTML
	{
		"whatyouhide/vim-textobj-xmlattr",
		dependencies = "kana/vim-textobj-user",
	},

	-- Automatically set the working directory to the project root.
	{
		"airblade/vim-rooter",
		init = function()
			-- Instead of this running every time we open a file, we'll just run it once when Vim starts.
			vim.g.rooter_manual_only = 1
		end,
		cmd = "Rooter",
	},

	-- Automatically add closing
	{
		"windwp/nvim-autopairs",
		-- This was written in lua so we do this config thing
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- Add smooth scrolling to avoid jumps
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	},

	-- All closing buffers without closing the split
	{
		"famiu/bufdelete.nvim",
	},

	-- Split arrays and methods onto multiple lines, or join them back up.
	-- we use keys `gS` to split and `gJ` to join backup
	{
		"AndrewRadev/splitjoin.vim",
		config = function()
			vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
			vim.g.splitjoin_trailing_comma = 1
			vim.g.splitjoin_php_method_chain_full = 1
		end,
	},

	-- Automatically fix indentation when pasting code.
	{
		"sickill/vim-pasta",
		config = function()
			vim.g.pasta_disabled_filetypes = { "fugitive" }
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"nvim-telescope/telescope-live-grep-args.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"kdheepak/lazygit.nvim",
		},
		config = function()
			require("user/plugins/telescope")
		end,
	},

	-- File tree sidebar
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = "kyazdani42/nvim-web-devicons",
		config = function()
			require("user/plugins/nvim-tree")
		end,
	},

	-- A Status line.
	{
		"nvim-lualine/lualine.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
		config = function()
			require("user/plugins/lualine")
		end,
	},

	-- Display indentation lines.
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("user/plugins/indent-blankline")
		end,
	},

	-- Add a dashboard.
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("user/plugins/dashboard")
		end,
	},

	-- Git integration.
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({ current_line_blame = true })
		end,
	},

	--- Floating terminal.
	{
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
	},

	-- Improved syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("user/plugins/treesitter")
		end,
	},

	-- Language Server Protocol.
	{
				"neovim/nvim-lspconfig",
		dependencies = {
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
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
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
	},
})
