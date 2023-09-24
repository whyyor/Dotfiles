-- vimwiki.lua
local M = {}

M.setup = function()
  vim.g.vimwiki_list = {
    {
      path = "~/notes",
      syntax = "markdown",
      ext = ".md",
    },
  }
end

return M
