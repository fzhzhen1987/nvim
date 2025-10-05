-- plugins/git.lua
-- Git 相关插件（版本已全部锁定）

return {
	-- ========================================
	-- 在行号旁显示 git 修改标记
	-- 来源：plug_list.vim line 43 - airblade/vim-gitgutter
	-- ========================================
	{
		"airblade/vim-gitgutter",
		commit = "488c0555e47e2aabe273c635f7dd233e985311a6",  -- 锁定版本
		lazy = false,
		init = function()
			require("config.plugins").setup_gitgutter()
		end,
	},
}
