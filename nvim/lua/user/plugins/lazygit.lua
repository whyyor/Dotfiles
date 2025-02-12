vim.g.lazygit_floating_window_use_plenary = 0
vim.g.lazygit_floating_window_winblend = 0
vim.g.lazygit_floating_window_border_chars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

vim.keymap.set("n", "<leader>l", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
