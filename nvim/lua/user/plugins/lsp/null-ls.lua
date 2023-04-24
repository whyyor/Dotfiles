local null_ls = require("null-ls")
local lSsources = {
	-- add language servers here
	null_ls.builtins.formatting.prettier.with({
		filetypes = {
			"css",
			"scss",
			"html",
			"json",
			"yaml",
			"markdown",
			"graphql",
			"md",
			"txt",
		},
	}),
	null_ls.builtins.formatting.stylua,
}
null_ls.setup({
	sources = lSsources,
})
