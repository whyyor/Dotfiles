
-- floaterm

local function setup_floaterm()
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.keymap.set("n", "<C-t>", ":FloatermToggle<CR>")
    vim.keymap.set("t", "<C-t>", "<C-\\><C-n>:FloatermToggle<CR>")
    vim.cmd([[
        highlight link Floaterm CursorLine
        highlight link FloatermBorder CursorLineBg
      ]])
end

vim.defer_fn(setup_floaterm, 50)
