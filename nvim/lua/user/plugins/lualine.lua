local function config_lualine(colors)
	local mode_colors = {
		n = { fg = colors.white, bg = colors.red },  -- Normal mode
		i = { fg = colors.bg, bg = colors.cyan },    -- Insert mode
		v = { fg = colors.white, bg = colors.purple }, -- Visual mode
		[""] = { fg = colors.white, bg = colors.purple }, -- Visual block
		V = { fg = colors.white, bg = colors.red },  -- Visual line
		c = { fg = colors.bg, bg = colors.yellow },
		no = { fg = colors.white, bg = colors.red },
		s = { fg = colors.bg, bg = colors.yellow },
		S = { fg = colors.bg, bg = colors.yellow },
		[""] = { fg = colors.bg, bg = colors.yellow },
		ic = { fg = colors.bg, bg = colors.yellow },
		R = { fg = colors.bg, bg = colors.green },
		Rv = { fg = colors.white, bg = colors.purple },
		cv = { fg = colors.white, bg = colors.red },
		ce = { fg = colors.white, bg = colors.red },
		r = { fg = colors.bg, bg = colors.cyan }, -- Prompt mode
		rm = { fg = colors.bg, bg = colors.cyan },
		["r?"] = { fg = colors.bg, bg = colors.cyan },
		["!"] = { fg = colors.white, bg = colors.red },
		t = { fg = colors.white, bg = colors.red }, -- Terminal mode
	}

	local theme = {
		normal = {
			a = { fg = colors.white, bg = colors.blue },
			b = { fg = colors.blue, bg = colors.bg_dark },
			c = { fg = colors.white, bg = colors.bg_dark },
			z = { fg = colors.white, bg = colors.bg_dark },
		},
		insert = { a = { fg = colors.bg_dark, bg = colors.yellow } },
		visual = { a = { fg = colors.bg, bg = colors.green } },
		replace = { a = { fg = colors.bg, bg = colors.green } },
	}

	local filetype = {
		function()
			local ft = vim.bo.filetype
			local icon = require("nvim-web-devicons").get_icon_by_filetype(ft) or ""
			local filename = vim.fn.expand("%:t")
			return string.format("%s | %s", icon, filename)
		end,
		icons_enabled = true,
		color = { bg = colors.bg_dark, fg = colors.white, gui = "nocombine" },
		separator = { left = "", right = "" },
	}

	local folder = {
		function()
			local dir = vim.fn.expand("%:p:h")
			local folder_name = vim.fn.fnamemodify(dir, ":t")
			return folder_name ~= "" and folder_name or "no folder"
		end,
		icon = "",
		color = { bg = colors.bg, fg = colors.white },
		separator = { left = "", right = "" },
		draw_empty = true,
	}

	local branch = {
		"branch",
		icon = "",
		color = { bg = colors.bg, fg = colors.white },
		separator = { left = "", right = "" }, -- Use custom highlight
		draw_empty = true,
	}

	local location = {
		"location",
		icon = "",
		color = function()
			local current_mode = vim.fn.mode()
			return { bg = mode_colors[current_mode].bg, fg = mode_colors[current_mode].fg, gui = "nocombine" }
		end,
		separator = { left = "", right = "" },
	}

	local diff = {
		"diff",
		color = { bg = colors.bg_dark, fg = colors.bg, gui = "bold" },
		separator = { left = "", right = "" },
		symbols = { added = " ", modified = " ", removed = " " },

		diff_color = {
			added = { fg = colors.green },
			modified = { fg = colors.yellow },
			removed = { fg = colors.red },
		},
	}

	local modes = {
		"mode",
		icon = "",
		color = function()
			local current_mode = vim.fn.mode()
			return { bg = mode_colors[current_mode].bg, fg = mode_colors[current_mode].fg, gui = "nocombine" }
		end,
		separator = { left = "", right = "" },
	}

	local function getLspName()
		local bufnr = vim.api.nvim_get_current_buf()
		local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
		local buf_ft = vim.bo.filetype
		if next(buf_clients) == nil then
			return " 0"
		end
		local buf_client_names = {}

		for _, client in pairs(buf_clients) do
			if client.name ~= "null-ls" then
				table.insert(buf_client_names, client.name)
			end
		end

		local lint_s, lint = pcall(require, "lint")
		if lint_s then
			for ft_k, ft_v in pairs(lint.linters_by_ft) do
				if type(ft_v) == "table" then
					for _, linter in ipairs(ft_v) do
						if buf_ft == ft_k then
							table.insert(buf_client_names, linter)
						end
					end
				elseif type(ft_v) == "string" then
					if buf_ft == ft_k then
						table.insert(buf_client_names, ft_v)
					end
				end
			end
		end

		local ok, conform = pcall(require, "conform")
		local formatters = table.concat(conform.list_formatters_for_buffer(), " ")
		if ok then
			for formatter in formatters:gmatch("%w+") do
				if formatter then
					table.insert(buf_client_names, formatter)
				end
			end
		end

		local hash = {}
		local unique_client_names = {}

		for _, v in ipairs(buf_client_names) do
			if not hash[v] then
				unique_client_names[#unique_client_names + 1] = v
				hash[v] = true
			end
		end
		local language_servers = table.concat(unique_client_names, ", ")

		return "  " .. language_servers
	end

	local function recording()
		local reg = vim.fn.reg_recording()
		if reg == "" then
			return ""
		end -- not recording
		return "󰑊 REC"
	end

	local macro = {
		recording,
		separator = { left = "", right = "" },
		color = { fg = "white", bg = "#FF746C" },
	}

	local dia = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		symbols = { error = " ", warn = " ", info = " ", hint = " " },
		diagnostics_color = {
			error = { fg = colors.red },
			warn = { fg = colors.yellow },
			info = { fg = colors.purple },
			hint = { fg = colors.cyan },
		},
		color = { bg = colors.bg_dark, fg = colors.blue, gui = "bold" },
		separator = { left = "", right = "" },
	}

	require("lualine").setup({
		options = {
			disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
			icons_enabled = true,
			theme = theme,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = true,
		},

		sections = {
			lualine_a = {
				modes,
			},
			lualine_b = {
				branch,
				diff,
			},
			lualine_c = {
				dia,
			},
			lualine_x = {
				filetype,
			},
			lualine_y = { macro, folder },
			lualine_z = {
				location,
			},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
	})
end

local colors = {
	bg = "#161617",
	fg = "#c9c7cd",
	darkBackground = "#0B0E14",
	currentLine = "#0F131A",
	selection = "#5b595c",
	fg_dark = "#fcfcfa",
	comment = "#727072",
	red = "#f92572",
	orange = "#fc9867",
	yellow = "#ffd866",
	green = "#a9dc76",
	cyan = "#78dce8",
	blue = "#ab9df2",
	purple = "#ab9df2",
	border = "#403e41",
	bg_dark = "none",
	white = "#ffffff",
}
config_lualine(colors)
vim.o.laststatus = vim.g.lualine_laststatus

vim.cmd("highlight LualineSeparator guibg=" .. "NONE" .. " guifg=" .. "NONE")
