local presets = require("markview.presets").headings

require("markview").setup({
	markdown = {
		headings = presets.glow,
		list_items = {
			enable = true,
			indent_size = 2,
			shift_width = 4,
			marker_minus = {
				add_padding = true,
				text = "",
				hl = "MarkviewListItemMinus",
			},
			marker_plus = {
				add_padding = true,
				text = "",
				hl = "MarkviewListItemPlus",
			},
			marker_star = {
				add_padding = true,
				text = "",
				hl = "MarkviewListItemStar",
			},
			marker_dot = {
				add_padding = true,
			},
			marker_parenthesis = {
				add_padding = true,
			},
		},
	},
	preview = {
		ignore_buftypes = { "nofile" },
		filetypes = { "markdown", "quarto", "rmd", "vimwiki" },
		modes = { "n" },
	},
	code_blocks = {
		style = "language",
		border_hl = "dark",
	},
	checkboxes = presets.nerd,
	latex = {
		enable = true,
	},
})

