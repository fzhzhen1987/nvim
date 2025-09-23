-- ~/.config/nvim_new/init.lua
-- Neovim 配置主入口文件

-- ========================================
-- 1. 系统检测和全局变量设置
-- ========================================
local uname = vim.loop.os_uname()
_G.IS_MAC = uname.sysname == 'Darwin'
_G.IS_LINUX = uname.sysname == 'Linux'
_G.IS_WINDOWS = uname.sysname == 'Windows_NT'
_G.IS_WSL = IS_LINUX and uname.release:lower():match("microsoft") and true or false

-- 配置路径（用于跨平台兼容）
_G.CONFIG_PATH = vim.fn.stdpath('config')
_G.DATA_PATH = vim.fn.stdpath('data')
_G.CACHE_PATH = vim.fn.stdpath('cache')

-- ========================================
-- 2. 基础设置（必须最先加载）
-- ========================================
-- 设置 Leader 键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 禁用一些内置插件以加快启动速度
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- ========================================
-- 3. 安装 lazy.nvim 插件管理器
-- ========================================
local lazypath = DATA_PATH .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("正在安装 lazy.nvim 插件管理器...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- 使用稳定版本
        lazypath,
    })
    print("lazy.nvim 安装完成！")
end
vim.opt.rtp:prepend(lazypath)

-- ========================================
-- 4. 错误处理包装函数
-- ========================================
local function safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify("加载模块失败: " .. module .. "\n" .. result, vim.log.levels.ERROR)
        return nil
    end
    return result
end

-- ========================================
-- 5. 加载核心配置
-- ========================================
-- 编码设置必须最先加载，以确保正确读取文件
safe_require('core.encoding')   -- 编码处理（必须最先！）

-- 其他不依赖插件的基础配置
safe_require('core.options')    -- 基础选项设置
safe_require('core.keymaps')    -- 键位映射
safe_require('core.autocmds')   -- 自动命令
safe_require('core.project')    -- 项目管理（必须在 VimEnter 前加载）

-- ========================================
-- 6. 加载插件系统
-- ========================================
local lazy = safe_require('lazy')
if lazy then
    lazy.setup({
        spec = {
            -- 从 lua/plugins 目录加载所有插件配置
            { import = "plugins" },
        },
        defaults = {
            lazy = true, -- 默认延迟加载
            version = false, -- 不使用版本锁定
        },
        install = {
            -- 安装缺失插件时的配色方案
            colorscheme = { "habamax" },
        },
        ui = {
            border = "rounded",
            icons = {
                cmd = "⌘",
                config = "🛠",
                event = "📅",
                ft = "📂",
                init = "⚡",
                keys = "🗝",
                plugin = "🔌",
                runtime = "💻",
                source = "📄",
                start = "🚀",
                task = "📌",
                lazy = "💤 ",
            },
        },
        checker = {
            enabled = true, -- 自动检查插件更新
            notify = false, -- 不自动提示更新
            frequency = 3600, -- 每小时检查一次
        },
        performance = {
            rtp = {
                disabled_plugins = disabled_built_ins,
            },
        },
    })
end

-- ========================================
-- 7. 加载主题和高亮设置
-- ========================================
-- 这些需要在插件加载后设置
vim.schedule(function()
    safe_require('core.theme')      -- 主题设置
    safe_require('core.highlights') -- 自定义高亮
end)

-- ========================================
-- 8. 加载特殊功能模块
-- ========================================
vim.schedule(function()
    safe_require('core.compiler')   -- 一键编译运行
end)

-- ========================================
-- 9. 开发模式辅助
-- ========================================
if vim.env.NVIM_DEV then
    -- 开发模式下的额外设置
    vim.opt.verbose = 1
    
    -- 重新加载配置的快捷命令
    vim.api.nvim_create_user_command('ReloadConfig', function()
        -- 清除 Lua 模块缓存
        for name, _ in pairs(package.loaded) do
            if name:match('^core') or name:match('^plugins') or name:match('^config') then
                package.loaded[name] = nil
            end
        end
        -- 重新加载配置
        dofile(vim.env.MYVIMRC)
        vim.notify("配置已重新加载", vim.log.levels.INFO)
    end, {})
end

-- ========================================
-- 10. 启动完成提示
-- ========================================
vim.schedule(function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    vim.notify("⚡ Neovim 启动完成，耗时 " .. ms .. "ms", vim.log.levels.INFO)
end)