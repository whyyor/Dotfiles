require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	keymaps = {
		["<C-h>"] = false,
		["<C-l>"] = false,
	},
})

local function toggle_oil()
	-- Check if current buffer is Oil
	if vim.bo.filetype == "oil" then
		-- Close Oil (go back to previous buffer or close window)
		vim.cmd("bd") -- or vim.cmd("q")
	else
		-- Open Oil
		require("oil").open()
	end
end

vim.keymap.set("n", "<Leader>n", toggle_oil, { desc = "Toggle Oil file explorer" })
