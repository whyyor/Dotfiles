require("ibl").setup({
	exclude = {
		filetypes = {
			"dashboard",
			"help",
			"terminal",
			"packer",
			"lspinfo",
			"TelescopePrompt",
			"TelescopeResults",
		},
		buftypes = {
			"terminal",
			"NvimTree",
		},
	},
	indent = { char = "" },
	debounce = 100,
	whitespace = { highlight = { "Whitespace", "NonText" } },
})

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
