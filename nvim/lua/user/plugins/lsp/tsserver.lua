local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
	end,
})
