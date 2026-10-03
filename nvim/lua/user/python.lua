local M = {}

-- Resolve the interpreter for a project: active env > local venv > poetry > system
function M.path(root)
	root = root or vim.fn.getcwd()

	local env = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
	if env then
		return env .. "/bin/python"
	end

	for _, dir in ipairs({ ".venv", "venv", "env" }) do
		local py = root .. "/" .. dir .. "/bin/python"
		if vim.uv.fs_stat(py) then
			return py
		end
	end

	if vim.uv.fs_stat(root .. "/poetry.lock") and vim.fn.executable("poetry") == 1 then
		local out = vim.system({ "poetry", "env", "info", "-p" }, { cwd = root, text = true }):wait()
		if out.code == 0 then
			return vim.trim(out.stdout) .. "/bin/python"
		end
	end

	return vim.fn.exepath("python3")
end

return M
