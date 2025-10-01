-- plugins/lsp.lua
-- LSP、自动补全、代码片段相关插件

return {
	-- ========================================
	-- LSP 配置插件
	-- 来源：plugins_new.lua line 130 - neovim/nvim-lspconfig
	-- ========================================
	{
		"neovim/nvim-lspconfig",
		version = "v0.1.*",  -- 兼容 Neovim 0.9，避免废弃警告
		lazy = false,  -- LSP 需要立即加载
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",  -- LSP 补全源
		},
		config = function()
			require("lsp").setup()
		end,
	},

	-- ========================================
	-- 自动补全引擎
	-- 来源：plugins_new.lua line 133 - hrsh7th/nvim-cmp
	-- ========================================
	{
		"hrsh7th/nvim-cmp",
		version = "v0.0.2",  -- 锁定版本
		event = "InsertEnter",  -- 进入插入模式时加载
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp", commit = "99290b3" },  -- 使用 0.11 之前的版本，兼容 Neovim 0.9.4
			{ "hrsh7th/cmp-buffer", commit = "b74fab3656eea9de20a9b8116afa3cfc4ec09657" },
			{ "hrsh7th/cmp-path", commit = "c642487086dbd9a93160e1679a1327be111cbc25" },
			{ "hrsh7th/cmp-nvim-lua", commit = "f12408bdb54c39c23e67cab726264c10db33ada8" },
			{ "saadparwaiz1/cmp_luasnip", commit = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90" },
			{ "L3MON4D3/LuaSnip", version = "v2.4.0" },
			{ "onsails/lspkind-nvim", commit = "3ddd1b4edefa425fda5a9f95a4f25578727c0bb3" },
		},
		-- 补全配置在 lsp/completion.lua 中，由 lsp/init.lua 调用
	},

	-- 代码片段和补全图标已在 nvim-cmp 的 dependencies 中定义
}
