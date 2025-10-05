-- plugins/ui.lua
-- UI和主题相关插件定义

return {
    -- ========================================
    -- 主题插件
    -- 来源：plug_list.vim line 61 - kristijanhusak/vim-hybrid-material
    -- 使用：hybrid_reverse
    -- ========================================
    {
        "kristijanhusak/vim-hybrid-material",
        name = "hybrid-material",
        commit = "HEAD",  -- 锁定当前版本
        lazy = false,
        priority = 1000,
        config = function()
            require("config.plugins").setup_theme()
        end,
    },

    -- ========================================
    -- 顶部标签栏（显示打开的 buffer）
    -- 来源：plugins_new.lua line 88 - akinsho/bufferline.nvim
    -- ========================================
    {
        "akinsho/bufferline.nvim",
        version = "v3.7.0",  -- 锁定版本，v4 需要 Neovim 0.10+
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("config.bufferline")
        end,
    },

    -- ========================================
    -- 文件图标（依赖库）
    -- 来源：plugins_new.lua line 82 - nvim-web-devicons
    -- ========================================
    {
        "nvim-tree/nvim-web-devicons",
        commit = "HEAD",  -- 锁定当前版本
        lazy = true,
    },

    -- ========================================
    -- 底部状态栏（显示文件信息、模式、位置、当前函数等）
    -- 来源：plugins_new.lua line 91-94 - nvim-lualine/lualine.nvim
    -- ========================================
    {
        "nvim-lualine/lualine.nvim",
        version = "compat-nvim-0.5",  -- 锁定兼容版本
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("config.lualine")
        end,
    },

    -- ========================================
    -- 键位提示面板
    -- 来源：plugins_new.lua line 102 - folke/which-key.nvim
    -- 功能：显示可用的键位绑定和说明
    -- ========================================
    {
        "folke/which-key.nvim",
        commit = "904308e6885bbb7b60714c80ab3daf0c071c1492",  -- 锁定版本 (stable分支)
        event = "VeryLazy",
        config = function()
            require("config.whichkey")
        end,
    },
}