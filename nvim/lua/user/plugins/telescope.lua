local telescope = require("telescope")
local builtin = require("telescope.builtin")
local map = vim.keymap.set

-- Adjust Telescope setup
telescope.setup({
	defaults = {
		prompt_prefix = "   ",
		selection_caret = "  ",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.5,
				width = 0.95,
				height = 0.9,
			},
			vertical = {
				width = 0.9,
				height = 0.95,
				preview_height = 0.5,
			},
		},
		file_ignore_patterns = { ".git/", "node_modules" },
		winblend = 10,
		borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
		color_devicons = true,
		mappings = {
			i = {
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
				["<esc>"] = require("telescope.actions").close,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			find_command = { "rg", "--files", "--sortr=modified" },
		},
		buffers = {
			sort_mru = true,
			previewer = false,
		},
	},
})

-- Load extensions
telescope.load_extension("fzf")
telescope.load_extension("flutter")
telescope.load_extension("lazygit")
telescope.load_extension("frecency")

-- Custom key mappings
map("n", "<leader>f", builtin.find_files, { desc = "Find files" })
map("n", "<leader>b", builtin.buffers, { desc = "Show buffers" })
map("n", "<leader>g", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>h", builtin.oldfiles, { desc = "File history" })
map(
	"n",
	"<leader>F",
	[[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' })<CR>]]
)
map("n", "<leader>ws", [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

-- Highlight groups to match the background
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#111111" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#444444", bg = "#111111" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#111111" })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#111111" })
vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#111111" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#444444", bg = "#111111" })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#ffffff", bg = "#d45573" })
vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#111111", bg = "#a2d472" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#444444", bg = "#111111" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#444444", bg = "#111111" })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#333333", fg = "#ffffff" })
