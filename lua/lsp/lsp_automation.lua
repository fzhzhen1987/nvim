-- ~/.config/nvim/lua/FZH_lua/lsp_setting/lsp_automation.lua
-- 改进版 lsp_automation.lua
local M = {}

-- 配置选项
local config = {
	-- 是否添加系统头文件路径
	add_system_includes = false,
	-- 是否为头文件生成编译命令
	include_headers = true,
	-- 默认 C 标准
	c_standard = "c11",
	-- 默认 C++ 标准
	cpp_standard = "c++17"
}

-- 重启 LSP 的辅助函数
local function restart_lsp()
	local clients = vim.lsp.get_active_clients()
	local current_buf = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)

	for _, client in ipairs(clients) do
		if client.name == "clangd" then
			-- 停止客户端
			vim.lsp.stop_client(client.id)

			-- 短暂延迟后重新触发 LSP 连接
			vim.defer_fn(function()
				-- 触发 FileType 事件以重新启动 LSP
				vim.cmd('doautocmd FileType')
				-- 恢复光标位置
				pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
			end, 200)

			vim.notify("Restarting clangd...", vim.log.levels.INFO)
			break
		end
	end
end

-- 智能添加系统头文件路径（为嵌入式开发预留扩展）
local function add_system_include_paths(command_parts)
	if not config.add_system_includes then
		return
	end

	-- TODO: 添加嵌入式交叉编译工具链支持
	-- 示例模板：
	-- local cross_compile = os.getenv("CROSS_COMPILE")
	-- local sysroot = os.getenv("SYSROOT")
	-- if sysroot then
	--     table.insert(command_parts, "-I" .. sysroot .. "/usr/include")
	-- end
	
	-- TODO: 添加常见嵌入式工具链路径检测
	-- local embedded_paths = {
	--     "/opt/your-toolchain/include",
	--     "/usr/your-target/include",
	-- }
	
	-- 目前暂时不添加任何系统路径
	-- 大多数项目的头文件目录已经足够
	vim.notify("💡 System includes are enabled but no paths configured. Edit add_system_include_paths() to add custom paths.", vim.log.levels.INFO)
end

-- 修改后的项目根目录查找函数，调整优先级
local function find_project_root()
	local current_file = vim.fn.expand('%:p')
	local current_dir = vim.fn.expand('%:p:h')

	-- 第一梯队：真正的项目根标记
	local primary_markers = {'.git', '.stop_gun'}
	-- 次要标记
	local secondary_markers = {'CMakeLists.txt', 'Makefile'}
	-- 可能会误导的文件
	local fallback_markers = {'.clangd', 'compile_commands.json'}

	vim.notify("Starting search from: " .. current_dir, vim.log.levels.INFO)

	-- 首先在整个路径中查找第一梯队标记
	local path = current_dir
	while path and path ~= '/' do
		vim.notify("Checking directory: " .. path, vim.log.levels.DEBUG)

		-- 先检查第一梯队标记
		for _, marker in ipairs(primary_markers) do
			local marker_path = path .. '/' .. marker
			local stat = vim.loop.fs_stat(marker_path)
			if stat then
				vim.notify("Found PRIMARY project root: " .. path .. " (marker: " .. marker .. ")", vim.log.levels.INFO)
				return path
			end
		end

		-- 移动到父目录
		local parent = vim.fn.fnamemodify(path, ':h')
		if parent == path then
			break -- 已经到达根目录
		end
		path = parent
	end

	-- 如果没找到第一梯队标记，再查找次要标记
	path = current_dir
	while path and path ~= '/' do
		for _, marker in ipairs(secondary_markers) do
			local marker_path = path .. '/' .. marker
			local stat = vim.loop.fs_stat(marker_path)
			if stat then
				vim.notify("Found SECONDARY project root: " .. path .. " (marker: " .. marker .. ")", vim.log.levels.INFO)
				return path
			end
		end

		local parent = vim.fn.fnamemodify(path, ':h')
		if parent == path then
			break
		end
		path = parent
	end

	-- 最后才查找可能误导的标记文件
	path = current_dir
	while path and path ~= '/' do
		for _, marker in ipairs(fallback_markers) do
			local marker_path = path .. '/' .. marker
			local stat = vim.loop.fs_stat(marker_path)
			if stat then
				vim.notify("Found FALLBACK project root: " .. path .. " (marker: " .. marker .. ")", vim.log.levels.WARN)
				return path
			end
		end

		local parent = vim.fn.fnamemodify(path, ':h')
		if parent == path then
			break
		end
		path = parent
	end

	vim.notify("No project root found, using current directory: " .. current_dir, vim.log.levels.WARN)
	return current_dir
end

-- 导出 find_project_root 函数供其他函数使用
M.find_project_root = find_project_root

-- 检测项目中使用的宏定义
local function detect_macro_definitions(root)
	local macros = {}
	local undefined_macros = {}

	vim.notify("🔍 Scanning for macro definitions and usage...", vim.log.levels.INFO)

	-- 常见的条件编译模式
	local patterns = {
		-- #ifdef MACRO
		"#ifdef%s+([%w_]+)",
		-- #ifndef MACRO
		"#ifndef%s+([%w_]+)",
		-- #if defined(MACRO)
		"#if%s+defined%s*%(([%w_]+)%)",
		-- #elif defined(MACRO)
		"#elif%s+defined%s*%(([%w_]+)%)",
	}

	-- 扫描所有源文件和头文件
	local file_patterns = {'**/*.c', '**/*.cc', '**/*.cpp', '**/*.h', '**/*.hpp'}
	local scanned_files = 0

	for _, pattern in ipairs(file_patterns) do
		local files = vim.fn.globpath(root, pattern, false, true)
		for _, file in ipairs(files) do
			if not file:match('/build/') and not file:match('/%.') then
				scanned_files = scanned_files + 1
				-- 安全读取文件内容
				local success, content = pcall(vim.fn.readfile, file)
				if success then
					for _, line in ipairs(content) do
						-- 检查每个模式
						for _, pat in ipairs(patterns) do
							local macro = line:match(pat)
							if macro then
								-- 排除一些标准宏
								if not macro:match("^__") and
									 not macro:match("^_.*_H_?_?$") and  -- 头文件保护
									 macro ~= "NULL" and
									 macro ~= "TRUE" and
									 macro ~= "FALSE" then
									macros[macro] = (macros[macro] or 0) + 1
								end
							end
						end
					end
				end
			end
		end
	end

	vim.notify(string.format("✅ Scanned %d files", scanned_files), vim.log.levels.INFO)

	-- 按使用频率排序
	local sorted_macros = {}
	for macro, count in pairs(macros) do
		table.insert(sorted_macros, {name = macro, count = count})
	end
	table.sort(sorted_macros, function(a, b) return a.count > b.count end)

	return sorted_macros
end

-- 显示宏定义报告
local function show_macro_report(macros)
	if #macros == 0 then
		vim.notify("No conditional macros found", vim.log.levels.INFO)
		return
	end

	print("\n=== Detected Macro Definitions ===")
	print("The following macros are used in #ifdef/#ifndef directives:")
	print("(You may need to define some of these in .clangd)\n")

	-- 显示最常用的前20个
	local max_show = math.min(20, #macros)
	for i = 1, max_show do
		local m = macros[i]
		print(string.format("  %-30s (used %d times)", m.name, m.count))
	end

	if #macros > max_show then
		print(string.format("\n  ... and %d more macros", #macros - max_show))
	end

	-- 特别提示一些常见的项目宏
	print("\n=== Common Project Macros ===")
	local common_prefixes = {"DEF", "CONFIG", "ENABLE", "USE", "HAS", "WITH"}
	local found_common = false

	for _, m in ipairs(macros) do
		for _, prefix in ipairs(common_prefixes) do
			if m.name:match("^" .. prefix) then
				print(string.format("  ⚠️  %s - This looks like a configuration macro", m.name))
				found_common = true
				break
			end
		end
	end

	if not found_common then
		print("  No obvious configuration macros found")
	end

	print("\n💡 To define a macro in .clangd, add:")
	print("  CompileFlags:")
	print("    Add:")
	print("      - -DMACRO_NAME")
	print("      - -DMACRO_NAME=value")
end

-- 扫描所有头文件目录
local function scan_header_dirs(root)
	local header_patterns = {'**/*.h', '**/*.hpp', '**/*.hxx', '**/*.h++'}
	local unique_dirs = {}

	for _, pattern in ipairs(header_patterns) do
		local files = vim.fn.globpath(root, pattern, false, true)
		for _, file in ipairs(files) do
			if not file:match('/build/') and not file:match('/%.') then
				local dir = vim.fn.fnamemodify(file, ':h')
				unique_dirs[dir] = true
			end
		end
	end

	local dirs = {}
	for dir, _ in pairs(unique_dirs) do
		table.insert(dirs, dir)
	end

	vim.notify("Found " .. #dirs .. " header directories", vim.log.levels.INFO)
	return dirs
end

-- 扫描所有源文件
local function scan_source_files(root)
	local source_patterns = {'**/*.c', '**/*.cc', '**/*.cpp', '**/*.cxx', '**/*.c++'}
	local source_files = {}

	for _, pattern in ipairs(source_patterns) do
		local files = vim.fn.globpath(root, pattern, false, true)
		for _, file in ipairs(files) do
			-- 排除 build 目录和隐藏文件
			if not file:match('/build/') and not file:match('/%.') then
				table.insert(source_files, file)
			end
		end
	end

	vim.notify("Found " .. #source_files .. " source files", vim.log.levels.INFO)
	return source_files
end

-- 【修复】生成 compile_commands.json - 移除有问题的 -xc-header 参数
function M.generate_compile_commands()
	local project_root = find_project_root()
	if not project_root or project_root == '' then
		vim.notify("❌ Cannot find project root", vim.log.levels.ERROR)
		return
	end

	vim.notify("🚀 Generating compile_commands.json in: " .. project_root, vim.log.levels.INFO)

	local source_files = scan_source_files(project_root)
	local header_dirs = scan_header_dirs(project_root)

	if #source_files == 0 then
		vim.notify("⚠️  No source files found in project", vim.log.levels.WARN)
		return
	end

	-- 构建编译命令
	local compile_commands = {}

	-- 为源文件生成编译命令
	for _, source in ipairs(source_files) do
		local command_parts = {"clang"}

		-- 检测 C++ 文件
		local is_cpp = source:match("%.c[cp]p$") or source:match("%.cxx$") or source:match("%.c%+%+$") or source:match("%.cc$")

		-- 添加编译标志
		if is_cpp then
			table.insert(command_parts, "-std=" .. config.cpp_standard)
		else
			table.insert(command_parts, "-std=" .. config.c_standard)
		end
		table.insert(command_parts, "-Wall")
		table.insert(command_parts, "-Wextra")
		-- 添加忽略注释中代码的标志
		table.insert(command_parts, "-Wno-documentation")
		table.insert(command_parts, "-fparse-all-comments")

		-- 添加所有头文件目录
		for _, dir in ipairs(header_dirs) do
			table.insert(command_parts, "-I" .. dir)
		end

		-- 智能添加系统头文件路径
		add_system_include_paths(command_parts)

		-- 源文件
		table.insert(command_parts, source)

		-- 构建编译命令条目
		local entry = {
			directory = project_root,
			command = table.concat(command_parts, " "),
			file = source
		}

		table.insert(compile_commands, entry)
	end

	-- 【修复】为头文件也生成编译命令 - 不使用 -xc-header 参数
	if config.include_headers then
		local header_patterns = {'**/*.h', '**/*.hpp', '**/*.hxx', '**/*.h++'}
		for _, pattern in ipairs(header_patterns) do
			local files = vim.fn.globpath(project_root, pattern, false, true)
			for _, header in ipairs(files) do
				if not header:match('/build/') and not header:match('/%.') then
					local command_parts = {"clang"}
					
					-- 检测是否为 C++ 头文件
					local is_cpp_header = header:match("%.hpp$") or header:match("%.hxx$") or header:match("%.h%+%+$")
					
					-- 【关键修复】不再使用 -xc-header 或 -xc++-header 参数
					-- 添加标准编译标志
					if is_cpp_header then
						table.insert(command_parts, "-std=" .. config.cpp_standard)
					else
						table.insert(command_parts, "-std=" .. config.c_standard)
					end
					
					table.insert(command_parts, "-Wall")
					table.insert(command_parts, "-Wextra")
					table.insert(command_parts, "-Wno-documentation")
					table.insert(command_parts, "-fparse-all-comments")

					-- 添加所有头文件目录
					for _, dir in ipairs(header_dirs) do
						table.insert(command_parts, "-I" .. dir)
					end

					-- 智能添加系统头文件路径
					add_system_include_paths(command_parts)

					-- 头文件
					table.insert(command_parts, header)

					-- 构建头文件编译命令条目
					local header_entry = {
						directory = project_root,
						command = table.concat(command_parts, " "),
						file = header
					}

					table.insert(compile_commands, header_entry)
				end
			end
		end
	end

	-- 写入 compile_commands.json
	local json_path = project_root .. '/compile_commands.json'
	local json_content = vim.fn.json_encode(compile_commands)

	local file = io.open(json_path, 'w')
	if file then
		file:write(json_content)
		file:close()
		
		local file_types = config.include_headers and "sources + headers" or "sources only"
		vim.notify("✅ Generated " .. json_path .. " with " .. #compile_commands .. " entries (" .. file_types .. ")", vim.log.levels.INFO)
		vim.notify("🔧 Fixed: Removed problematic -xc-header parameters for better LSP compatibility", vim.log.levels.INFO)
		
		if not config.add_system_includes then
			vim.notify("💡 Tip: System include paths are disabled by default. Use :ClangdToggleSystemIncludes to enable if needed", vim.log.levels.INFO)
		end

		-- 重启 LSP 以加载新的编译数据库
		vim.schedule(function()
			restart_lsp()
		end)
	else
		vim.notify("❌ Failed to write compile_commands.json", vim.log.levels.ERROR)
	end
end

-- 更新 .clangd 文件（改进版：保留已有配置）
function M.update_clangd_config()
	local project_root = find_project_root()
	if not project_root or project_root == '' then
		vim.notify("❌ Cannot find project root", vim.log.levels.ERROR)
		return
	end

	vim.notify("🚀 Updating .clangd configuration in: " .. project_root, vim.log.levels.INFO)

	-- 检查是否已有 .clangd 文件
	local clangd_path = project_root .. '/.clangd'
	local existing_macros = {}

	-- 读取现有的宏定义
	if vim.fn.filereadable(clangd_path) == 1 then
		vim.notify("📖 Reading existing .clangd file...", vim.log.levels.INFO)
		local existing_content = vim.fn.readfile(clangd_path)
		for _, line in ipairs(existing_content) do
			-- 匹配 - -DMACRO_NAME 格式
			local macro = line:match("^%s*%-%s*%-D([%w_]+)")
			if macro then
				existing_macros[macro] = true
				vim.notify("  Found existing macro: " .. macro, vim.log.levels.DEBUG)
			end
		end
	end

	-- 先检测宏定义
	local macros = detect_macro_definitions(project_root)
	show_macro_report(macros)

	-- 询问用户要添加哪些宏
	local selected_macros = {}

	-- 首先添加已存在的宏
	for macro, _ in pairs(existing_macros) do
		table.insert(selected_macros, macro)
	end

	if #macros > 0 then
		print("\n🤔 Which macros do you want to add to .clangd?")
		if #selected_macros > 0 then
			print("Currently defined macros: " .. table.concat(selected_macros, ", "))
		end
		print("Enter additional macro names separated by spaces (e.g., DEFMP1 DEBUG_MODE):")
		print("Or press Enter to keep current macros:")

		local input = vim.fn.input("> ")
		if input and input ~= "" then
			for macro in input:gmatch("%S+") do
				-- 避免重复添加
				if not existing_macros[macro] then
					table.insert(selected_macros, macro)
				end
			end
		end
	end

	local header_dirs = scan_header_dirs(project_root)

	-- 构建 .clangd 内容
	local clangd_content = {
		"# Generated by Neovim LSP Automation",
		"# Project root: " .. project_root,
		"CompileFlags:",
		"  Add:",
		"    - -std=" .. config.c_standard,  -- 使用配置的 C 标准
		"    - -Wall",
		"    - -Wextra",
		"    # Fix for comments containing code-like content",
		"    - -Wno-documentation",
		"    - -fparse-all-comments",
	}

	-- 添加所有宏（包括已存在的）
	if #selected_macros > 0 then
		table.insert(clangd_content, "    # User defined macros")
		-- 排序以保持一致性
		table.sort(selected_macros)
		for _, macro in ipairs(selected_macros) do
			table.insert(clangd_content, "    - -D" .. macro)
		end
	end

	-- 添加所有头文件目录
	table.insert(clangd_content, "    # Include directories")
	for _, dir in ipairs(header_dirs) do
		local relative_dir = dir:gsub("^" .. vim.pesc(project_root) .. "/", "")
		if relative_dir ~= dir then -- 确保是相对路径
			table.insert(clangd_content, "    - -I" .. relative_dir)
		else
			table.insert(clangd_content, "    - -I" .. dir)
		end
	end

	-- TODO: 智能添加系统路径（为嵌入式开发预留）
	if config.add_system_includes then
		table.insert(clangd_content, "    # Custom include paths")
		-- TODO: 添加自定义路径，例如：
		-- table.insert(clangd_content, "    - -I/opt/your-toolchain/include")
		-- table.insert(clangd_content, "    - -I" .. os.getenv("SYSROOT") .. "/usr/include")
		vim.notify("💡 System includes enabled in .clangd config. Edit update_clangd_config() to add custom paths.", vim.log.levels.INFO)
	end

	-- 索引配置
	table.insert(clangd_content, "")
	table.insert(clangd_content, "Index:")
	table.insert(clangd_content, "  Background: Build")
	table.insert(clangd_content, "  StandardLibrary: Yes")
	table.insert(clangd_content, "  # Force rebuild index to fix comment parsing issues")
	table.insert(clangd_content, "  Version: 2")

	-- 诊断配置
	table.insert(clangd_content, "")
	table.insert(clangd_content, "Diagnostics:")
	table.insert(clangd_content, "  UnusedIncludes: Strict")
	table.insert(clangd_content, "  MissingIncludes: Strict")
	table.insert(clangd_content, "  # Suppress documentation warnings")
	table.insert(clangd_content, "  Suppress:")
	table.insert(clangd_content, "    - '-Wdocumentation'")
	table.insert(clangd_content, "    - '-Wdocumentation-unknown-command'")

	-- 注释掉有问题的 ClangTidy 配置
	-- table.insert(clangd_content, "  ClangTidy:")
	-- table.insert(clangd_content, "    Add:")
	-- table.insert(clangd_content, "      - '-clang-diagnostic-documentation'")
	-- table.insert(clangd_content, "      - '-clang-diagnostic-documentation-unknown-command'")

	-- 写入文件
	local success = pcall(vim.fn.writefile, clangd_content, clangd_path)

	if success then
		vim.notify("✅ Updated " .. clangd_path, vim.log.levels.INFO)
		if #selected_macros > 0 then
			vim.notify("📌 Preserved macros: " .. table.concat(selected_macros, ", "), vim.log.levels.INFO)
		end

		-- 清除 clangd 缓存
		local cache_path = project_root .. '/.cache/clangd'
		vim.fn.system('rm -rf ' .. cache_path)
		vim.notify("🧹 Cleared clangd cache", vim.log.levels.INFO)

		-- 重启 LSP
		vim.schedule(function()
			restart_lsp()
		end)
	else
		vim.notify("❌ Failed to write .clangd file", vim.log.levels.ERROR)
	end
end

-- 主函数：生成路径配置
function M.generate_paths()
	-- 优先尝试生成 compile_commands.json
	if vim.fn.executable('clang') == 1 then
		M.generate_compile_commands()
	else
		-- 如果没有 clang，退回到更新 .clangd
		vim.notify("clang not found, falling back to .clangd config", vim.log.levels.WARN)
		M.update_clangd_config()
	end
end

-- 配置函数
function M.configure(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})
	vim.notify("🔧 Configuration updated: " .. vim.inspect(config), vim.log.levels.INFO)
end

-- 设置函数，用于注册命令
function M.setup(opts)
	-- 应用配置
	if opts then
		M.configure(opts)
	end

	-- 原有命令保持不变
	vim.api.nvim_create_user_command('ClangdCCommand', function()
		M.generate_compile_commands()
	end, { desc = "Generate compile_commands.json for clangd" })

	vim.api.nvim_create_user_command('ClangdUpdateConfig', function()
		M.update_clangd_config()
	end, { desc = "Update .clangd configuration file" })

	vim.api.nvim_create_user_command('ClangdPaths', function()
		M.generate_paths()
	end, { desc = "Generate clangd path configuration (auto-select method)" })

	-- 新增：分析宏定义命令
	vim.api.nvim_create_user_command('ClangdAnalyzeMacros', function()
		local project_root = find_project_root()
		if project_root then
			local macros = detect_macro_definitions(project_root)
			show_macro_report(macros)
		else
			vim.notify("❌ Cannot find project root", vim.log.levels.ERROR)
		end
	end, { desc = "Analyze macro definitions in project" })

	-- 调试命令：显示项目根目录查找过程
	vim.api.nvim_create_user_command('ClangdDebugRoot', function()
		local current_file = vim.fn.expand('%:p')
		local current_dir = vim.fn.expand('%:p:h')

		print("=== Clangd Root Directory Debug ===")
		print("Current file: " .. current_file)
		print("Starting directory: " .. current_dir)
		print("")

		local primary_markers = {'.git', '.stop_gun'}
		local secondary_markers = {'CMakeLists.txt', 'Makefile'}
		local fallback_markers = {'.clangd', 'compile_commands.json'}

		local function check_markers_in_path(path, markers, category)
			print("Checking " .. category .. " markers in: " .. path)
			for _, marker in ipairs(markers) do
				local marker_path = path .. '/' .. marker
				local stat = vim.loop.fs_stat(marker_path)
				if stat then
					print("  ✅ FOUND: " .. marker)
					return marker
				else
					print("  ❌ Missing: " .. marker)
				end
			end
			return nil
		end

		local path = current_dir
		while path and path ~= '/' do
			print("\n--- Checking directory: " .. path .. " ---")

			-- 检查第一梯队标记
			local found_marker = check_markers_in_path(path, primary_markers, "PRIMARY")
			if found_marker then
				print("\n🎯 PRIMARY project root found: " .. path)
				print("   Using marker: " .. found_marker)
				return
			end

			local parent = vim.fn.fnamemodify(path, ':h')
			if parent == path then
				break
			end
			path = parent
		end

		print("\n⚠️  No PRIMARY markers found, checking SECONDARY markers...")

		path = current_dir
		while path and path ~= '/' do
			local found_marker = check_markers_in_path(path, secondary_markers, "SECONDARY")
			if found_marker then
				print("\n🔶 SECONDARY project root found: " .. path)
				print("   Using marker: " .. found_marker)
				return
			end

			local parent = vim.fn.fnamemodify(path, ':h')
			if parent == path then
				break
			end
			path = parent
		end

		print("\n⚠️  No SECONDARY markers found, checking FALLBACK markers...")

		path = current_dir
		while path and path ~= '/' do
			local found_marker = check_markers_in_path(path, fallback_markers, "FALLBACK")
			if found_marker then
				print("\n🟡 FALLBACK project root found: " .. path)
				print("   Using marker: " .. found_marker)
				return
			end

			local parent = vim.fn.fnamemodify(path, ':h')
			if parent == path then
				break
			end
			path = parent
		end

		print("\n❌ No project root found!")
	end, { desc = "Debug project root detection" })

	-- 新增配置切换命令
	vim.api.nvim_create_user_command('ClangdToggleSystemIncludes', function()
		config.add_system_includes = not config.add_system_includes
		vim.notify("💡 System includes: " .. (config.add_system_includes and "enabled" or "disabled"), vim.log.levels.INFO)
	end, { desc = "Toggle system include paths" })

	vim.api.nvim_create_user_command('ClangdToggleHeaders', function()
		config.include_headers = not config.include_headers
		vim.notify("💡 Header file compilation: " .. (config.include_headers and "enabled" or "disabled"), vim.log.levels.INFO)
	end, { desc = "Toggle header file compilation entries" })

	vim.api.nvim_create_user_command('ClangdShowConfig', function()
		print("=== Current Clangd Automation Config ===")
		print("Add system includes: " .. tostring(config.add_system_includes))
		print("Include headers: " .. tostring(config.include_headers))
		print("C standard: " .. config.c_standard)
		print("C++ standard: " .. config.cpp_standard)
	end, { desc = "Show current configuration" })
end

-- 自动调用 setup
M.setup()

return M