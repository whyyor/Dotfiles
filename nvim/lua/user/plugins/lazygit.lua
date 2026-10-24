vim.g.lazygit_floating_window_use_plenary = 0
vim.g.lazygit_floating_window_winblend = 0
vim.g.lazygit_floating_window_border_chars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

vim.keymap.set("n", "<leader>l", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })

-- plugin links this to Normal (near white); match lualine's #403e41 border instead
vim.api.nvim_set_hl(0, "LazyGitBorder", { fg = "#403e41", bg = "NONE" })
