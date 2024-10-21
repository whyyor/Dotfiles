require("markview").setup({
	filetypes = { "markdown", "quarto", "rmd", "vimwiki" },

	buf_ignore = { "nofile" },
	modes = { "n" },

	code_blocks = {
		style = "language",
		hl = "dark",
	},

	headings = {
		enable = true,
		style = "icon",
		sign = "󰌕 ",
		icon = "󰼏  ",
	},

	latex = {
		enable = true,
	},
})
