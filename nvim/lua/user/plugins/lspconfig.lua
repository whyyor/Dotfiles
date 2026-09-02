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
		"gopls",
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

-- NOTE: formatting on save is handled by lsp_zero.buffer_autoformat() above,
-- which correctly hooks BufWritePre. A BufWritePost hook would format after
-- the file already hit disk, leaving a dirty buffer and unformatted file.

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
vim.lsp.config.ts_ls = {
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}

-- setup json for all sorts of languages
vim.lsp.config.jsonls = {
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}

vim.lsp.config.lua_ls = {
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}

vim.lsp.config.pylsp = {
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}

vim.lsp.config.dockerls = {
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
	end,
}

vim.lsp.config.nil_ls = {
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
	end,
}

vim.lsp.config.clangd = {
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
	end,
}

-- gopls owns Go formatting: gofumpt ruleset + organizeImports, no null-ls needed
vim.lsp.config.gopls = {
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				nilness = true,
				useany = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
	end,
}

-- Must run before formatting; synchronous so it cannot race the write
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	group = vim.api.nvim_create_augroup("user.go.imports", { clear = true }),
	callback = function(args)
		local params = vim.lsp.util.make_range_params(0, "utf-8")
		params.context = { only = { "source.organizeImports" }, diagnostics = {} }
		local res = vim.lsp.buf_request_sync(args.buf, "textDocument/codeAction", params, 1000)
		for cid, r in pairs(res or {}) do
			for _, action in pairs(r.result or {}) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
				elseif action.command then
					local client = vim.lsp.get_client_by_id(cid)
					if client then
						client:exec_cmd(action.command, { bufnr = args.buf })
					end
				end
			end
		end
	end,
})
