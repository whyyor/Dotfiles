local presets = require("markview.presets").headings

vim.api.nvim_set_hl(0, "MarkviewHeadin1", { bg = "#453244", fg = "#ff6188" })
vim.api.nvim_set_hl(0, "MarkviewHeadin1Label", { fg = "#ff6188" })
vim.api.nvim_set_hl(0, "MarkviewHeading2", { bg = "#46393E", fg = "#78dce8" })
vim.api.nvim_set_hl(0, "MarkviewHeading2Label", { fg = "#78dce8" })
vim.api.nvim_set_hl(0, "MarkviewHeading3", { bg = "#464245", fg = "#a8dc76" })
vim.api.nvim_set_hl(0, "MarkviewHeading3Label", { fg = "#a8dc76" })
vim.api.nvim_set_hl(0, "MarkviewHeading4", { bg = "#374243", fg = "#ab9df2" })
vim.api.nvim_set_hl(0, "MarkviewHeading4Label", { fg = "#ab9df2" })
vim.api.nvim_set_hl(0, "MarkviewHeading5", { bg = "#2E3D51", fg = "#ffd866" })
vim.api.nvim_set_hl(0, "MarkviewHeading5Label", { fg = "#ffd866" })
vim.api.nvim_set_hl(0, "MarkviewHeading6", { bg = "#393B54", fg = "#fc9867" })
vim.api.nvim_set_hl(0, "MarkviewHeading6Label", { fg = "#fc9867" })

require("markview").setup({
	filetypes = { "markdown", "quarto", "rmd", "vimwiki" },

	buf_ignore = { "nofile" },
	modes = { "n" },

	code_blocks = {
		style = "language",
		hl = "dark",
	},

	headings = {
		heading_1 = {
			sign_hl = "MarkviewHeadin1Label",
			hl = "MarkviewHeadin1",
		},
		heading_2 = {
			sign_hl = "MarkviewHeading2Label",
			hl = "MarkviewHeading2",
		},
		heading_3 = {
			sign_hl = "MarkviewHeading3Label",
			hl = "MarkviewHeading3",
		},
		heading_4 = {
			sign_hl = "MarkviewHeading4Label",
			hl = "MarkviewHeading4",
		},
		heading_5 = {
			sign_hl = "MarkviewHeading5Label",
			hl = "MarkviewHeading5",
		},
		heading_6 = {
			sign_hl = "MarkviewHeading6Label",
			hl = "MarkviewHeading6",
		},
	},

list_items = {
    enable = true,

    indent_size = 2,

    shift_width = 4,

    marker_minus = {
        add_padding = true,

        text = "",
        hl = "MarkviewListItemMinus"
    },
    marker_plus = {
        add_padding = true,

        text = "",
        hl = "MarkviewListItemPlus"
    },
    marker_star = {
        add_padding = true,

        text = "",
        hl = "MarkviewListItemStar"
    },

    marker_dot = {
        add_padding = true
    },

    marker_parenthesis = {
        add_padding = true
    }
},
	checkboxes = presets.nerd,

	latex = {
		enable = true,
	},
})
