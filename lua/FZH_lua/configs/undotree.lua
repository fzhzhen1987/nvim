local status_ok, undotree = pcall(require, "undotree")
if not status_ok then
	vim.notify("undotree not found!")
	return
end

undotree.setup {
	float_diff = true,  -- using float window previews diff, set this `true` will disable layout option
	layout = "left_bottom", -- "left_bottom", "left_left_bottom"
	ignore_filetype = {
		'Undotree',
		'UndotreeDiff',
		'qf',
		'TelescopePrompt',
		'spectre_panel',
		'tsplayground'
	},
	window = {
		winblend = 30,
	},
	keymaps = {
		['<C-n>'] = "move_next",
		['<C-p>'] = "move_prev",
		['J'] = "move_change_next",
		['K'] = "move_change_prev",
		['<cr>'] = "action_enter",
		['e'] = "enter_diffbuf",
		['q'] = "quit",
	},
}
