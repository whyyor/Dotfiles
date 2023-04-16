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
			enable = true,
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
