local lspconfig = require("lspconfig")

lspconfig.html.setup({
  filetypes = {
    "html",
    "htmldjango",
  },
})
