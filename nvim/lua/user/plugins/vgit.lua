require("vgit").setup({
	keymaps = {
		["n ]h"] = function()
			require("vgit").hunk_down()
		end,
		["n [h"] = function()
			require("vgit").hunk_up()
		end,
		["n gs"] = function()
			require("vgit").buffer_hunk_stage()
		end,
		["n gr"] = function()
			require("vgit").buffer_hunk_reset()
		end,
		["n gp"] = function()
			require("vgit").buffer_hunk_preview()
		end,
		["n gb"] = "buffer_blame_preview",
		["n gf"] = function()
			require("vgit").buffer_diff_preview()
		end,
		["n gh"] = function()
			require("vgit").buffer_history_preview()
		end,
		["n gu"] = function()
			require("vgit").buffer_reset()
		end,
		["n gl"] = function()
			require("vgit").project_diff_preview()
		end,
		["n gx"] = function()
			require("vgit").toggle_diff_preference()
		end,
	},
	settings = {
		hls = {
			GitCount = "Keyword",
			GitSymbol = "CursorLineNr",
			GitTitle = "Directory",
			GitSelected = "QuickfixLine",
			GitBackground = "Normal",
			GitAppBar = "StatusLine",
			GitHeader = "NormalFloat",
			GitFooter = "NormalFloat",
			GitBorder = "LineNr",
			GitLineNr = "LineNr",
			GitComment = "Comment",
			GitSignsAdd = {
				gui = nil,
				fg = "#acd385",
				bg = nil,
				sp = nil,
				override = false,
			},
			GitSignsChange = {
				gui = nil,
				fg = "#D7D7D7",
				bg = nil,
				sp = nil,
				override = false,
			},
			GitSignsDelete = {
				gui = nil,
				fg = "#f65a81",
				bg = nil,
				sp = nil,
				override = false,
			},
			GitSignsAddLn = "DiffAdd",
			GitSignsDeleteLn = "DiffDelete",
			GitWordAdd = {
				gui = nil,
				fg = nil,
				bg = "#acd385",
				sp = nil,
				override = false,
			},
			GitWordDelete = {
				gui = nil,
				fg = nil,
				bg = "#f65a81",
				sp = nil,
				override = false,
			},
			GitConflictCurrentMark = "DiffAdd",
			GitConflictAncestorMark = "Visual",
			GitConflictIncomingMark = "DiffChange",
			GitConflictCurrent = "DiffAdd",
			GitConflictAncestor = "Visual",
			GitConflictMiddle = "Visual",
			GitConflictIncoming = "DiffChange",
		},
		signs = {
			priority = 10,
			definitions = {
				-- The sign definitions you provide will automatically be instantiated for you.
				GitConflictCurrentMark = {
					linehl = "GitConflictCurrentMark",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitConflictAncestorMark = {
					linehl = "GitConflictAncestorMark",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitConflictIncomingMark = {
					linehl = "GitConflictIncomingMark",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitConflictCurrent = {
					linehl = "GitConflictCurrent",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitConflictAncestor = {
					linehl = "GitConflictAncestor",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitConflictMiddle = {
					linehl = "GitConflictMiddle",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitConflictIncoming = {
					linehl = "GitConflictIncoming",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitSignsAddLn = {
					linehl = "GitSignsAddLn",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitSignsDeleteLn = {
					linehl = "GitSignsDeleteLn",
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = "",
				},
				GitSignsAdd = {
					texthl = "GitSignsAdd",
					numhl = nil,
					icon = nil,
					linehl = nil,
					text = "│",
				},
				GitSignsDelete = {
					texthl = "GitSignsDelete",
					numhl = nil,
					icon = nil,
					linehl = nil,
					text = "│",
				},
				GitSignsChange = {
					texthl = "GitSignsChange",
					numhl = nil,
					icon = nil,
					linehl = nil,
					text = "│",
				},
			},
			usage = {
				-- Please ensure these signs are defined.
				screen = {
					add = "GitSignsAddLn",
					remove = "GitSignsDeleteLn",
					conflict_current_mark = "GitConflictCurrentMark",
					conflict_current = "GitConflictCurrent",
					conflict_middle = "GitConflictMiddle",
					conflict_incoming_mark = "GitConflictIncomingMark",
					conflict_incoming = "GitConflictIncoming",
					conflict_ancestor_mark = "GitConflictAncestorMark",
					conflict_ancestor = "GitConflictAncestor",
				},
				main = {
					add = "GitSignsAdd",
					remove = "GitSignsDelete",
					change = "GitSignsChange",
				},
			},
		},
		symbols = {
			void = "⣿",
			open = "",
			close = "",
		},
	},
})
