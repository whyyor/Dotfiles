require('monokai').setup({})


vim.cmd("colorscheme monokai_pro")

vim.api.nvim_set_hl(0, "FloatBorder", {
    fg = vim.api.nvim_get_hl_by_name("NormalFloat", true).background,
    bg = vim.api.nvim_get_hl_by_name("NormalFloat", true).background,
})

-- Make the cursor line background invisible
vim.api.nvim_set_hl(0, "CursorLineBg", {
    fg = vim.api.nvim_get_hl_by_name("CursorLine", true).background,
    bg = vim.api.nvim_get_hl_by_name("CursorLine", true).background,
})

vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#30323E" })

vim.api.nvim_set_hl(0, "StatusLineNonText", {
    fg = vim.api.nvim_get_hl_by_name("NonText", true).foreground,
    bg = vim.api.nvim_get_hl_by_name("StatusLine", true).background,
})

vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#2F313C" })
