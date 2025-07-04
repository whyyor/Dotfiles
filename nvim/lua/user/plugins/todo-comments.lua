local todoComments = require("todo-comments")

todoComments.setup({
	keywords = {
		FIX = {
			icon = " ",
			color = "error",
			alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
		},
		TODO = { icon = " ", color = "todo" },
		HACK = { icon = " ", color = "hack" },
		WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
		PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
		NOTE = { icon = " ", color = "info", alt = { "INFO" } },
		TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
	},
	colors = {
		error = { "#ff6188" },
		hack = { "#ffd866" },
		warning = { "#fc9867" },
		todo = { "#66d9ef" },
		info = { "#ab9df2" },
		hint = { "#ab9df2" },
		default = { "#fc9867" },
		test = { "#a9dc76" },
	},
	highlight = {
		comments_only = true,
		before = "",
		keyword = "wide",
		after = "fg",
		pattern = [[.*<(KEYWORDS)\s*:]],
	},
})
