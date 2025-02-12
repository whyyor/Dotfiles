local colors = {
	add = "#acd385", -- Greenish color for added lines
	change = "#D7D7D7", -- Yellow/Orange for modified lines
	delete = "#f65a81", -- Red for deleted lines
	changedelete = "#ffd766", -- Purple for changed + deleted (distinctive)
}

require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "│" },
		untracked = { text = "┆" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	on_attach = function()
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.add, bg = "NONE" })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colors.change, bg = "NONE" })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.delete, bg = "NONE" })
		vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = colors.changedelete, bg = "NONE" })
	end,
})
