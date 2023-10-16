local null_ls = require("null-ls")
local lSsources = {
  -- add language servers here
  null_ls.builtins.formatting.prettier.with({
    filetypes = {
      "vimwiki",
      "md",
      "yaml"
    },
  }),

  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.stylua,
}
null_ls.setup({
  sources = lSsources,
})
