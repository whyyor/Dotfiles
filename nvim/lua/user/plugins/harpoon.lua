local harpoon = require("harpoon")

harpoon:setup({
	global_settings = {
		save_on_toggle = false,
		save_on_change = true,
		enter_on_sendcmd = false,
		tmux_autoclose_windows = false,
		excluded_filetypes = { "harpoon" },
		mark_branch = true,
		tabline = false,
		tabline_prefix = " ",
		tabline_suffix = " ",
	},
})

-- Adding marks opening harpoon
vim.keymap.set("n", "<leader>;x", function()
	harpoon:list():append()
end)
vim.keymap.set("n", "<Leader>;f", ":Telescope harpoon marks<CR>")

-- Cycle through files
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end)
vim.keymap.set("n", "<leader>5", function()
	harpoon:list():select(5)
end)
