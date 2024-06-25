-- vimwiki.lua
local M = {}

M.setup = function()
	vim.g.vimwiki_key_mappings = { table_mappings = 0 }
vim.treesitter.language.register('markdown', 'vimwiki')
	vim.g.vimwiki_list = {
		{
			path = "~/notes",
			syntax = "markdown",
			ext = ".md",
		},
	}
end

return M
