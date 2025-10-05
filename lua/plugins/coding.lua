-- plugins/coding.lua
-- LSP、语法高亮、补全等编程相关插件（版本已全部锁定）

return {
	-- ========================================
	-- C/C++ LSP 语义高亮（支持 ifdef 变灰）
	-- 来源：plug_list.vim line 66 - jackguo380/vim-lsp-cxx-highlight
	-- ========================================
	{
		"jackguo380/vim-lsp-cxx-highlight",
		commit = "e0c749e955446b4e9e4cc33833fa45e30d8a15fe",  -- 锁定版本
		ft = { "c", "cpp", "cc", "h", "hpp" },  -- 只在 C/C++ 文件中加载
		init = function()
			require("config.plugins").setup_lsp_cxx_highlight()
		end,
	},

	-- ========================================
	-- 自动生成和管理 ctags/gtags 标签文件
	-- 来源：plug_list.vim line 69 - ludovicchabant/vim-gutentags
	-- 使用 fork 版本：git@github.com:fzhzhen1987/vim-gutentags.git
	-- ========================================
	{
		"fzhzhen1987/vim-gutentags",
		commit = "d411addfeea5705a7bdb72231ec2fc9420f633f4",  -- 锁定版本
		lazy = false,
		init = function()
			require("config.plugins").setup_gutentags()
		end,
	},

	-- ========================================
	-- Treesitter 语法高亮和代码分析
	-- 来源：plugins_new.lua line 129 - nvim-treesitter/nvim-treesitter
	-- 功能：更精准的语法高亮、代码折叠、增量选择等
	-- ========================================
	{
		"nvim-treesitter/nvim-treesitter",
		version = "v0.9.2",  -- 锁定版本
		build = ":TSUpdate",  -- 安装后自动更新解析器
		event = { "BufReadPost", "BufNewFile" },  -- 打开文件时加载
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",  -- 文本对象支持
				commit = "71385f191ec06ffc60e80e6b0c9a9d5daed4824c",  -- 锁定版本
			},
			{
				"HiPhish/rainbow-delimiters.nvim",  -- 彩虹括号（替代 nvim-ts-rainbow）
				version = "v0.10.0",  -- 锁定版本
			},
		},
		config = function()
			require("config.plugins").setup_treesitter()
		end,
	},
}
