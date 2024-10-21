-- Setup Mason to automatically install LSP servers
require("mason").setup()

-- Null-ls Setup
require("user/plugins/lsp/null-ls")

-- Setup lsp-zero
local lsp_zero = require("lsp-zero")
lsp_zero.preset("recommended")

require("mason-lspconfig").setup({
	automatic_installation = true, -- Automatically install LSP servers.
	ensure_installed = {
		"cssls",
		"dockerls",
		"html",
		"eslint",
		"emmet_ls",
		"jsonls",
		"lua_ls",
		"prismals",
		"pyright",
		"pylsp",
		-- You may need to install python3-venv to install pylsp
		"ts_ls",
		"tailwindcss",
	},
})

require("user/plugins/lsp/html")
-- Use vpn if they don't install for some reason

--commands
vim.cmd("autocmd BufWritePost * lua vim.lsp.buf.format()")

-- Diagnostic configuration
vim.diagnostic.config({
	virtual_text = true,
	float = {
		source = true,
	},
})

-- Sign configuration
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- setup lsp_zero
lsp_zero.setup()

-- INFO: Configure language servers here
-- setup ts-server for all sorts of languages
require("lspconfig").ts_ls.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end,
})

-- setup json for all sorts of languages
require("lspconfig").jsonls.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end,
})

require("lspconfig").lua_ls.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end,
})

require("lspconfig").pylsp.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end,
})

require("lspconfig").dockerls.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentFormattingRangeProvider = true
	end,
})
