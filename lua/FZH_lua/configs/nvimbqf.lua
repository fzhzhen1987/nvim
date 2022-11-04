local status_ok, nvim_bqf = pcall(require, "bqf")
if not status_ok then
	vim.notify("nvim_bqf not found!")
	return
end

local setup = {
	auto_enable = enable,
	magic_window = false,
	auto_resize_height = true, -- highly recommended enable
	preview = {
		win_height = 20,
		win_vheight = 20,
		delay_syntax = 80,
		border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
		show_title = false,
		should_preview_cb = function(bufnr, qwinid)
			local ret = true
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local fsize = vim.fn.getfsize(bufname)
			if fsize > 100 * 1024 then
				-- skip file size greater than 100k
				ret = false
			elseif bufname:match('^fugitive://') then
				-- skip fugitive buffer
				ret = false
			end
			return ret
		end
	},
    -- make `drop` and `tab drop` to become preferred
	func_map = {
		prevfile = '',
		nextfile = '',
		pscrollup = '<C-k>',
		pscrolldown = '<C-j>',
		fzffilter = 'f',
		drop = 'o',
		openc = 'O',
		vsplit = '<C-e>',
		tabdrop = '<C-t>',
		tabc = '',
		ptogglemode = 'z,',
	},
	filter = {
		fzf = {
			action_for = {['ctrl-e'] = 'vsplit', ['ctrl-t'] = 'tab drop', ['ctrl-c'] = '', ['ctrl-q'] = 'closeall'},
			extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
		}
	}
}

nvim_bqf.setup(setup)
