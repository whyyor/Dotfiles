-- Space is my leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided.
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Reselect visual selection after indenting.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Maintain the cursor position when yanking a visual selection.
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.keymap.set("v", "y", "myy`y")

-- Disable annoying command line typo.
vim.keymap.set("n", "q:", ":q")

-- Paste replace visual selection without copying it.
vim.keymap.set("v", "p", '"_dP')

-- Easy insertion of a trailing ; or , from insert mode.
vim.keymap.set("i", ";;", "<Esc>A;")
vim.keymap.set("i", ",,", "<Esc>A,")

-- Quickly clear search highlighting.
vim.keymap.set("n", "<Leader>k", ":nohlsearch<CR>")

-- autosave on buffer change
vim.cmd("autocmd BufHidden * silent! :wa")

-- Exit
vim.keymap.set("n", "<Leader>x", ":q<CR>")

-- Exit all
vim.keymap.set("n", "<Leader>X", ":qa<CR>")

-- Open the current file in the default program (on Mac this should just be just `open`).
vim.keymap.set("n", "<Leader>O", ":!open %<CR><CR>")

-- save file
vim.keymap.set("n", "<Leader>s", ":w<CR>")

-- Move lines up and down.
vim.keymap.set("i", "<fn-C-j>", "<Esc>:move .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:move .-2<CR>==gi")
vim.keymap.set("n", "<A-j>", ":move .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":move .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":move '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":move '<-2<CR>gv=gv")

-- Current date
vim.api.nvim_set_keymap("n", "<Leader>wd", ":r!date +\\%Y-\\%m-\\%d<CR>", { noremap = true, silent = true })

-- Plugin keybindings
vim.keymap.set("n", "<Leader>q", ":Bdelete<CR>")

-- Wiki keybindings
vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>")
vim.keymap.set("n", "<leader>ml", ":VimwikiFollowLink<CR>")
vim.keymap.set("n", "<leader>mt", ":VimwikiNextLink<CR>")
vim.keymap.set("n", "<leader>mp", ":VimwikiPrevLink<CR>")

-- Set up the key mappings
vim.keymap.set("n", "<A-up>", ":resize +2<CR>")
vim.keymap.set("n", "<A-down>", ":resize -2<CR>")
vim.keymap.set("n", "<A-right>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<A-left>", ":vertical resize -2<CR>")

-- Functions to goto proper diagnostics
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

-- Keymaps
vim.keymap.set("n", "<Leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>")
vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
