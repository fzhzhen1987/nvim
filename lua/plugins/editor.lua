-- plugins/editor.lua
-- 编辑器增强类插件定义（版本已全部锁定）

return {
	-- ========================================
	-- Lua 函数库（很多插件的依赖）
	-- 来源：plugins_new.lua - nvim-lua/plenary.nvim
	-- ========================================
	{
		"nvim-lua/plenary.nvim",
		version = "v0.1.4",  -- 锁定版本
		lazy = true,
	},

	-- ========================================
	-- 中文帮助文档
	-- 来源：plugins_new.lua line 85 - yianwillis/vimcdoc
	-- 用法：安装后直接使用 :help xxx 即可看到中文帮助
	-- 无需配置，自动生效
	-- ========================================
	{
		"yianwillis/vimcdoc",
		version = "v2.5.0",  -- 锁定版本
		event = "VeryLazy",  -- 延迟加载，不影响启动速度
	},

	-- ========================================
	-- 自动配对符号
	-- 来源：plug_list.vim line 76-84 - jiangmiao/auto-pairs
	-- ========================================
	{
		"jiangmiao/auto-pairs",
		version = "v2.0.0",  -- 锁定版本
		lazy = false,  -- 启动时立即加载，确保配置始终生效
		init = function()
			-- 配置必须在插件加载之前设置
			require("config.plugins").setup_autopairs()
		end,
	},

	-- ========================================
	-- 关闭 buffer 但保留窗口布局
	-- 来源：plug_list.vim line 26 - moll/vim-bbye
	-- ========================================
	{
		"moll/vim-bbye",
		version = "v1.0.1",  -- 锁定版本
		lazy = false,
		config = function()
			require("config.plugins").setup_bbye()
		end,
	},

	-- ========================================
	-- 手动高亮多个单词，支持分屏同步
	-- 来源：plug_list.vim line 29 - azabiong/vim-highlighter
	-- ========================================
	{
		"azabiong/vim-highlighter",
		version = "1.63",  -- 锁定版本
		lazy = false,
		init = function()
			require("config.plugins").setup_highlighter()
		end,
	},

	-- ========================================
	-- 自动高亮光标下的单词及其他相同单词
	-- 来源：plug_list.vim line 30 - dominikduda/vim_current_word
	-- ========================================
	{
		"dominikduda/vim_current_word",
		commit = "967c73804e38e5b2ceaa536328a4f76f1157a482",  -- 锁定版本
		lazy = false,
		init = function()
			require("config.plugins").setup_current_word()
		end,
	},

	-- ========================================
	-- Tab缩进参考线（保持原版插件）
	-- 来源：plug_list.vim line 46 - nathanaelkane/vim-indent-guides
	-- 功能：只在Tab缩进时显示彩色背景，空格缩进不显示
	-- ========================================
	{
		"nathanaelkane/vim-indent-guides",
		commit = "a1e1390c0136e63e813d051de2003bf0ee18ae30",  -- 最新版本（2023-03-18）
		lazy = false,
		init = function()
			-- 禁用默认键位映射
			vim.g.indent_guides_default_mapping = 0
			vim.keymap.set('n', '<nop>', '<Plug>IndentGuidesToggle', { silent = true })

			-- 启动时自动开启
			vim.g.indent_guides_enable_on_vim_startup = 1

			-- 禁用自动颜色
			vim.g.indent_guides_auto_colors = 0

			-- 设置缩进线颜色（需要在主题加载后设置）
			vim.api.nvim_create_autocmd({"VimEnter", "Colorscheme"}, {
				pattern = "*",
				callback = function()
					vim.cmd("hi IndentGuidesOdd guibg=green ctermbg=3")
					vim.cmd("hi IndentGuidesEven guibg=purple ctermbg=4")
				end
			})

			-- 颜色变化百分比
			vim.g.indent_guides_color_change_percent = 5

			-- 从第2级开始显示
			vim.g.indent_guide_start_level = 2

			-- 缩进线宽度
			vim.g.indent_guides_guide_size = 1

			-- 不显示空格缩进线（只显示Tab缩进）
			vim.g.indent_guides_space_guides = 0
		end,
	},

	-- ========================================
	-- 多光标编辑
	-- 来源：plug_list.vim line 49 - mg979/vim-visual-multi
	-- ========================================
	{
		"mg979/vim-visual-multi",
		version = "v0.5.8",  -- 锁定版本
		branch = "master",
		lazy = false,
		init = function()
			require("config.plugins").setup_visual_multi()
		end,
	},

	-- ========================================
	-- 撤销树可视化（Lua 版本）
	-- 来源：jiaoshijie/undotree
	-- 功能：以树形结构可视化查看撤销历史
	-- ========================================
	{
		"jiaoshijie/undotree",
		commit = "eab459ab87dd249617b5f7187bb69e614a083047",  -- 锁定版本
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{ "<C-r>", "<cmd>lua require('undotree').toggle()<cr>", desc = "🌲 撤销历史树" }
		},
		config = function()
			require('undotree').setup({
				float_diff = true,  -- 使用浮动窗口预览差异
				layout = "left_bottom", -- 布局：left_bottom, left_left_bottom
				ignore_filetype = {
					'Undotree',
					'UndotreeDiff',
					'qf',
					'TelescopePrompt',
					'spectre_panel',
					'tsplayground'
				},
				window = {
					winblend = 30,
				},
				keymaps = {
					['<C-n>'] = "move_next",
					['<C-p>'] = "move_prev",
					J = "move_change_next",
					K = "move_change_prev",
					['<cr>'] = "action_enter",
					e = "enter_diffbuf",
					q = "quit",
				},
			})
		end,
	},

	-- ========================================
	-- 代码注释插件（替换 kommentary）
	-- 来源：numToStr/Comment.nvim（替换 b3nj5m1n/kommentary）
	-- 功能：快速注释/取消注释代码，活跃维护中
	-- ========================================
	{
		"numToStr/Comment.nvim",
		version = "v0.8.0",  -- 锁定版本
		lazy = false,
		config = function()
			require("config.plugins").setup_comment()
		end,
	},

	-- ========================================
	-- 包围符号操作插件
	-- 来源：plugins_new.lua line 105-126 - kylechui/nvim-surround
	-- 功能：添加、删除、修改包围符号（引号、括号、标签等）
	-- 键位：<Space>t 系列（在 whichkey.lua 中定义）
	-- ========================================
	{
		"kylechui/nvim-surround",
		version = "v3.1.6",  -- 锁定版本
		event = "VeryLazy",
		config = function()
			require("config.plugins").setup_surround()
		end,
	},
}
