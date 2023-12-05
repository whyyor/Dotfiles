local actions = require("telescope.actions")

vim.cmd([[
  highlight link TelescopePromptTitle PMenuSel
  highlight link TelescopePreviewTitle PMenuSel
  highlight link TelescopePromptNormal NormalFloat
  highlight link TelescopePromptBorder FloatBorder
  highlight link TelescopeNormal CursorLine
  highlight link TelescopeBorder CursorLineBg
]])

require("telescope").setup({
	defaults = {
		path_display = { truncate = 1 },
		prompt_prefix = "   ",
		selection_caret = "  ",
		layout_config = {
			prompt_position = "top",
		},
		sorting_strategy = "ascending",
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-Down>"] = actions.cycle_history_next,
				["<C-Up>"] = actions.cycle_history_prev,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
		file_ignore_patterns = { ".git/" },
	},
	pickers = {
		find_files = {
			hidden = true,
		},
		buffers = {
			previewer = false,
			layout_config = {
				width = 80,
			},
		},
		oldfiles = {
			prompt_title = "History",
		},
		lsp_references = {
			previewer = false,
		},
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("lazygit")

---- Flutter
require("telescope").load_extension("flutter")

-- calls find files picker
vim.keymap.set("n", "<leader>f", [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
-- find files but also includes things that are gitignore
vim.keymap.set(
	"n",
	"<leader>F",
	[[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' })<CR>]]
)
-- buffers
vim.keymap.set("n", "<leader>b", [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
-- live grep - requires you to install
vim.keymap.set("n", "<leader>g", [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])
-- file history
vim.keymap.set("n", "<leader>h", [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
-- grep variables in current file
vim.keymap.set("n", "<leader>ws", [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
-- lazygit
vim.keymap.set("n", "<Leader>l", ":LazyGit<CR>")

vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "NONE", bg = "NONE" })
