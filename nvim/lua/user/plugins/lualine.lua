local separator = { '"▏"', color = "StatusLineNonText" }

require("lualine").setup({
	options = {
		section_separators = "",
		component_separators = "",
		globalstatus = true,
		theme = {
			normal = {
				a = "StatusLine",
				b = "StatusLine",
				c = "StatusLine",
			},
		},
	},
	sections = {
		lualine_a = {
			"mode",
			separator,
		},
		lualine_b = {
			"branch",
			"diff",
			separator,
			--number to language server client running in each buffer
			'"  " .. tostring(#vim.tbl_keys(vim.lsp.buf_get_clients()))',
			--how many syntax error in buffer
			{ "diagnostics", sources = { "nvim_diagnostic" } },
			separator,
		},
		lualine_c = {
			"filename",
		},
		lualine_x = {
			"filetype",
			"encoding",
			"fileformat",
			{
				color = { fg = "#ff9e64" },
			},
		},
		lualine_y = {
			separator,
			'(vim.bo.expandtab and " " or "󱁤 ") .. " " .. vim.bo.shiftwidth',
			separator,
		},
		lualine_z = {
			"location",
			"progress",
		},
	},
})
