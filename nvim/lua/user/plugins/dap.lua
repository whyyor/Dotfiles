local dap, dapui = require("dap"), require("dapui")

dapui.setup()

-- Auto open/close the UI with the debug session
dap.listeners.before.attach.dapui_config = dapui.open
dap.listeners.before.launch.dapui_config = dapui.open
dap.listeners.before.event_terminated.dapui_config = dapui.close
dap.listeners.before.event_exited.dapui_config = dapui.close

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

-- debugpy runs from Mason's venv; the debuggee uses the project's venv
local dap_python = require("dap-python")
dap_python.setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
dap_python.test_runner = "pytest"
dap_python.resolve_python = function()
	return require("user.python").path(vim.fs.root(0, { "pyproject.toml", "setup.py", ".git" }))
end
