require("neo-tree").setup({
	popup_border_style = "",
	default_component_configs = {
		container = {
			enable_character_fade = true,
		},
		indent = {
			padding = 0,
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
		},
		git_status = {
			symbols = {
				added = "",
				modified = "",
				deleted = "✖",
				renamed = "󰁕",
				untracked = "",
				ignored = "",
				unstaged = "󰄱",
				staged = "",
				conflict = "",
			},
		},
	},
	commands = {
		-- Add a custom command for Flash.nvim
		flash_jump = function()
			require("flash").jump()
		end,
	},
	window = {
		position = "right",
		width = 30,
		mappings = {
			["s"] = "flash_jump",
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_hidden = false,
		},
		follow_current_file = {
			enabled = true,
			leave_dirs_open = true,
		},
	},
})

vim.keymap.set("n", "<Leader>n", ":Neotree toggle<CR>")

-- Monokai-themed neotree highlights
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- Make backgrounds transparent
		local transparent_groups = {
			"NeoTreePrompt",
			"NeoTreeFloatNormal",
			"NeoTreeFloatBorder",
			"FloatBorder",
			"NeoTreeNormal",
			"NeoTreeNormalNC",
			"NeoTreeFloatTitle",
			"NormalFloat",
		}
		for _, group in ipairs(transparent_groups) do
			vim.cmd(string.format("highlight %s guibg=none ctermbg=none", group))
		end

		-- Monokai color scheme
		vim.cmd([[
			" Cursor and selection
			highlight NeoTreeCursorLine guibg=#2c2525 ctermbg=204 ctermfg=0
			
			" Directories - Cyan like your terminal
			highlight NeoTreeDirectoryName guifg=#ffffff ctermfg=117 guibg=none ctermbg=none
			highlight NeoTreeDirectoryIcon guifg=#78DCE8 ctermfg=117 guibg=none ctermbg=none
			
			" Files - White/light gray
			highlight NeoTreeFileName guifg=#ffffff ctermfg=15 guibg=none ctermbg=none
			highlight NeoTreeFileIcon guifg=#ffffff ctermfg=15 guibg=none ctermbg=none
			
			" Git status colors
			highlight NeoTreeGitAdded guifg=#A9DC76 ctermfg=150
			highlight NeoTreeGitModified guifg=#FFD866 ctermfg=221
			highlight NeoTreeGitDeleted guifg=#FF6188 ctermfg=204
			highlight NeoTreeGitConflict guifg=#FF6188 ctermfg=204
			highlight NeoTreeGitUntracked guifg=#78DCE8 ctermfg=117
			highlight NeoTreeGitIgnored guifg=#75715e ctermfg=242
			highlight NeoTreeGitUnstaged guifg=#FFD866 ctermfg=221
			highlight NeoTreeGitStaged guifg=#A9DC76 ctermfg=150
			
			" Root and special elements
			highlight NeoTreeRootName guifg=#FF6188 ctermfg=204 gui=bold cterm=bold
			highlight NeoTreeFilterTerm guifg=#FF6188 ctermfg=204 gui=bold cterm=bold
			
			" Indent markers and expanders
			highlight NeoTreeIndentMarker guifg=#75715e ctermfg=242
			highlight NeoTreeExpander guifg=#FFD866 ctermfg=221
			
			" Dotfiles and hidden
			highlight NeoTreeDotfile guifg=#75715e ctermfg=242
			highlight NeoTreeHiddenByName guifg=#75715e ctermfg=242
			highlight NeoTreeWindowsHidden guifg=#75715e ctermfg=242
			
			" Stats and headers
			highlight NeoTreeStats guifg=#75715e ctermfg=242
			highlight NeoTreeStatsHeader guifg=#FFD866 ctermfg=221 gui=bold cterm=bold
			
			" Symbolic links
			highlight NeoTreeSymbolicLinkTarget guifg=#78DCE8 ctermfg=117 gui=italic cterm=italic
			
			" Dimmed text
			highlight NeoTreeDimText guifg=#75715e ctermfg=242
			
			" Buffer numbers
			highlight NeoTreeBufferNumber guifg=#FFD866 ctermfg=221
		]])
	end,
})

vim.cmd("doautocmd ColorScheme")
