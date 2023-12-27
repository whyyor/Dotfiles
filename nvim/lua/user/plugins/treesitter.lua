require("nvim-treesitter.configs").setup({
	-- ensure_installed = "all",
	auto_install = true,
	-- INFO: Automatically install parser for detected language on the go
	-- WARNING: Set ensure_installed to all if you encounter treesitter issues
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["if"] = "@function.inner",
				["af"] = "@function.outer",
				["ia"] = "@parameter.inner",
				["aa"] = "@parameter.outer",
			},
		},
	},
})

require("ts_context_commentstring").setup({
	enable = true,
	-- additional configuration if needed
})

vim.g.skip_ts_context_commentstring_module = true
