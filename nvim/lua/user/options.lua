vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.number = true
vim.opt.relativenumber = true

-- Remove all the separators and decrease length
vim.opt.numberwidth = 1
vim.opt.fillchars = {
	horiz = " ",
	horizup = " ",
	horizdown = " ",
	vert = " ",
	vertleft = " ",
	vertright = " ",
	verthoriz = " ",
}

vim.opt.wildmode = "longest:full,full" -- complete the longest common match, and allow tabbing the results to fully complete them
vim.opt.completeopt = "menuone,longest,preview"

vim.opt.title = true
vim.opt.mouse = "a" -- enable mouse for all modes

vim.opt.termguicolors = true

vim.opt.spell = true

vim.opt.ignorecase = true
vim.opt.smartcase = true -- it becomes cases sensitive if we put in capital letters

vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = "▸ ", trail = "·" }
vim.opt.fillchars:append({ eob = " " }) -- remove the ~ from end of buffer

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.scrolloff = 16
vim.opt.sidescrolloff = 16

vim.opt.clipboard = "unnamedplus" -- Use system clipboard

vim.opt.confirm = true -- ask for confirmation instead of erroring

vim.opt.signcolumn = "yes:2"

vim.o.cmdheight = 0

vim.opt.undofile = true -- persistent undo
vim.opt.backup = true -- automatically save a backup file
vim.opt.backupdir:remove(".") -- keep backups out of the current directory

vim.opt.showmode = false

-- INFO: Sets up transparency

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local highlights = {
			"Normal",
			"NormalFloat",
			"Pmenu",
			"PmenuSbar",
			"LineNr",
			"Folded",
			"NonText",
			"SpecialKey",
			"VertSplit",
			"SignColumn",
			"EndOfBuffer",
			"TablineFill",
			"WinSeperator",
		}
		for _, name in pairs(highlights) do
			vim.cmd.highlight(name .. " guibg=none ctermbg=none")
		end
	end,
})
