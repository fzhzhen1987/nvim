-- core/theme.lua
-- 主题设置

-- ========================================
-- 主题和颜色设置
-- ========================================

-- 设置主题（第4行：color hybrid_reverse）
-- 使用 pcall 避免主题不存在时报错
local ok = pcall(vim.cmd, "colorscheme hybrid_reverse")
if not ok then
    -- 如果主题不存在，使用默认主题
    vim.cmd("colorscheme habamax")
end

-- 真彩色支持已在 options.lua 中设置（系统级支持）

-- 设置深色背景（第6行：set background=dark）
vim.opt.background = "dark"

-- termguicolors 已在 options.lua 中设置（系统级支持）

-- 主题相关变量（第12-14行）
vim.g.space_vim_italic = 1      -- 启用斜体
vim.g.enable_bold_font = 1      -- 启用粗体
vim.g.enable_italic_font = 1    -- 启用斜体字体

-- t_ut 终端设置已在 options.lua 中处理（系统兼容性）

-- ========================================
-- 高亮组链接
-- ========================================

-- 将CocHighlight链接到Search高亮组（第20行）
vim.cmd("highlight link CocHighlightText Search")

-- ========================================
-- 自定义高亮
-- ========================================

-- 当前行高亮（第22行）
vim.cmd("hi CursorLine guifg=#81a2be guibg=#002943")

-- 光标样式（第24-29行）
vim.cmd("hi Cursor guifg=white guibg=#5F875F")
vim.cmd("hi iCursor guifg=black guibg=Yellow")
vim.opt.guicursor = {
    "n-v-c:block-Cursor",      -- normal/visual/command模式：块状光标
    "i:ver100-iCursor",        -- insert模式：竖线光标
    "n-v-c:blinkon0",          -- normal/visual/command模式：不闪烁
    "i:blinkwait10",           -- insert模式：闪烁等待时间
}

-- 末尾空格颜色（第32行）
-- 已禁用：Tab字符不需要特殊高亮，使用默认颜色
-- vim.cmd("highlight Whitespace cterm=standout ctermfg=234 ctermbg=167 gui=standout guifg=#1d1f21 guibg=#cc6666")
vim.cmd("highlight Whitespace guifg=NONE guibg=NONE")  -- Tab使用默认颜色，无背景色

-- vim_current_word插件的同单词高亮（第35行）
vim.cmd("highlight CurrentWordTwins guifg=white guibg=blue gui=italic ctermfg=white ctermbg=blue cterm=italic")

-- Git Diff颜色（第37-40行）
vim.cmd("hi DiffAdded guifg=green ctermfg=3")
vim.cmd("hi! link DiffChange wildMenu")
vim.cmd("hi! link DiffAdd DiffAdded")
vim.cmd("hi! link DiffDelete DiagnosticError")

-- GitGutter 符号颜色
vim.cmd("hi GitGutterAdd guifg=#00ff00 ctermfg=2")       -- 新增行：绿色
vim.cmd("hi GitGutterChange guifg=#ffff00 ctermfg=3")    -- 修改行：黄色
vim.cmd("hi GitGutterDelete guifg=#ff0000 ctermfg=1")    -- 删除行：红色

-- ========================================
-- C/C++ 语义高亮（vim-lsp-cxx-highlight）
-- ========================================

-- 未激活的预处理器代码（灰色显示）（第45-47行）
vim.cmd("highlight LspCxxHlGroupInactiveCode guifg=#4a4a4a ctermfg=240 gui=italic")
vim.cmd("highlight link LspCxxHlSkippedRegion LspCxxHlGroupInactiveCode")
vim.cmd("highlight link LspCxxHlSkippedRegionBeginEnd LspCxxHlGroupInactiveCode")

-- 预处理器指令（#include, #define等）（第51行）
vim.cmd("highlight LspCxxHlSymPreprocessor guifg=#c678dd ctermfg=176 gui=bold")

-- 宏定义和宏调用（第54-55行）
vim.cmd("highlight LspCxxHlSymMacro guifg=#d19a66 ctermfg=173 gui=bold")
vim.cmd("highlight LspCxxHlGroupMacroExpansion guifg=#d19a66 ctermfg=173")

-- 枚举常量（第58行）
vim.cmd("highlight LspCxxHlGroupEnumConstant guifg=#d19a66 ctermfg=173")

-- 全局变量（第61行）
vim.cmd("highlight LspCxxHlSymVariable guifg=#e06c75 ctermfg=168")

-- 函数参数（第64行）
vim.cmd("highlight LspCxxHlSymParameter guifg=#e5c07b ctermfg=180")

-- 静态函数和变量（第67-68行）
vim.cmd("highlight LspCxxHlSymStaticMethod guifg=#61afef ctermfg=75 gui=italic")
vim.cmd("highlight LspCxxHlSymStaticField guifg=#e06c75 ctermfg=168 gui=italic")

-- 函数声明和定义（第71行）
vim.cmd("highlight LspCxxHlSymFunction guifg=#61afef ctermfg=75")

-- 结构体和联合体（第74-75行）
vim.cmd("highlight LspCxxHlSymStruct guifg=#e5c07b ctermfg=180")
vim.cmd("highlight LspCxxHlSymUnion guifg=#e5c07b ctermfg=180")

-- typedef类型别名（第78行）
vim.cmd("highlight LspCxxHlSymTypeAlias guifg=#e5c07b ctermfg=180 gui=italic")

-- 字段访问（结构体成员）（第81行）
vim.cmd("highlight LspCxxHlSymField guifg=#e06c75 ctermfg=168")

-- 标签（goto标签）（第84行）
vim.cmd("highlight LspCxxHlSymLabel guifg=#c678dd ctermfg=176")

print("主题已加载")