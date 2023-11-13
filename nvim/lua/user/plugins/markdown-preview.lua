-- markdown-preview.lua
local function setup_markdown_preview()
		vim.g.mkdp_filetypes = { "markdown" }
	vim.g.mkdp_browser = "firefox"
	vim.g.mkdp_auto_start = 0
	vim.g.mkdp_auto_close = 1
	vim.g.mkdp_refresh_slow = 0
	vim.g.mkdp_command_for_global = 0
	vim.g.mkdp_open_to_the_world = 0
	vim.g.mkdp_open_ip = ""
	vim.g.mkdp_echo_preview_url = 0
	vim.g.mkdp_browserfunc = ""
	vim.g.mkdp_theme = "dark"
	vim.g.mkdp_page_title = "${name}.md"
	vim.g.mkdp_preview_options = {
		disable_sync_scroll = 0,
		disable_filename = 1,
	}
end

return setup_markdown_preview
