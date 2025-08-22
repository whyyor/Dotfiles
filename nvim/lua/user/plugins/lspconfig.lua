-- LSP Zero - Don't know what's it's doing
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
	lsp_zero.highlight_symbol(client, bufnr)
	lsp_zero.buffer_autoformat()
end)

lsp_zero.ui({
	float_border = "rounded",
	sign_text = {
		error = "✘",
		warn = "▲",
		hint = "⚑",
		info = "»",
	},
})

-- Setup Mason to automatically install LSP servers
require("mason").setup()

-- Null-ls Setup
require("user/plugins/lsp/null-ls")

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

require("lspconfig").nil_ls.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentFormattingRangeProvider = true
	end,
})

require("lspconfig").clangd.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentFormattingRangeProvider = true
	end,
})
