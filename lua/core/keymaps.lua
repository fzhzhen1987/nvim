-- core/keymaps.lua
-- 基础键位映射

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ========================================
-- 基础设置
-- ========================================
-- Leader 键在 init.lua 中设置
-- vim.g.mapleader = " "

-- ========================================
-- 命令行模式补全
-- ========================================
-- 注意：命令行模式不使用 silent 选项，否则可能导致键位失效
local cmdline_opts = { noremap = true, silent = false }
map('c', '<C-f>', '<right>', cmdline_opts)
map('c', '<C-b>', '<left>', cmdline_opts)
map('c', '<C-a>', '<HOME>', cmdline_opts)
map('c', '<C-e>', '<END>', cmdline_opts)
map('c', '<C-p>', '<up>', cmdline_opts)
map('c', '<C-n>', '<down>', cmdline_opts)

-- ========================================
-- 禁用某些键位
-- ========================================
-- 只在 normal 和 visual 模式下禁用 u，保持 operator-pending 模式正常
map('n', 'u', '<nop>', opts)
map('v', 'u', '<nop>', opts)
-- 只在 normal 和 visual 模式下禁用 w，保持 operator-pending 模式正常
map('n', 'w', '<nop>', opts)
map('v', 'w', '<nop>', opts)

-- ========================================
-- 系统相关
-- ========================================
if _G.IS_WINDOWS then
    map('n', '<F2>', ':source ~/AppData/Local/nvim/init.vim<CR>', { desc = "重载配置" })
else
    map('n', '<F2>', ':source ~/.config/nvim/init.lua<CR>', { desc = "重载配置" })
end

-- 插件管理（Lazy.nvim）
map('n', '<F3>', ':Lazy install<CR>', { desc = "安装插件" })
map('n', '<F4>', ':Lazy update<CR>', { desc = "更新插件" })

-- ========================================
-- 基础编辑
-- ========================================
-- 复制到系统剪贴板
map('v', '<C-c>', '"+y', { desc = "复制到剪贴板" })

-- 取消搜索高亮
map('n', '<leader><CR>', ':nohlsearch<CR>', { desc = "取消高亮" })

-- 屏幕滚动
-- 先解绑 l 的默认功能（向右移动）
map('n', 'l', '<nop>', opts) -- 禁用 l 的默认功能
-- 设置新的滚动键
map('n', 'L', '<C-y>', { desc = "向上滚动一行" }) -- L (大写) 向上滚动
map('n', 'l', '<C-e>', { desc = "向下滚动一行" }) -- l (小写) 向下滚动

-- ========================================
-- 移动键位重映射
-- ========================================
-- Normal 模式移动
map('n', '<C-p>', 'k', opts)
map('n', '<C-n>', 'j', opts)
map('n', '<C-b>', 'h', opts)
map('n', '<C-f>', 'l', opts)

-- Visual 模式移动（和 Normal 模式一致）
map('v', '<C-p>', 'k', opts)
map('v', '<C-n>', 'j', opts)
map('v', '<C-b>', 'h', opts)
map('v', '<C-f>', 'l', opts)

-- Operator-pending 模式移动（和 Normal 模式一致）
map('o', '<C-p>', 'k', opts)
map('o', '<C-n>', 'j', opts)
map('o', '<C-b>', 'h', opts)
map('o', '<C-f>', 'l', opts)

-- Insert 模式移动
map('i', '<C-p>', '<up>', opts)
map('i', '<C-n>', '<down>', opts)
map('i', '<C-b>', '<left>', opts)
map('i', '<C-f>', '<right>', opts)

-- 快速上下移动 - 只在 normal 和 visual 模式
map('n', 'W', '5kzz', { desc = "快速向上" })
map('v', 'W', '5kzz', { desc = "快速向上" })
map('n', 'S', '5jzz', { desc = "快速向下" })
map('v', 'S', '5jzz', { desc = "快速向下" })

-- ========================================
-- 模式切换
-- ========================================
-- 插入模式快速退出
map('i', '<C-s>', '<esc>', opts)

-- e 进入插入模式 - 只在 normal 和 visual 模式
map('n', 'e', 'a', opts)
map('v', 'e', 'a', opts)

-- ========================================
-- 单词和行操作
-- ========================================
-- 单词移动 - 只在 normal 和 visual 模式
map('n', 'a', 'b', opts) -- 向前移动到单词开头
map('v', 'a', 'b', opts)
map('n', 'd', 'e', opts) -- 向后移动到单词结尾
map('v', 'd', 'e', opts)

-- 删除操作
map('n', '<C-j>', 'diw', { desc = "删除单词" })
map('v', '<C-j>', 'diw', { desc = "删除单词" })
map('n', '<C-h>', 'X', { desc = "删除前一个字符" })
map('v', '<C-h>', 'X', { desc = "删除前一个字符" })

-- j 用于删除 - 只在 normal 和 visual 模式
map('n', 'j', 'd', opts)
map('v', 'j', 'd', opts)
-- 双击 j 删除整行
map('n', 'jj', 'dd', opts)

-- 跳到行首/行尾
map('n', '<C-a>', '<home>', opts)
map('v', '<C-a>', '<home>', opts)
map('n', '<C-e>', '<end>', opts)
map('v', '<C-e>', '<end>', opts)
map('i', '<C-a>', '<home>', opts)
map('i', '<C-e>', '<end>', opts)

-- ========================================
-- 查找和跳转
-- ========================================
-- 查找光标所在位置单词
map('n', '-', '*', { desc = "向下查找当前单词" })
map('n', '=', '#', { desc = "向上查找当前单词" })
map('n', "'", '%', { desc = "跳转到匹配括号" })

-- ========================================
-- 文件操作
-- ========================================
map('n', '<C-s>', ':w<CR>', { desc = "保存文件" })
map('n', '<C-q>', ':q<CR>', { desc = "退出" })
map('n', 'Q', ':wq<CR>', { desc = "保存并退出" })
map('n', '<A-q>', ':qa<CR>', { desc = "退出所有" })

-- 强制退出
map('n', '<C-q><C-q>', ':q!<CR>', { desc = "强制退出" })

-- 删除行尾空格
map('n', '<C-z>', ':%s/\\s*$//g<CR>', { desc = "删除行尾空格" })
map('v', '<C-z>', ':s/\\s*$//g<CR>', { desc = "删除选中行尾空格" })
-- 插入模式禁用 C-z，避免误触挂起
map('i', '<C-z>', '<nop>', opts)

-- ========================================
-- 标签页和缓冲区
-- ========================================
map('n', 'wn', 'mm :tabnew %<CR> `m', { desc = "新建标签页" })
map('n', 'gn', ':tabnext<CR>', { desc = "下一个标签页" })
map('n', 'gp', ':tabprevious<CR>', { desc = "上一个标签页" })
map('n', '<S-x>', ':bnext<CR>', { desc = "下一个缓冲区" })
map('n', '<S-z>', ':bprevious<CR>', { desc = "上一个缓冲区" })

-- ========================================
-- 其他
-- ========================================
-- 分号映射到冒号
map('n', ';', ':', opts)

-- ========================================
-- C语言大括号跳转功能（需要定义函数）
-- ========================================
-- 禁用原生的方括号和花括号跳转
map('n', '[[', '<nop>', opts)
map('n', ']]', '<nop>', opts)
map('n', '[]', '<nop>', opts)
map('n', '][', '<nop>', opts)
map('n', '[{', '<nop>', opts)
map('n', ']}', '<nop>', opts)
map('n', '{', '<nop>', opts)   -- 禁用原生段落跳转
map('n', '}', '<nop>', opts)   -- 禁用原生段落跳转

-- 自定义的块跳转功能
local function setup_bracket_jumps()
    -- 向外跳转：跳到外层块的开始 {
    map('n', '[[', ':lua JumpToOuterBlockStart()<CR>', { desc = "跳到外层块开始" })
    -- 向外跳转：跳到外层块的结束 }
    map('n', ']]', ':lua JumpToOuterBlockEnd()<CR>', { desc = "跳到外层块结束" })
    -- 向内跳转：在当前函数内跳到下一个 {
    map('n', '{', ':lua JumpToInnerBlockStart()<CR>', { desc = "函数内跳到下一个{" })
    -- 向内跳转：在当前函数内跳到下一个 }
    map('n', '}', ':lua JumpToInnerBlockEnd()<CR>', { desc = "函数内跳到下一个}" })
end

-- ========================================
-- 分屏操作（这些适合放到 which-key）
-- ========================================
-- 分屏
map('n', '<leader>wd', ':set splitright<CR>:vsplit<CR>', { desc = "右分屏" })
map('n', '<leader>wa', ':set nosplitright<CR>:vsplit<CR>', { desc = "左分屏" })
map('n', '<leader>ww', ':set nosplitbelow<CR>:split<CR>', { desc = "上分屏" })
map('n', '<leader>ws', ':set splitbelow<CR>:split<CR>', { desc = "下分屏" })
map('n', '<leader>wn', ':new <CR>', { desc = "新窗口" })

-- 焦点变换
map('n', '<A-d>', '<C-w>l', { desc = "焦点向右" })
map('n', '<A-w>', '<C-w>k', { desc = "焦点向上" })
map('n', '<A-a>', '<C-w>h', { desc = "焦点向左" })
map('n', '<A-s>', '<C-w>j', { desc = "焦点向下" })

-- 调整窗口大小
map('n', '<A-C-w>', ':res +1<CR>', { desc = "高度增加" })
map('n', '<A-C-s>', ':res -1<CR>', { desc = "高度减少" })
map('n', '<A-C-a>', ':vertical resize-1<CR>', { desc = "宽度减少" })
map('n', '<A-C-d>', ':vertical resize+1<CR>', { desc = "宽度增加" })

-- 窗口布局切换
map('n', '<leader>we', '<C-w>t<C-w>H', { desc = "垂直转水平" })
map('n', '<leader>wo', '<C-w>t<C-w>K', { desc = "水平转垂直" })

-- ========================================
-- C语言智能括号跳转函数
-- ========================================
_G.JumpToOuterBlockStart = function()
    -- 向外跳转：使用 Vim 内置的 [{ 跳到外层块开始
    local original_pos = vim.fn.getpos(".")
    vim.cmd('normal! [{')

    -- 如果位置没有改变，说明已经在最外层了
    if vim.deep_equal(vim.fn.getpos("."), original_pos) then
        print("Already at outermost block")
    end
end

_G.JumpToOuterBlockEnd = function()
    -- 向外跳转：使用 Vim 内置的 ]} 跳到外层块结束
    local original_pos = vim.fn.getpos(".")
    vim.cmd('normal! ]}')

    -- 如果位置没有改变，说明已经在最外层了
    if vim.deep_equal(vim.fn.getpos("."), original_pos) then
        print("Already at outermost block")
    end
end

_G.JumpToInnerBlockStart = function()
    -- 向内跳转：进入更深层的 {
    local original_pos = vim.fn.getpos(".")
    local original_line = original_pos[2]

    -- 找到当前所在函数的范围：向上找函数开始的 {，然后找到匹配的 }
    -- 先保存当前位置，向上搜索函数级别的 {
    local search_pos = vim.fn.searchpairpos('{', '', '}', 'bnW')
    if search_pos[1] == 0 then
        print("Not inside a function")
        return
    end

    -- 从找到的 { 位置，找到匹配的 }
    vim.fn.setpos('.', {0, search_pos[1], search_pos[2], 0})
    vim.cmd('normal! %')
    local function_end_line = vim.fn.line('.')

    -- 返回原位置
    vim.fn.setpos('.', original_pos)

    -- 在当前函数范围内向下搜索下一个 {
    local found = vim.fn.search('{', 'W', function_end_line)

    -- 如果没有找到，或者位置没变，恢复原位置并提示
    if found == 0 or vim.fn.line('.') == original_line then
        vim.fn.setpos('.', original_pos)
        print("No inner block found in current function")
    end
end

_G.JumpToInnerBlockEnd = function()
    -- 向内跳转：进入更深层的 }
    local original_pos = vim.fn.getpos(".")
    local original_line = original_pos[2]

    -- 找到当前所在函数的范围：向上找函数开始的 {，然后找到匹配的 }
    local search_pos = vim.fn.searchpairpos('{', '', '}', 'bnW')
    if search_pos[1] == 0 then
        print("Not inside a function")
        return
    end

    -- 从找到的 { 位置，找到匹配的 }
    vim.fn.setpos('.', {0, search_pos[1], search_pos[2], 0})
    vim.cmd('normal! %')
    local function_end_line = vim.fn.line('.')

    -- 返回原位置
    vim.fn.setpos('.', original_pos)

    -- 在当前函数范围内向下搜索下一个 }
    local found = vim.fn.search('}', 'W', function_end_line)

    -- 如果没有找到，或者位置没变，恢复原位置并提示
    if found == 0 or vim.fn.line('.') == original_line then
        vim.fn.setpos('.', original_pos)
        print("No inner block found in current function")
    end
end

-- 调用设置函数
setup_bracket_jumps()

-- ========================================
-- 可用的键位（备用）
-- ========================================
-- <C-l> - 当前为默认功能（重绘屏幕），可以绑定为其他功能

print("基础键位已加载")
