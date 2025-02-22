require("nvim-tree").setup({
	git = {
		ignore = false,
	},
	renderer = {
		group_empty = true,
		icons = {
			show = {
				folder_arrow = false,
			},
		},
		indent_markers = {
			enable = false,
		},
	},
	view = {
		-- set NvimTree to be 30% of the screen width
		width = 30,
		-- position NvimTree on the right side of the screen
		side = "right",
	},
})

vim.keymap.set("n", "<Leader>n", ":NvimTreeFindFileToggle<CR>")

-- put this under require('user/plugins/nvim-tree') if any error in nvim tree
vim.api.nvim_set_hl(0, "StatusLineNonText", {
	fg = vim.api.nvim_get_hl_by_name("NonText", true).foreground,
	bg = vim.api.nvim_get_hl_by_name("StatusLine", true).background,
})

vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#2F313C" })
