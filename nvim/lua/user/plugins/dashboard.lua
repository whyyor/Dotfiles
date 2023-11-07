local dashboard = require("dashboard")
dashboard.setup({
	theme = "doom",
	config = {
		header = {
			"",
			"",
			"",
			"",
			"",
			" |\\__/,|   (`\\ ",
			" |_ _  |.--.) )",
			" ( T   )     / ",
			"(((^_(((/(((_/ ",
			"",
			"",
			"",
			"",
		}, --your header
		center = {
			{
				icon = "               󰈔  ",
				desc = "New file",
				action = "enew",
			},

			{
				icon = "                 ",
				shortcut = "SPC f",
				desc = "Find file",
				action = "Telescope find_files",
			},

			{
				icon = "               󱣹  ",
				shortcut = "SPC h",
				desc = "Recent files           ",
				action = "Telescope oldfiles",
			},

			{
				icon = "               󰈞  ",
				shortcut = "SPC g",
				desc = "Find Word           ",
				action = "Telescope live_grep",
			},
		},
		footer = {
			"",
			"",
			"",
			"  Have a great coding session  🎉 ",
			"  Don't wake up the sleeping kitten (ᴗ.ᴗ)💤 ",
			"",
			"",
			"",
		}, --your footer
	},
})
