-- core/compiler.lua
-- 一键编译运行模块（从 language_config.vim 迁移）

-- ========================================
-- 主编译函数（language_config.vim:4-44行）
-- ========================================

-- 第3行：noremap <A-r> :call CompileRunGcc()<CR>
-- Lua 版本：设置 Alt+R 键位
vim.keymap.set('n', '<A-r>', function() CompileRunGcc() end, { desc = "一键编译运行" })

-- 主编译函数（language_config.vim:4-44行）
_G.CompileRunGcc = function()
    -- 第5行：exec "w" - 保存当前文件
    vim.cmd('w')

    -- 获取当前文件类型
    local filetype = vim.bo.filetype

    -- 第6-8行：C 语言编译（修复：使用 gcc 而不是 g++）
    if filetype == 'c' then
        vim.cmd('!gcc % -o %<')         -- 修复：C 语言应该用 gcc
        vim.cmd('!time ./%<')

    -- 第9-15行：C++ 编译（在终端中运行）
    elseif filetype == 'cpp' then
        vim.cmd('set splitbelow')           -- 设置分屏在下方
        vim.cmd('!g++ -std=c++11 % -Wall -o %<')  -- 编译（C++11标准，显示警告）
        vim.cmd('sp')                       -- 水平分屏
        vim.cmd('res -10')                  -- 调整窗口高度
        vim.cmd('term ./%<')                -- 在终端中运行
        vim.cmd('!rm -rf ./%<')             -- 删除可执行文件

    -- 第16-18行：Java 编译运行
    elseif filetype == 'java' then
        vim.cmd('!javac %')                 -- 编译 Java
        vim.cmd('!time java %<')            -- 运行并计时

    -- 第19-20行：Shell 脚本执行
    elseif filetype == 'sh' then
        vim.cmd('!time bash %')             -- 用 bash 运行并计时

    -- 第21-24行：Python 运行（终端模式）
    elseif filetype == 'python' then
        vim.cmd('set splitbelow')           -- 分屏在下方
        vim.cmd('sp')                       -- 水平分屏
        vim.cmd('term python3 %')           -- 在终端中运行 Python

    -- 第25-26行：HTML 文件用浏览器打开
    elseif filetype == 'html' then
        -- 静默执行，在后台打开 Chrome
        vim.cmd('silent! !google-chrome-stable % &')

    -- 第27-28行：Markdown 预览
    elseif filetype == 'markdown' then
        vim.cmd('MarkdownPreview')          -- 需要 markdown-preview 插件

    -- 第29-31行：LaTeX 编译
    elseif filetype == 'tex' then
        vim.cmd('silent! VimtexStop')       -- 停止之前的编译
        vim.cmd('silent! VimtexCompile')    -- 开始新的编译

    -- 第32-34行：Dart/Flutter 开发
    elseif filetype == 'dart' then
        -- 使用 CoC 插件运行 Flutter
        vim.cmd('CocCommand flutter.run -d ' .. vim.g.flutter_default_device)
        vim.cmd('CocCommand flutter.dev.openDevLog')

    -- 第35-38行：JavaScript/Node.js 运行
    elseif filetype == 'javascript' then
        vim.cmd('set splitbelow')           -- 分屏在下方
        vim.cmd('sp')                       -- 水平分屏
        -- 设置调试级别并运行 Node.js
        vim.cmd('term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .')

    -- 第39-42行：Go 语言运行
    elseif filetype == 'go' then
        vim.cmd('set splitbelow')           -- 分屏在下方
        vim.cmd('sp')                       -- 水平分屏
        vim.cmd('term go run .')            -- 运行 Go 项目
    end
end

-- ========================================
-- C++ 文件自动初始化（language_config.vim:46-65行）
-- ========================================

-- 第47行：autocmd BufNewFile *.cpp exec ":call CppInit()"
-- Lua 版本：创建新 C++ 文件时自动初始化
vim.api.nvim_create_autocmd('BufNewFile', {
    pattern = '*.cpp',
    callback = function()
        CppInit()
    end,
    desc = 'C++ 文件自动初始化'
})

-- C++ 初始化函数（language_config.vim:48-65行）
_G.CppInit = function()
    -- 第49行：检查文件扩展名
    if vim.fn.expand('%:e') == 'cpp' then
        -- 第50-57行：文件头注释
        local lines = {
            '/*',
            '*******************************************************************',
            'Author:                KyleJKC',
            'Date:                  ' .. os.date('%Y-%m-%d'),     -- 当前日期
            'FileName：             ' .. vim.fn.expand('%'),        -- 当前文件名
            'Copyright (C):         ' .. os.date('%Y') .. ' All rights reserved',  -- 版权信息
            '*******************************************************************',
            '*/',
            '#include<iostream>',    -- C++ 头文件
            '',                     -- 空行
            'int main(int argc, const char *argv[]){',  -- main 函数
            '',                     -- 空行
            '  return 0;',           -- 返回值
            '}'
        }
        
        -- 设置文件内容（第50-63行对应）
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end
end

-- ========================================
-- 其他自动命令（language_config.vim:67行）
-- ========================================

-- 第67行：autocmd BufNewFile * normal G
-- 创建新文件后跳到文件末尾
vim.api.nvim_create_autocmd('BufNewFile', {
    pattern = '*',
    callback = function()
        -- 模拟按下 G 键（跳到文件末尾）
        vim.cmd('normal! G')
    end,
    desc = '创建新文件后跳到末尾'
})

print('一键编译运行模块已加载 (Alt+R)')
