vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

require("nvim-treesitter").install({
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"bash",
	"json",
	"yaml",
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"python",
	"go",
	"rust",
	"c",
	"cpp",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user.treesitter", { clear = true }),
	callback = function(args)
		local buf = args.buf
		local filetype = args.match

		local skip = {
			dashboard = true,
			alpha = true,
			NvimTree = true,
			["neo-tree"] = true,
			["neo-tree-popup"] = true,
			TelescopePrompt = true,
			TelescopeResults = true,
			lazy = true,
			mason = true,
			lspinfo = true,
			checkhealth = true,
			help = true,
			qf = true,
			noice = true,
			notify = true,
			trouble = true,
			Outline = true,
			oil = true,
		}
		if skip[filetype] then
			return
		end

		local lang = vim.treesitter.language.get_lang(filetype) or filetype

		pcall(function()
			vim.treesitter.start(buf, lang)

			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo.foldmethod = "expr"
			vim.wo.foldlevel = 99
		end)
	end,
})

local ts_select = function(capture)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
	end
end

for _, mode in ipairs({ "x", "o" }) do
	vim.keymap.set(mode, "if", ts_select("@function.inner"), { desc = "Inner function" })
	vim.keymap.set(mode, "af", ts_select("@function.outer"), { desc = "Outer function" })
	vim.keymap.set(mode, "ia", ts_select("@parameter.inner"), { desc = "Inner parameter" })
	vim.keymap.set(mode, "aa", ts_select("@parameter.outer"), { desc = "Outer parameter" })
end

require("ts_context_commentstring").setup({
	enable = true,
})

vim.g.skip_ts_context_commentstring_module = true
