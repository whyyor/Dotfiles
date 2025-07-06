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

vim.opt.wildmode =
"longest:full,full"                    -- complete the longest common match, and allow tabbing the results to fully complete them
vim.opt.completeopt = "menuone,longest,preview"

vim.opt.title = true
vim.opt.mouse = "a" -- enable mouse for all modes

vim.opt.termguicolors = true

vim.opt.spell = true

vim.opt.ignorecase = true
vim.opt.smartcase = true                -- it becomes cases sensitive if we put in capital letters

vim.opt.list = true                     -- enable the below listchars
vim.opt.listchars = { tab = "▸ ", trail = "·" }
vim.opt.fillchars:append({ eob = " " }) -- remove the ~ from end of buffer

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.scrolloff = 16
vim.opt.sidescrolloff = 16

vim.opt.clipboard = "unnamedplus" -- Use system clipboard

vim.opt.confirm = true            -- ask for confirmation instead of erroring

vim.opt.signcolumn = "yes:2"

vim.o.cmdheight = 0

vim.opt.undofile = true       -- persistent undo
vim.opt.backup = true         -- automatically save a backup file
vim.opt.backupdir:remove(".") -- keep backups out of the current directory

vim.opt.showmode = false

-- INFO: Sets up transparency
local function setup_transparency()
	local highlights = {
		"Normal",
		"NormalFloat",
		"NormalNC",
		"Pmenu",
		"PmenuSbar",
		"PmenuThumb",
		"LineNr",
		"CursorLineNr",
		"Folded",
		"NonText",
		"SpecialKey",
		"VertSplit",
		"WinSeparator",
		"SignColumn",
		"EndOfBuffer",
		"TablineFill",
		"StatusLine",
		"StatusLineNC",
		"MsgArea",
		"MsgSeparator",
		-- Lualine specific highlights
		"lualine_c_normal",
		"lualine_c_inactive",
		"lualine_c_insert",
		"lualine_c_visual",
		"lualine_c_replace",
		"lualine_c_command",
		"lualine_c_terminal",
	}

	for _, name in pairs(highlights) do
		vim.cmd.highlight(name .. " guibg=NONE ctermbg=NONE")
	end

	-- Force lualine highlights to be transparent
	vim.cmd([[
		highlight! link LualineSeparator Normal
		highlight LualineSeparator guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE
	]])
end

-- Set up transparency on ColorScheme events
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = setup_transparency,
})

-- Also set up transparency immediately
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Delay to ensure lualine is loaded
		vim.defer_fn(setup_transparency, 100)
	end,
})

-- Additional autocmd for when lualine refreshes
vim.api.nvim_create_autocmd("User", {
	pattern = "LualineRefresh",
	callback = setup_transparency,
})
