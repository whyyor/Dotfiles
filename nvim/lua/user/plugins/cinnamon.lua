require("cinnamon").setup({
	opts = {
		keymaps = {
			basic = true,
			extra = true,
		},
		options = {
			mode = "cursor",
			delay = 5,
			step_size = {
				vertical = 1,
				horizontal = 0,
			},
			max_delta = {
				line = false,
				column = false,
				time = 2000,
			},
			callback = function() end,
		},
	},
})

