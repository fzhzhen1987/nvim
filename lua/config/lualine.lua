local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	vim.notify("lualine not found!")
	return
end

-- ================== 获取当前函数名的逻辑 ==================
local function get_current_function()
	-- 首先检查是否是 C 语言文件
	local ft = vim.bo.filetype
	if ft ~= 'c' and ft ~= 'cpp' and ft ~= 'h' then
		return ''
	end

	-- 方法1: 优先使用 LSP
	local lsp_available = false
	for _, client in pairs(vim.lsp.get_active_clients()) do
		if client.server_capabilities.documentSymbolProvider then
			lsp_available = true
			break
		end
	end

	if lsp_available then
		-- 使用 LSP 获取当前位置的符号信息
		local params = vim.lsp.util.make_position_params()
		local results = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbol', params, 1000)

		if results then
			local cursor_line = vim.fn.line('.') - 1  -- LSP 使用 0-based
			local cursor_col = vim.fn.col('.') - 1

			for _, result in pairs(results) do
				if result.result then
					-- 递归查找包含当前光标的函数
					local function find_function(symbols, parent_name)
						for _, symbol in ipairs(symbols) do
							-- SymbolKind.Function = 12, SymbolKind.Method = 6
							if symbol.kind == 12 or symbol.kind == 6 then
								local range = symbol.range or symbol.location.range
								local start_line = range.start.line
								local end_line = range['end'].line

								-- 检查光标是否在这个函数范围内
								if cursor_line >= start_line and cursor_line <= end_line then
									local name = symbol.name
									if parent_name then
										name = parent_name .. '::' .. name
									end
									-- 继续检查是否有嵌套的函数
									if symbol.children then
										local nested = find_function(symbol.children, name)
										if nested ~= '' then
											return nested
										end
									end
									return name
								end
							end

							-- 递归检查子符号
							if symbol.children then
								local found = find_function(symbol.children, parent_name)
								if found ~= '' then
									return found
								end
							end
						end
						return ''
					end

					local func_name = find_function(result.result, nil)
					if func_name ~= '' then
						return func_name
					end
				end
			end
		end
	end

	-- 方法2: 使用 Treesitter 作为备用方案
	local ts_available, ts_parsers = pcall(require, "nvim-treesitter.parsers")
	if ts_available and ts_parsers.has_parser() then
		local ts_utils = require("nvim-treesitter.ts_utils")
		local node = ts_utils.get_node_at_cursor()

		while node do
			local node_type = node:type()
			-- C 语言函数定义节点类型
			if node_type == "function_definition" or
			   node_type == "function_declarator" then
				-- 查找函数名
				local name_node = nil
				for child in node:iter_children() do
					if child:type() == "identifier" or
					   (child:type() == "declarator" and child:child(0) and child:child(0):type() == "identifier") then
						name_node = child:type() == "identifier" and child or child:child(0)
						break
					end
				end

				if name_node then
					local func_name = vim.treesitter.get_node_text(name_node, 0)
					return func_name
				end
			end
			node = node:parent()
		end
	end

	-- 方法3: 使用简单的正则表达式作为最后的备用方案
	-- 向上搜索函数定义
	local current_line = vim.fn.line('.')
	local lines_to_check = math.min(current_line, 50)  -- 最多向上检查50行

	for i = current_line, current_line - lines_to_check, -1 do
		local line = vim.fn.getline(i)
		-- 匹配 C 函数定义的模式
		-- 例如: int main(void) {
		-- 例如: static void my_function(int arg) {
		local func_match = line:match("^%s*[%w_*]+%s+[%w_*]+%s*%(") or
		                   line:match("^[%w_*]+%s+[%w_*]+%s*%(")

		if func_match then
			-- 提取函数名
			local func_name = line:match("([%w_]+)%s*%(")
			if func_name and func_name ~= "if" and func_name ~= "while" and
			   func_name ~= "for" and func_name ~= "switch" then
				return func_name
			end
		end
	end

	return ''
end

-- 缓存机制以提高性能
local function_cache = {
	func_name = '',
	line = -1,
	file = '',
	tick = -1
}

local function get_cached_function()
	local current_file = vim.fn.expand('%:p')
	local current_line = vim.fn.line('.')
	local current_tick = vim.b.changedtick

	-- 检查缓存是否有效
	if function_cache.file == current_file and
	   math.abs(function_cache.line - current_line) < 3 and  -- 3行内的移动使用缓存
	   function_cache.tick == current_tick then
		return function_cache.func_name
	end

	-- 更新缓存
	local func_name = get_current_function()
	function_cache.func_name = func_name
	function_cache.line = current_line
	function_cache.file = current_file
	function_cache.tick = current_tick

	return func_name
end

-- 自定义组件
local function current_function_component()
	local func_name = get_cached_function()
	if func_name == '' then
		return ''
	end

	-- 截断过长的函数名
	local max_len = 30
	if #func_name > max_len then
		func_name = func_name:sub(1, max_len - 3) .. '...'
	end

	-- 返回带图标的函数名
	return '󰊕 ' .. func_name
end

-- ================== 自定义主题配置 ==================
local custom_theme = {
	normal = {
		a = { fg = '#ffffff', bg = '#000000', gui = 'bold' },
		b = { fg = '#ffffff', bg = '#000000' },
		c = { fg = '#ffffff', bg = '#000000' },
	},
	insert = {
		a = { fg = '#00ff00', bg = '#000000', gui = 'bold' },
		b = { fg = '#ffffff', bg = '#000000' },
		c = { fg = '#ffffff', bg = '#000000' },
	},
	visual = {
		a = { fg = '#ffff00', bg = '#000000', gui = 'bold' },
		b = { fg = '#ffffff', bg = '#000000' },
		c = { fg = '#ffffff', bg = '#000000' },
	},
	replace = {
		a = { fg = '#ff0000', bg = '#000000', gui = 'bold' },
		b = { fg = '#ffffff', bg = '#000000' },
		c = { fg = '#ffffff', bg = '#000000' },
	},
	command = {
		a = { fg = '#00ffff', bg = '#000000', gui = 'bold' },
		b = { fg = '#ffffff', bg = '#000000' },
		c = { fg = '#ffffff', bg = '#000000' },
	},
	inactive = {
		a = { fg = '#666666', bg = '#000000' },
		b = { fg = '#666666', bg = '#000000' },
		c = { fg = '#666666', bg = '#000000' },
	}
}

-- ================== Lualine 配置 ==================
lualine.setup {
	options = {
		icons_enabled = true,
		theme = custom_theme,  -- 使用自定义主题
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {
			statusline = {
				'leaderf',           -- LeaderF 主窗口
				'LeaderF',           -- LeaderF 可能的大写形式
				'leaderf-popup',     -- LeaderF 弹出窗口
				'leaderf-preview',   -- LeaderF 预览窗口
			},
			winbar = {
				'leaderf',
				'LeaderF',
				'leaderf-popup',
				'leaderf-preview',
			},
		},
		ignore_focus = {
			'leaderf',
			'LeaderF',
		},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {
			{
				'filename',
				file_status = true,      -- 显示文件状态（只读、修改等）
				newfile_status = false,  -- 显示新文件状态
				path = 1,                -- 0 = 只有文件名, 1 = 相对路径, 2 = 绝对路径
				shorting_target = 40,    -- 缩短路径的目标宽度
				symbols = {
					modified = '[+]',      -- 文件修改标记
					readonly = '[-]',      -- 只读文件标记
					unnamed = '[No Name]', -- 无名文件
					newfile = '[New]',     -- 新文件标记
				}
			},
			{
				current_function_component,
				icon = '',
				color = { fg = '#00ff00', bg = '#000000', gui = 'bold' },  -- 亮绿色显示函数名，黑色背景
				cond = function()
					-- 只在 C/C++ 文件中显示
					local ft = vim.bo.filetype
					return ft == 'c' or ft == 'cpp' or ft == 'h'
				end,
			}
		},
		lualine_x = {
			'encoding',
			'fileformat',
			{
				'filetype',
				colored = true,
				icon_only = false,
			}
		},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

-- ================== 自动命令优化性能 ==================
-- 创建自动命令组
local augroup = vim.api.nvim_create_augroup("LualineFunctionUpdate", { clear = true })

-- 只在必要时清除缓存
vim.api.nvim_create_autocmd({"BufEnter", "BufWrite", "TextChanged"}, {
	group = augroup,
	pattern = {"*.c", "*.h", "*.cpp"},
	callback = function()
		-- 清除缓存，下次获取时会重新计算
		function_cache.tick = -1
	end,
})

-- 提供手动刷新命令
vim.api.nvim_create_user_command("LualineRefreshFunction", function()
	function_cache.tick = -1
	vim.cmd("redrawstatus")
end, { desc = "Refresh lualine function display" })
