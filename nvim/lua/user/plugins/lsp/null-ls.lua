local null_ls = require("null-ls")
local lSsources = {
  -- add language servers here
  null_ls.builtins.formatting.prettier.with({
    filetypes = {
      "yaml",
    },
  }),
  null_ls.builtins.formatting.stylua,
}
null_ls.setup({
  sources = lSsources,
})
