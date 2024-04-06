-- vimwiki.lua
local M = {}

M.setup = function()
	vim.g.vimwiki_key_mappings = { table_mappings = 0 }
	vim.g.vimwiki_list = {
		{
			path = "~/notes",
			syntax = "markdown",
			ext = ".md",
		},
	}
end

return M
