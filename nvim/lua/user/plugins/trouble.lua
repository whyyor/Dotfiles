local trouble = require("trouble")

trouble.setup({
	opts = {
		mode = "workspace_diagnostics",
	},
})

vim.keymap.set("n", "<leader>pp", function()
	require("trouble").toggle("diagnostics")
end)


-- Set Trouble background to transparent
vim.cmd([[
  highlight TroubleNormal guibg=none ctermbg=none
  highlight TroubleText guibg=none ctermbg=none
  highlight TroubleFile guibg=none ctermbg=none
  highlight TroubleFoldIcon guibg=none ctermbg=none
  highlight TroubleCount guibg=none ctermbg=none
  highlight TroubleLocation guibg=none ctermbg=none
  highlight TroubleIndent guibg=none ctermbg=none
  highlight TroubleSignError guibg=none ctermbg=none
  highlight TroubleSignWarning guibg=none ctermbg=none
  highlight TroubleSignInformation guibg=none ctermbg=none
  highlight TroubleSignHint guibg=none ctermbg=none
  highlight TroublePreview guibg=none ctermbg=none
  highlight TroubleCode guibg=none ctermbg=none
  highlight TroubleSource guibg=none ctermbg=none

  " Also set the background of the normal and normal float highlight groups to none
  highlight Normal guibg=none ctermbg=none
  highlight NormalNC guibg=none ctermbg=none
  highlight NormalFloat guibg=none ctermbg=none
  highlight NonText guibg=none ctermbg=none
]])
