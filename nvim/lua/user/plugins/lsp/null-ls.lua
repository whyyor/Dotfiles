-- INFO: Here we keep arb = json.
vim.filetype.add({
	extension = {
		arb = "json",
	},
})

local null_ls = require("null-ls")
local lSsources = {
	-- add language servers here
	null_ls.builtins.formatting.prettier,
	null_ls.builtins.formatting.black,
	null_ls.builtins.formatting.prettier.with({
		filetypes = {
			"vimwiki",
		},
	}),
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.diagnostics.ruff,
	-- INFO: If we move jq up for some reason, everything below it breaks.
	null_ls.builtins.formatting.jq,
}
null_ls.setup({
	sources = lSsources,
})
