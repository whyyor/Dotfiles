local trouble = require("trouble")

trouble.setup({
	opts = {
		mode = "workspace_diagnostics",
	},
})

vim.keymap.set("n", "<leader>pp", function()
	require("trouble").toggle()
end)
vim.keymap.set("n", "<leader>pw", function()
	require("trouble").toggle("workspace_diagnostics")
end)
vim.keymap.set("n", "<leader>pf", function()
	require("trouble").toggle("document_diagnostics")
end)
vim.keymap.set("n", "<leader>pq", function()
	require("trouble").toggle("quickfix")
end)
vim.keymap.set("n", "<leader>pl", function()
	require("trouble").toggle("loclist")
end)
vim.keymap.set("n", "gR", function()
	require("trouble").toggle("lsp_references")
end)
