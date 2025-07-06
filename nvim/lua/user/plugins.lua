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
	{
		"tanvirtin/monokai.nvim",
		config = function()
			require("user/plugins/monokai")
		end,
	},

	{ "tpope/vim-commentary" },

	-- Add, change, and delete surrounding text.
	-- ys means you surround so usage will be ysiw"" to surround a word
	-- `cs'"` will change surrounding to "" and cs means change surround
	-- ds means delete su
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

	-- DAP - Helps debug application
	{ "mfussenegger/nvim-dap" },

	-- Navigate seamlessly between Vim windows and Tmux panes.
	{ "christoomey/vim-tmux-navigator" },

	-- Jump to the last location when opening a file.
	{ "farmergreg/vim-lastplace" },

	-- Enable * searching with visually selected text.
	{ "nelstrom/vim-visual-star-search" },

	-- Automatically create parent dirs when saving.
	{ "jessarcher/vim-heritage" },

	-- Highlight words selected
	{ "RRethy/vim-illuminate",          event = "VeryLazy" },

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
		event = "VeryLazy",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- All closing buffers without closing the split
	{
		"famiu/bufdelete.nvim",
		event = "VeryLazy",
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
		event = "VeryLazy",
		config = function()
			vim.g.pasta_disabled_filetypes = { "fugitive" }
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"nvim-telescope/telescope-live-grep-args.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"kdheepak/lazygit.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			require("user/plugins/telescope")
		end,
	},

	-- File tree sidebar
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		config = function()
			require("user/plugins/neo-tree")
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

	-- Add a dashboard.
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("user/plugins/dashboard")
		end,
	},

	-- Lazygit
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("user/plugins/lazygit")
		end,
	},

	--- Floating terminal.
	{
		"voldikss/vim-floaterm",
		event = "VeryLazy",
		config = function()
			require("user/plugins/floaterm")
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
			"VonHeikemen/lsp-zero.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			require("user/plugins/lspconfig")
		end,
	},

	-- Mason null-ls ensure installer, also installs none-ls
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("user/plugins/mason-null-ls")
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

	-- Manages gitsigns and githistory previews
	{
		"tanvirtin/vgit.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		-- Lazy loading on 'VimEnter' event is necessary.
		event = "VimEnter",
		config = function()
			require("user/plugins/vgit")
		end,
	},

	-- UFO
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = {
			"kevinhwang91/promise-async",
			"luukvbaal/statuscol.nvim",
		},
		config = function()
			require("user/plugins/ufo")
		end,
		-- fold toggle using 'za'
	},

	-- TODO Comments
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("user/plugins/todo-comments")
		end,
	},

	-- Trouble to toggle diagnostics at bottom
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("user/plugins/trouble")
		end,
	},

	-- Wilder - better popup menu
	{ "gelguy/wilder.nvim", event = "VeryLazy" },

	-- Harpoon
	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("user/plugins/harpoon")
		end,
	},

	-- Copilot
	-- { "github/copilot.vim" },

	--- Flash
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},

	----------------------------- Languages ---------------------------------

	-- Flutter - for some reason savings gives error
	-- Workaround - edit a dart file go to another buffer and come back to previous buffer
	{
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		dependencies = { "nvim-lua/plenary.nvim", "reisub0/hot-reload.vim" },
		config = function()
			require("flutter-tools").setup({})
		end,
	},

	-- Prisma
	{ "prisma/vim-prisma" },

	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},

	----------------------------- Vim Wiki ---------------------------------
	{
		"vimwiki/vimwiki",
		init = function()
			require("user.plugins.vimwiki").setup()
		end,
	},

	-- For pasting images
	{
		-- Not using original clipboard-image due to check-health bug
		-- "ekickx/clipboard-image.nvim",
		"dfendr/clipboard-image.nvim",
		config = function()
			require("user/plugins/clipboard-image")
		end,
	},

	-- Add this to your plugin configuration section
	{
		"OXY2DEV/markview.nvim",
		config = function()
			require("user/plugins/markdown")
		end,
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
})
