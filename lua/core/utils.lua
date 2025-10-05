-- core/utils.lua
-- 工具函数模块（整合 FZH_lua/utils.lua 和 G.lua）

-- ========================================
-- 来自 FZH_lua/G.lua 的全局封装
-- ========================================

local M = {}

-- Neovim API 的简化访问
M.g = vim.g
M.b = vim.b
M.fn = vim.fn
M.api = vim.api

-- 批量设置键位映射（兼容老版本 API）
function M.map(maps)
    for _, map_config in pairs(maps) do
        M.api.nvim_set_keymap(map_config[1], map_config[2], map_config[3], map_config[4])
    end
end

-- 执行命令的简化函数
function M.cmd(cmd)
    M.api.nvim_command(cmd)
end

-- 执行多行 Vimscript
function M.exec(script)
    M.api.nvim_exec(script, false)
end

-- 计算表达式
function M.eval(expr)
    return M.api.nvim_eval(expr)
end

-- ========================================
-- 来自 FZH_lua/utils.lua 的字符串工具
-- ========================================

-- 检查字符串是否以指定后缀结尾
M.ends_with = function(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

-- ========================================
-- 额外的工具函数
-- ========================================

-- 安全地 require 模块
M.safe_require = function(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify("模块加载失败: " .. module .. "\n" .. result, vim.log.levels.ERROR)
        return nil
    end
    return result
end

-- 检查插件是否已安装
M.plugin_exists = function(plugin_name)
    local plugins = require("lazy").plugins()
    for _, plugin in ipairs(plugins) do
        if plugin.name == plugin_name then
            return true
        end
    end
    return false
end

-- 获取当前操作系统
M.get_os = function()
    local uname = vim.loop.os_uname()
    if uname.sysname == 'Darwin' then
        return 'mac'
    elseif uname.sysname == 'Linux' then
        return 'linux'
    elseif uname.sysname == 'Windows_NT' then
        return 'windows'
    else
        return 'unknown'
    end
end

-- 检查是否在 WSL 环境
M.is_wsl = function()
    local uname = vim.loop.os_uname()
    return M.get_os() == 'linux' and uname.release:lower():match("microsoft") ~= nil
end

return M