-- floaterm

local function setup_floaterm()
	vim.g.floaterm_width = 0.8
	vim.g.floaterm_height = 0.8
	vim.g.floaterm_borderchars = { " ", " ", " ", " ", " ", " ", " ", " " }
	vim.g.floaterm_title = ""
	vim.keymap.set("n", "<C-t>", ":FloatermToggle<CR>")
	vim.keymap.set("t", "<C-t>", "<C-\\><C-n>:FloatermToggle<CR>")
	vim.cmd([[
	highlight Floaterm guibg=#1e1e1e guifg=NONE
	highlight FloatermBorder guibg=#1e1e1e guifg=NONE
    ]])
end

vim.defer_fn(setup_floaterm, 100)
