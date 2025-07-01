require('FZH_lua.general_setting')
require('FZH_lua.plugins_new')
require('FZH_lua.configs')
require('FZH_lua.utils')

require('FZH_lua.lsp_setting').setup()

-- 自动切换到项目根目录
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- 只在打开文件时执行
		if vim.fn.argc() == 0 then
			return
		end

		vim.schedule(function()
			-- 获取当前目录
			local current_dir = vim.fn.expand('%:p:h')
			if current_dir == '' then
				current_dir = vim.fn.getcwd()
			end

			-- 项目标记
			local markers = {'.git', '.stop_gun', 'Makefile', 'CMakeLists.txt'}

			-- 向上查找
			local path = current_dir
			while path and path ~= '/' do
				for _, marker in ipairs(markers) do
					local marker_path = path .. '/' .. marker
					if vim.fn.isdirectory(marker_path) == 1 or vim.fn.filereadable(marker_path) == 1 then
						vim.cmd('cd ' .. path)
						vim.notify('📁 ' .. path, vim.log.levels.INFO)
						return
					end
				end

				local parent = vim.fn.fnamemodify(path, ':h')
				if parent == path then break end
				path = parent
			end
		end)
	end,
})

