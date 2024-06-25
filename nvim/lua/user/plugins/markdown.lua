require("render-markdown").setup({
	file_types = { "markdown", "vimwiki" },
	highlights = {
		code = "markdownCodeBlock",
	},
})

vim.api.nvim_set_hl(0, "markdownCodeBlock", { bg = "none" })
