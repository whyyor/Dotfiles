require("clipboard-image").setup({
	default = {
		img_dir = { "%:p:h", "img" },
		img_dir_txt = "img",
		img_name = function()
			return os.date("%Y-%m-%d-%H-%M-%S")
		end,
		affix = "![](./%s)",
	},
})
