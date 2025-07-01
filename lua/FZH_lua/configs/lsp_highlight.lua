-- ~/.config/nvim/lua/FZH_lua/configs/lsp_highlight.lua
-- LSP 语义高亮相关的自动命令和配置

local M = {}

-- 创建自动命令组
local augroup = vim.api.nvim_create_augroup("LspCxxHighlight", { clear = true })

-- 当进入 C 文件时检查高亮状态
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	group = augroup,
	pattern = {"*.c", "*.h"},  -- 主要关注 C 文件
	callback = function(ev)
		-- 延迟一下以确保 LSP 已经启动
		vim.defer_fn(function()
			local clients = vim.lsp.get_active_clients({ bufnr = ev.buf })
			for _, client in ipairs(clients) do
				if client.name == "clangd" then
					-- 检查语义高亮是否启用
					if client.server_capabilities.semanticTokensProvider then
						vim.notify("vim-lsp-cxx-highlight: C language semantic highlighting is active", vim.log.levels.DEBUG)
					else
						vim.notify("vim-lsp-cxx-highlight: Semantic highlighting not available", vim.log.levels.WARN)
					end
					break
				end
			end
		end, 500)
	end,
})

-- 调试命令：检查当前 buffer 的高亮组
vim.api.nvim_create_user_command("LspCxxHlInfo", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
	
	print("=== LSP C++ Highlight Info ===")
	print("Buffer: " .. bufnr)
	print("Filetype: " .. vim.bo[bufnr].filetype)
	
	for _, client in ipairs(clients) do
		if client.name == "clangd" then
			print("Clangd client found: " .. client.id)
			print("Semantic tokens provider: " .. tostring(client.server_capabilities.semanticTokensProvider ~= nil))
		end
	end
	
	-- 获取光标下的语法组
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local hl_group = vim.fn.synIDattr(vim.fn.synID(row, col + 1, 1), "name")
	print("Syntax group at cursor: " .. (hl_group ~= "" and hl_group or "none"))
end, { desc = "Show LSP C++ highlight information" })

-- 调试命令：列出所有 LspCxxHl 高亮组
vim.api.nvim_create_user_command("LspCxxHlGroups", function()
	vim.cmd("filter /LspCxxHl/ highlight")
end, { desc = "List all LspCxxHl highlight groups" })

return M
