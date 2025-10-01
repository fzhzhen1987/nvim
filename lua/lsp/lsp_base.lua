-- lsp/lsp_base.lua
-- LSP 基础配置：诊断图标、处理器、全局函数等

local M = {}

M.setup = function()
	-- 设置诊断图标
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	-- 配置诊断显示（兼容 Neovim 0.9.4）
	vim.diagnostic.config({
		signs = true,
		underline = true,
		update_in_insert = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
		virtual_text = {
			prefix = "",
		},
	})

	-- 配置悬停和签名帮助
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

	-- 自定义 LSP 处理器，强制使用 telescope 或 quickfix 预览
	local function make_handler_with_preview(lsp_method)
		return function(_, result, ctx, config)
			if not result or vim.tbl_isempty(result) then
				vim.notify("No results found", vim.log.levels.INFO)
				return
			end

			local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
			if has_telescope then
				if lsp_method == "textDocument/definition" then
					telescope_builtin.lsp_definitions({ jump_type = "never" })
				elseif lsp_method == "textDocument/references" then
					telescope_builtin.lsp_references({ jump_type = "never", include_declaration = false })
				elseif lsp_method == "textDocument/implementation" then
					telescope_builtin.lsp_implementations({ jump_type = "never" })
				elseif lsp_method == "textDocument/typeDefinition" then
					telescope_builtin.lsp_type_definitions({ jump_type = "never" })
				elseif lsp_method == "textDocument/declaration" then
					-- declaration 通常返回单个结果，但我们仍然可以用 telescope 预览
					telescope_builtin.lsp_definitions({
						jump_type = "never",
						prompt_title = "Declarations"
					})
				end
			else
				vim.lsp.handlers[lsp_method](_, result, ctx, config)
				vim.cmd("copen")
			end
		end
	end

	vim.lsp.handlers["textDocument/definition"] = make_handler_with_preview("textDocument/definition")
	vim.lsp.handlers["textDocument/references"] = make_handler_with_preview("textDocument/references")
	vim.lsp.handlers["textDocument/implementation"] = make_handler_with_preview("textDocument/implementation")
	vim.lsp.handlers["textDocument/typeDefinition"] = make_handler_with_preview("textDocument/typeDefinition")
	vim.lsp.handlers["textDocument/declaration"] = make_handler_with_preview("textDocument/declaration")

	-- 设置全局 on_attach 函数
	_G.Itkey_on_attach = function(client, bufnr)
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

		buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

		if client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
			vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
			vim.api.nvim_create_autocmd("CursorHold", {
				callback = vim.lsp.buf.document_highlight,
				buffer = bufnr,
				group = "lsp_document_highlight",
				desc = "Document Highlight",
			})
			vim.api.nvim_create_autocmd("CursorMoved", {
				callback = vim.lsp.buf.clear_references,
				buffer = bufnr,
				group = "lsp_document_highlight",
				desc = "Clear All the References",
			})
		end
	end

	-- 初始化 capabilities
	local capabilities
	local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

	if has_cmp_nvim_lsp then
		-- ✅ 使用 cmp-nvim-lsp 的默认配置（推荐方式）
		capabilities = cmp_nvim_lsp.default_capabilities()
	else
		-- 降级到基础 LSP capabilities
		capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.preselectSupport = true
		capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
		capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
		capabilities.textDocument.completion.completionItem.deprecatedSupport = true
		capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
		capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		}
	end

	_G.Itkey_capabilities = capabilities

	vim.api.nvim_create_user_command("LspRestart", function(opts)
		local clients = vim.lsp.get_active_clients()
		local target_clients = {}

		for _, client in ipairs(clients) do
			if opts.args == "" or client.name == opts.args then
				table.insert(target_clients, client)
			end
		end

		for _, client in ipairs(target_clients) do
			vim.lsp.stop_client(client.id)
		end

		vim.defer_fn(function()
			vim.cmd("doautocmd FileType")
		end, 100)

		local msg = opts.args == "" and "Restarting all LSP clients..." or "Restarting " .. opts.args .. "..."
		vim.notify(msg, vim.log.levels.INFO)
	end, {
		nargs = "?",
		complete = function()
			local clients = vim.lsp.get_active_clients()
			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			return names
		end,
		desc = "Restart LSP clients",
	})

	vim.api.nvim_create_user_command("LspInfo", function()
		local clients = vim.lsp.get_active_clients()
		if #clients == 0 then
			print("No active LSP clients")
			return
		end

		print("Active LSP clients:")
		for _, client in ipairs(clients) do
			local filetypes = table.concat(client.config.filetypes or {}, ", ")
			print(string.format("  • %s (id: %d) - filetypes: %s", client.name, client.id, filetypes))
		end
	end, { desc = "Show active LSP clients" })

	vim.api.nvim_create_user_command("LspLog", function()
		local log_path = vim.lsp.get_log_path()
		vim.cmd("edit " .. log_path)
	end, { desc = "Open LSP log file" })

	vim.api.nvim_create_user_command("LspCapabilities", function()
		local clients = vim.lsp.get_active_clients()
		if #clients == 0 then
			print("No active LSP clients")
			return
		end

		for _, client in ipairs(clients) do
			print("=== " .. client.name .. " capabilities ===")
			print(vim.inspect(client.server_capabilities))
		end
	end, { desc = "Show LSP server capabilities" })

	-- 使用全局变量跟踪诊断状态（兼容 Neovim 0.9.4）
	_G.diagnostics_disabled = false

	vim.api.nvim_create_user_command("DiagnosticsToggle", function()
		if _G.diagnostics_disabled then
			vim.diagnostic.enable()
			_G.diagnostics_disabled = false
			vim.notify("Diagnostics enabled", vim.log.levels.INFO)
		else
			vim.diagnostic.disable()
			_G.diagnostics_disabled = true
			vim.notify("Diagnostics disabled", vim.log.levels.INFO)
		end
	end, { desc = "Toggle diagnostics" })

end

return M
