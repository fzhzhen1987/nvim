-- core/project.lua
-- 项目管理
-- 来源：FZH_lua/init.lua line 8-44

-- 标记是否已经执行过项目切换
local project_changed = false

-- 自动切换到项目根目录
local function change_to_project_root()
	-- 如果已经切换过，不再执行
	if project_changed then
		return
	end

	-- 获取当前文件的目录
	local current_file = vim.fn.expand('%:p')
	if current_file == '' or vim.fn.isdirectory(current_file) == 1 then
		return
	end

	local current_dir = vim.fn.fnamemodify(current_file, ':h')

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
				project_changed = true
				return
			end
		end

		local parent = vim.fn.fnamemodify(path, ':h')
		if parent == path then break end
		path = parent
	end
end

-- 在 VimEnter 事件后执行
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.schedule(function()
			change_to_project_root()
		end)
	end,
})

-- 也在 BufEnter 事件执行（作为备份）
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.schedule(function()
			change_to_project_root()
		end)
	end,
	once = true,  -- 只执行一次
})

print("项目管理模块已加载")