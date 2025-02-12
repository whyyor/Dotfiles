local cmp = require("cmp")
local luasnip = require("luasnip")

local kind_icons = {
	Text = "󱄽",
	Method = "",
	Function = "󰆧",
	Constructor = "󰒓",
	Field = "󰜢",
	Variable = "󰫧",
	Class = "󰏆",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌆",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󱊐",
	Struct = "",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "",
}

local has_words_before = function()
	local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)

			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name] or ""

			return vim_item
		end,
	},
	mapping = {
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	window = {
		completion = {
			border = "solid",
			winhighlight = "Normal:None,FloatBorder:None,Search:None",
			scrollbar = false,
		},
		documentation = {
			border = "solid",
			winhighlight = "Normal:None,FloatBorder:None,CursorLine:None,Search:None",
			scrollbar = false,
		},
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	experimental = {
		ghost_text = true,
	},
})
