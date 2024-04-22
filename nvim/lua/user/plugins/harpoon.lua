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

-- Harpoon looks
vim.api.nvim_create_autocmd({ "Filetype" }, {
	pattern = "harpoon",
	callback = function()
		vim.opt.cursorline = true
		vim.opt.winblend = 20
		vim.api.nvim_set_hl(0, "HarpoonWindow", { link = "Normal" })
		vim.api.nvim_set_hl(0, "HarpoonBorder", { link = "Normal" })
	end,
})

-- Harpoon Keymaps
vim.keymap.set("n", "<Leader>j", ":Telescope harpoon marks<CR>", { desc = "Open harpoon via telescope" })
vim.keymap.set("n", "<Leader>v", "<cmd>lua require('harpoon'):list():add()<cr>", { desc = "Mark file with harpoon" })
vim.keymap.set(
	"n",
	"<Leader>z",
	"<cmd>lua require('harpoon'):list():remove()<cr>",
	{ desc = "Remove file from harpoon" }
)
vim.keymap.set("n", "[n", "<cmd>lua require('harpoon'):list():next()<cr>", { desc = "Go to next harpoon mark" })
vim.keymap.set("n", "]n", "<cmd>lua require('harpoon'):list():prev()<cr>", { desc = "Go to prev harpoon mark" })
vim.keymap.set("n", "<Leader>cc", "<cmd>lua require('harpoon'):list():clear()<cr>", { desc = "Clear all marks" })

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
vim.keymap.set("n", "<leader>6", function()
	harpoon:list():select(6)
end)
vim.keymap.set("n", "<leader>7", function()
	harpoon:list():select(7)
end)
vim.keymap.set("n", "<leader>8", function()
	harpoon:list():select(8)
end)
vim.keymap.set("n", "<leader>9", function()
	harpoon:list():select(9)
end)
