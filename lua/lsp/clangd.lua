-- lsp/clangd.lua
-- clangd (C/C++) LSP 配置

local M = {}

M.setup = function()
	-- 检查 lspconfig 是否可用
	local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
	if not has_lspconfig then
		vim.notify("nvim-lspconfig not installed! Please install it first.", vim.log.levels.ERROR)
		vim.notify("Run :Lazy sync", vim.log.levels.INFO)
		return
	end

	-- 确保加载 lsp_automation 模块
	local automation_ok, automation = pcall(require, 'lsp.lsp_automation')
	if not automation_ok then
		vim.notify("Failed to load lsp_automation.lua", vim.log.levels.WARN)
	end

	-- 定义增强的 on_attach 函数
	local on_attach = function(client, bufnr)
		-- 1. 调用通用 on_attach
		if Itkey_on_attach then
			Itkey_on_attach(client, bufnr)
		end

		-- 2. 启用语义高亮（重要！）
		if client.server_capabilities.semanticTokensProvider then
			-- 这对 vim-lsp-cxx-highlight 很重要
			vim.lsp.semantic_tokens.start(bufnr, client.id)
			vim.notify("Semantic highlighting enabled for buffer " .. bufnr, vim.log.levels.DEBUG)
		end

		-- 3. 检查是否需要初始化配置（不再自动执行）
		if automation_ok then
			-- 获取项目根目录
			local project_root = automation.find_project_root()
			if project_root then
				-- 检查是否已有配置文件
				local has_clangd = vim.fn.filereadable(project_root .. '/.clangd') == 1
				local has_compile_commands = vim.fn.filereadable(project_root .. '/compile_commands.json') == 1

				-- 只有在没有任何配置文件时才提示
				if not has_clangd and not has_compile_commands then
					vim.notify("No clangd configuration found. Use :ClangdPaths to generate one.", vim.log.levels.WARN)
				end
			end
		end

		-- 4. 添加 clangd 特定快捷键
		local opts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
		vim.keymap.set("n", "<leader>ci", "<cmd>ClangdSymbolInfo<CR>", opts)
	end

	-- clangd 配置
	lspconfig.clangd.setup {
		on_attach = on_attach,
		capabilities = Itkey_capabilities,
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
			-- 添加以下选项以增强语义高亮支持
			"--all-scopes-completion",
			"--header-insertion-decorators",
			"--pch-storage=memory",
			"--log=error",  -- 正常使用设为 error，调试时改为 verbose
		},
		filetypes = { "c", "cpp", "objc", "objcpp", "cc", "cxx", "h", "hpp" },
		root_dir = function(fname)
			return lspconfig.util.root_pattern(
				'.clangd',
				'.clang-tidy',
				'.clang-format',
				'compile_commands.json',
				'compile_flags.txt',
				'configure.ac',
				'.git'
			)(fname) or vim.fn.getcwd()
		end,
		single_file_support = true,
		-- 初始化选项
		init_options = {
			clangdFileStatus = true,
			usePlaceholders = true,
			completeUnimported = true,
			semanticHighlighting = true,  -- 确保启用语义高亮
		},
	}
end

return M
