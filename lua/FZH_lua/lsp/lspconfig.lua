
--设置诊断图标相关
local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = {
			active = signs,
		},
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
			prefix = ""
		}
	}
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

--在语言服务器附加到当前缓冲区之后
--使用 on_attach 函数仅映射以下键
	Itkey_on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

--Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

--Mappings.
	local opts = { noremap=true, silent=true }

-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'J', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

--	buf_set_keymap('n', '<space>jd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--	buf_set_keymap('n', '<space>jD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--	buf_set_keymap('n', '<space>jr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--	buf_set_keymap('n', '<space>jt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--	buf_set_keymap('n', '<space>j[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
--	buf_set_keymap('n', '<space>j]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
--	buf_set_keymap('n', '<space>jo', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
--	buf_set_keymap('n', '<space>jn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--	buf_set_keymap('n', '<space>jp', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		'documentation',
		'detail',
		'additionalTextEdits',
	},
}
Itkey_capabilities = capabilities

