-- :WhichKey " 显示所有的绑定
-- :WhichKey <leader> " 显示所有<leader>绑定
-- :WhichKey <leader> v " 显示所有v模式下的<leader>绑定
-- :WhichKey '' v " 显示所有v模式下的绑定
-- :checkhealth which_key

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	vim.notify("which-key not found!")
	return
end

-- 完全使用新版本语法的配置
local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = false, -- default bindings on <c-w>
			nav = false, -- misc bindings to work with windows
			z = false, -- bindings for folds, spelling and others prefixed with z
			g = false, -- bindings for prefixed with g
		},
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	-- 新版本语法：使用 keys 替代 popup_mappings
	keys = {
		scroll_down = "<C-j>", -- binding to scroll down inside the popup
		scroll_up = "<C-k>", -- binding to scroll up inside the popup
	},
	layout = {
		height = { min = 4, max = 25 }, -- 行高度范围
		width = { min = 40, max = 120 }, -- 列宽度范围，增加到几乎全屏宽度
		spacing = 5, -- 列之间的间距
		align = "left", -- 对齐方式
	},
	-- 新版本语法：使用 filter 替代 ignore_missing
	filter = function(mapping)
		-- 返回 true 表示显示这个映射
		return true
	end,
	show_help = true,
	show_keys = true,
	-- 新版本可能不需要 triggers，如果出错可以注释掉
	-- triggers = { "<auto>" }, -- automatically setup triggers
}

-- 新版本映射格式：所有映射合并到一个数组中
local all_mappings = {
	-- ================== LSP 核心功能 ==================
	-- === 导航功能 ===
	{ "gd", "<cmd>lua smart_telescope.smart_lsp_definitions()<cr>", desc = "📍 LSP: 跳转到定义", nowait = true, remap = false },
	{ "gD", "<cmd>lua smart_telescope.smart_lsp_declarations()<cr>", desc = "📌 LSP: 跳转到声明", nowait = true, remap = false },
	{ "gi", "<cmd>lua smart_telescope.smart_lsp_implementations()<cr>", desc = "⚡ LSP: 查找实现", nowait = true, remap = false },
	{ "gt", "<cmd>lua smart_telescope.smart_lsp_type_definitions()<cr>", desc = "🏷️ LSP: 类型定义", nowait = true, remap = false },

	-- === 调用关系 ===
	{ "gr", "<cmd>lua smart_telescope.smart_lsp_incoming_calls()<cr>", desc = "📞 LSP: 谁调用了这个函数 (入调用)", nowait = true, remap = false },
	{ "go", "<cmd>lua smart_telescope.smart_lsp_outgoing_calls()<cr>", desc = "📤 LSP: 这个函数调用了谁 (出调用)", nowait = true, remap = false },
	{ "gR", "<cmd>lua smart_telescope.smart_lsp_references()<cr>", desc = "🔍 LSP: 查找所有引用", nowait = true, remap = false },

	-- === 符号搜索 ===
	{ "gs", "<cmd>lua smart_telescope.smart_lsp_document_symbols()<cr>", desc = "📄 LSP: 当前文档符号", nowait = true, remap = false },
	{ "gS", "<cmd>lua smart_telescope.smart_lsp_dynamic_workspace_symbols()<cr>", desc = "🔎 LSP: 动态工作区符号搜索", nowait = true, remap = false },

	-- === 信息显示 ===
	{ "J", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "📖 LSP: 悬浮文档 (显示详细信息)", nowait = true, remap = false },
	{ "h", "<cmd>GitGutterPreviewHunk<CR>", desc = "👁️ Git: 预览修改块", nowait = true, remap = false },

	-- === 代码操作 ===
	{ "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "🛠️ 代码操作 (修复建议)", nowait = true, remap = false },
	{ "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "✏️ 智能重命名", nowait = true, remap = false },

	-- 其他工具
	{ "<C-r>", "<cmd>lua require('undotree').toggle()<cr>", desc = "🌲 Plugin: 撤销历史树", nowait = true, remap = false },

	-- ================== Space 键映射 ==================
	-- 代码注释（使用 Comment.nvim，键位在 config/plugins.lua 中定义）
	-- 这里只是为 which-key 提供描述，实际键位已在 setup_comment() 中设置
	{ "<Space>c", desc = "💬 代码注释切换", nowait = true, remap = false },

	-- 代码格式化
	--{ "<Space>gf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", desc = "🎨 代码格式化", nowait = true, remap = false },
	--{ "<Space>gf", "<cmd>lua vim.lsp.buf.format({ async = true, timeout_ms = 2000, filter = function(client) return client.name == 'clangd' end })<cr>", desc = "🎨 代码格式化", nowait = true, remap = false },
	{ "<Space>gf", "<cmd>normal! gg=G<cr>", desc = "🎨 代码格式化 (使用 Tab 缩进)", nowait = true, remap = false },

	-- === 诊断功能 ===
	{ "<Space>gq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "📋 LSP: 当前缓冲区诊断列表", nowait = true, remap = false },
	{ "<Space>gQ", "<cmd>lua smart_telescope.smart_diagnostics()<cr>", desc = "🌍 所有文件诊断", nowait = true, remap = false },

	-- ================== Leaderf 组 ==================
	{ "<Space>j", group = "Leaderf & 其他 LSP 工具", nowait = true, remap = false },
	{ "<Space>js", "<cmd>execute printf('Leaderf gtags -s %s --top --auto-preview', expand('<cword>'))<cr>", desc = "Leaderf: 符号查询", nowait = true, remap = false },
	{ "<Space>jc", "<cmd>execute printf('Leaderf mru %s --stayOpen --preview-position cursor --no-auto-preview', expand(''))<cr>", desc = "Leaderf: 最近文件", nowait = true, remap = false },
	{ "<Space>jl", "<cmd>execute printf('Leaderf line %s --no-sort --stayOpen --preview-position cursor --no-auto-preview', expand(''))<cr>", desc = "Leaderf: 逐行搜索", nowait = true, remap = false },
	{ "<Space>jp", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", desc = "LSP: 显示工作区文件夹路径", nowait = true, remap = false },

	-- ================== Telescope & Git 组 ==================
	{ "<Space>g", group = "telescope 查找内容 & Git 操作", nowait = true, remap = false },
	{ "<Space>gG", "<cmd>lua grep_global_with_highlight()<cr>", desc = "Telescope: 全局内容搜索 (支持 ripgrep 参数)", nowait = true, remap = false },
	{ "<Space>gg", "<cmd>lua grep_word_under_cursor_with_highlight()<cr>", desc = "Telescope: 搜索光标下的词", nowait = true, remap = false },
	{ "<Space>gp", "<cmd>GitGutterPrevHunk<CR>", desc = "Git: 上一个修改块", nowait = true, remap = false },
	{ "<Space>gn", "<cmd>GitGutterNextHunk<CR>", desc = "Git: 下一个修改块", nowait = true, remap = false },
	{ "<Space>gh", "<cmd>GitGutterLineHighlightsToggle<CR>", desc = "Git: 切换修改行高亮", nowait = true, remap = false },

	-- ================== 可视模式映射 ==================
	-- 代码注释（Visual 模式，键位在 config/plugins.lua 中定义）
	{ "<Space>c", desc = "💬 可视模式代码注释", mode = "x", nowait = true, remap = false },
	{ "<Space>gf", "<cmd>normal! gv=<cr>", desc = "🎨 LSP: 格式化选中代码 (使用 Tab)", mode = "x", nowait = true, remap = false },
	{ "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "🛠️ LSP: 选中代码的操作", mode = "x", nowait = true, remap = false },

	-- ================== 文本处理 & Surround ==================
	-- 来源：whichkey.lua line 121-167
	{ "<Space>t", group = "📝 文本处理 & Surround", nowait = true, remap = false },

	-- Surround 功能 (Normal 模式)
	{ "<Space>ta", function()
		require('core.text_object_picker').show_picker(function(text_obj)
			-- 先触发 surround 的 normal 模式
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(nvim-surround-normal)', true, false, true), 'm', false)
			-- 延迟输入文本对象，让 surround 先准备好
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(text_obj, 'n', false)
			end, 10)
		end)
	end, desc = "添加包围符 (弹窗选择)", nowait = false, remap = false },
	{ "<Space>tl", "<Plug>(nvim-surround-normal-cur)", desc = "当前行添加包围符", nowait = false, remap = false },
	{ "<Space>tA", "<Plug>(nvim-surround-normal-line)", desc = "添加包围符 (新行)", nowait = false, remap = false },
	{ "<Space>tL", "<Plug>(nvim-surround-normal-cur-line)", desc = "当前行添加包围符 (新行)", nowait = false, remap = false },
	{ "<Space>td", "<Plug>(nvim-surround-delete)", desc = "删除包围符", nowait = false, remap = false },
	{ "<Space>tc", "<Plug>(nvim-surround-change)", desc = "修改包围符", nowait = false, remap = false },
	{ "<Space>tC", "<Plug>(nvim-surround-change-line)", desc = "修改包围符 (新行)", nowait = false, remap = false },

	-- Surround 功能 (Visual 模式)
	{ "<Space>t", group = "📝 文本处理 & Surround", mode = "x", nowait = false, remap = false },
	{ "<Space>tv", "<Plug>(nvim-surround-visual)", desc = "添加包围符", mode = "x", nowait = false, remap = false },
	{ "<Space>tV", "<Plug>(nvim-surround-visual-line)", desc = "添加包围符 (新行)", mode = "x", nowait = false, remap = false },
}

-- 设置 which-key 并注册所有映射
which_key.setup(setup)
which_key.add(all_mappings)
