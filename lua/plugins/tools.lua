-- plugins/tools.lua
-- 文件管理、搜索、工具类插件（版本已全部锁定）

return {
	-- ========================================
	-- tig 集成（Git 变更查看和交互）
	-- 插件：iberianpig/tig-explorer.vim
	-- 功能：在 tig 中按 e 直接在 nvim 中打开文件（非弹窗）
	-- ========================================
	{
		"iberianpig/tig-explorer.vim",
		commit = "ac49ff17f51c1cbe3128b3632edbd8f8ba88adcc",  -- 最新版本（2025-04-09）
		lazy = false,
		config = function()
			-- tig 打开方式：使用新 tab
			vim.g.tig_explorer_use_builtin_term = 0  -- 不使用内置终端（避免弹窗）
			vim.g.tig_open_command = 'tabnew'  -- 使用新 tab 打开 tig

			-- 键位映射
			vim.keymap.set('n', '<leader>rt', ':TigOpenProjectRootDir<CR>', {
				silent = true,
				desc = '🌳 Tig: 打开 Git 仓库'
			})

			vim.keymap.set('n', '<leader>rb', ':TigBlame<CR>', {
				silent = true,
				desc = '📝 Tig: 当前文件 blame'
			})

			vim.keymap.set('n', '<leader>rg', ':Tig<CR>', {
				silent = true,
				desc = '📊 Tig: Git log（当前目录）'
			})

			vim.keymap.set('n', '<leader>rs', ':TigStatus<CR>', {
				silent = true,
				desc = '📋 Tig: Git status'
			})

			vim.keymap.set('n', '<leader>rh', ':TigOpenCurrentFile<CR>', {
				silent = true,
				desc = '📜 Tig: 当前文件历史'
			})
		end,
	},

	-- ========================================
	-- 模糊查找器（文件、缓冲区、标签、代码搜索等）
	-- 来源：plug_list.vim line 70 - Yggdroot/LeaderF
	-- 非常重要的插件，需要编译 C 扩展
	-- ========================================
	{
		"Yggdroot/LeaderF",
		version = "v1.25",  -- 锁定版本
		lazy = false,
		build = ":LeaderfInstallCExtension",
		init = function()
			require("config.plugins").setup_leaderf()
		end,
	},

	-- ========================================
	-- Quickfix 窗口增强
	-- 来源：plugins_new.lua line 97 - kevinhwang91/nvim-bqf
	-- 功能：预览、模糊过滤、标记筛选等
	-- ========================================
	{
		"kevinhwang91/nvim-bqf",
		version = "v1.1.1",  -- 锁定版本
		ft = "qf",  -- 只在打开 quickfix 时加载
		config = function()
			require("config.nvimbqf")
		end,
	},

	-- ========================================
	-- Telescope 模糊查找系统
	-- 来源：plugins_new.lua line 123-125
	-- 功能：文件搜索、内容搜索、LSP跳转等
	-- ========================================
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.0",  -- 锁定版本
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",  -- 必需依赖
			{
				"nvim-telescope/telescope-fzf-native.nvim",  -- FZF 原生搜索
				commit = "1f08ed60cafc8f6168b72b80be2b2ea149813e55",  -- 锁定版本
				build = "make",
			},
			{
				"nvim-telescope/telescope-live-grep-args.nvim",  -- 支持 ripgrep 参数
				version = "v1.1.0",  -- 锁定版本
			},
		},
		config = function()
			require("config.telescope")
		end,
	},
}
