require("markview").setup({
	highlight_groups = vim.list_extend(
		require("markview").configuration.highlight_groups,
		require("markview.presets").heading.label_hls
	),

	headings = require("markview.presets").heading.label,

	buf_ignore = { "nofile" },
	modes = { "n" },

	code_blocks = {
		style = "language",
		hl = "dark",
	},
})

-- require("render-markdown").setup({
-- 	file_types = { "markdown", "vimwiki" },
-- 	highlights = {
-- 		code = "markdownCodeBlock",
-- 	},
-- })

-- vim.api.nvim_set_hl(0, "markdownCodeBlock", { bg = "none" })
