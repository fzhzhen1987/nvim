-- lsp/init.lua
-- LSP 配置主入口文件

local M = {}

M.setup = function()
	-- 1. 首先设置基础 LSP 配置（诊断图标、处理器等）
	local base_ok, lsp_base = pcall(require, 'lsp.lsp_base')
	if base_ok then
		lsp_base.setup()
	end

	-- 2. 加载 lsp_automation（确保命令被注册）
	local automation_ok, automation = pcall(require, 'lsp.lsp_automation')
	if automation_ok and automation.setup then
		automation.setup()
	end

	-- 3. 设置 clangd
	local clangd_ok, clangd = pcall(require, 'lsp.clangd')
	if clangd_ok and clangd.setup then
		clangd.setup()
	else
		-- 如果没有 clangd.lua 文件，使用默认配置
		local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
		if lspconfig_ok and lspconfig.clangd then
			lspconfig.clangd.setup({
				on_attach = Itkey_on_attach,
				capabilities = Itkey_capabilities,
			})
		end
	end

	-- 4. 设置其他语言服务器
	local servers = {
		-- 'pyright',  -- Python
		-- 'tsserver', -- TypeScript
		-- 添加其他需要的服务器
	}

	for _, server in ipairs(servers) do
		local config_file = 'lsp.' .. server
		local ok, server_config = pcall(require, config_file)
		if ok and server_config.setup then
			server_config.setup()
		else
			-- 如果没有特定配置，使用默认配置
			local lspconfig = require('lspconfig')
			if lspconfig[server] then
				lspconfig[server].setup({
					on_attach = Itkey_on_attach,
					capabilities = Itkey_capabilities,
				})
			end
		end
	end

	-- 5. 设置自动补全
	local completion_ok, completion = pcall(require, 'lsp.completion')
	if completion_ok then
		completion.setup()
	end
end

return M
