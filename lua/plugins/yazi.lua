-- ~/.config/nvim/lua/plugins/yazi.lua
-- Yazi 文件管理器集成（自定义实现，定位到当前文件）

return {
	-- 使用一个虚拟插件名称，让 lazy.nvim 可以加载这个配置
	dir = vim.fn.stdpath("config"),
	name = "yazi-custom",
	lazy = true,
	keys = {
		{
			"<leader>ra",
			function()
				-- 获取当前文件的完整路径
				local current_file = vim.fn.expand("%:p")
				local path_to_open

				-- 如果当前是一个真实文件，使用文件路径；否则使用当前目录
				if current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
					path_to_open = current_file
				else
					path_to_open = vim.fn.expand("%:p:h")
				end

				-- 创建临时文件用于接收 yazi 选择的文件
				local output_file = "/tmp/yazi_chosen"
				os.remove(output_file)

				-- 构建 yazi 命令，使用 --chooser-file 参数，并设置环境变量以支持真彩色
				local cmd = string.format('TERM=xterm-256color COLORTERM=truecolor yazi "%s" --chooser-file "%s"', path_to_open, output_file)

				-- 在浮动窗口中打开终端（使用原插件的边框绘制方式）
				local width = math.floor(vim.o.columns * 0.9)
				local height = math.floor(vim.o.lines * 0.9)
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)

				-- 创建边框
				local border_opts = {
					style = 'minimal',
					relative = 'editor',
					row = row - 1,
					col = col - 1,
					width = width + 2,
					height = height + 2,
				}

				-- 边框字符
				local topleft, top, topright, right, botright, bot, botleft, left = '╭', '─', '╮', '│', '╯', '─', '╰', '│'

				-- 绘制边框线
				local border_lines = { topleft .. string.rep(top, width) .. topright }
				local middle_line = left .. string.rep(' ', width) .. right
				for _ = 1, height do
					table.insert(border_lines, middle_line)
				end
				table.insert(border_lines, botleft .. string.rep(bot, width) .. botright)

				-- 创建边框缓冲区和窗口
				local border_buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(border_buf, 0, -1, true, border_lines)
				local border_win = vim.api.nvim_open_win(border_buf, true, border_opts)
				-- 设置边框颜色 - 使用更明显的颜色
				vim.api.nvim_set_hl(0, "YaziBorder", { fg = "#7aa2f7", bg = "NONE", default = true })
				vim.api.nvim_win_set_option(border_win, 'winhl', 'Normal:YaziBorder')

				-- 创建主窗口
				local buf = vim.api.nvim_create_buf(false, true)
				local win = vim.api.nvim_open_win(buf, true, {
					style = 'minimal',
					relative = 'editor',
					row = row,
					col = col,
					width = width,
					height = height,
				})

				-- 设置缓冲区选项以获得更好的颜色显示
				vim.bo[buf].filetype = 'yazi'
				vim.api.nvim_set_hl(0, "YaziFloat", { link = "Normal", default = true })
				vim.api.nvim_win_set_option(win, 'winhl', 'NormalFloat:YaziFloat')
				vim.api.nvim_win_set_option(win, 'winblend', 0)

				-- 在终端中运行 yazi
				vim.fn.termopen(cmd, {
					on_exit = function(_, exit_code)
						-- 关闭主窗口和边框窗口
						if vim.api.nvim_win_is_valid(win) then
							vim.api.nvim_win_close(win, true)
						end
						if vim.api.nvim_win_is_valid(border_win) then
							vim.api.nvim_win_close(border_win, true)
						end
						-- 删除边框缓冲区
						if vim.api.nvim_buf_is_valid(border_buf) then
							vim.api.nvim_buf_delete(border_buf, { force = true })
						end

						vim.cmd("silent! :checktime")

						-- 读取 yazi 选择的文件
						if exit_code == 0 and vim.fn.filereadable(output_file) == 1 then
							local chosen = vim.fn.readfile(output_file)[1]
							if chosen and chosen ~= "" then
							  vim.cmd("edit " .. vim.fn.fnameescape(chosen))
							end
						end

						os.remove(output_file)
					end,
				})

				vim.cmd("startinsert")
			end,
			desc = "打开 yazi（定位到当前文件）",
		},
	},
}

