local status_ok, comment_config = pcall(require, "kommentary.config")
if not status_ok then
	vim.notify("comment_config not found!")
	return
end

comment_config.configure_language {
}

vim.g.kommentary_create_default_mappings = false
