-- core/options.lua
-- Neovim 基础选项设置（从原配置文件迁移）

local opt = vim.opt
local g = vim.g

-- ========================================
-- 来自 nvim/core/general_config.vim
-- ========================================

-- Shada 文件设置 (general_config.vim:1)
opt.shada = "!,'300,<50,@100,s10,h"

-- 实时显示命令效果 (general_config.vim:20-22)
if vim.fn.exists('+inccommand') == 1 then
    opt.inccommand = 'nosplit'
end

-- Grep 设置已删除 (general_config.vim:24-30)
-- 原因：主要使用 LeaderF/Telescope 等插件搜索，它们有自己的配置
-- 这些设置只影响 :grep 命令，而 :grep 命令基本不用

-- 补全弹窗设置已删除 (general_config.vim:32-35)
-- 原因：使用 nvim-cmp 进行代码补全，它有自己的显示方式
-- completepopup 只影响内置补全，不影响命令行补全（wildmenu）

-- 跳转列表设置 (general_config.vim:38-40)
-- 使用栈式跳转列表，保留完整的跳转历史
opt.jumpoptions = 'stack'

-- Diff 设置 (general_config.vim:42-45)
-- 使用内部diff引擎和patience算法，提供更准确和易读的差异比较
-- 使用方法：:vimdiff file1 file2 或 nvim -d file1 file2
opt.diffopt:append('internal,algorithm:patience')

-- 标题栏设置 (general_config.vim:49-51)
vim.o.titlestring = "%{expand('%:p:~:.')}%(%m%r%w%) %<[%{fnamemodify(getcwd(), ':~')}] - Neovim"

-- 折叠设置已删除 (general_config.vim:54-58)
-- 原因：从未使用过代码折叠功能
-- 删除 foldenable、foldmethod、foldlevelstart 等设置

-- 隐藏设置 (general_config.vim:60-63)
-- 完全禁用文本隐藏功能，所有文本按原样显示
opt.conceallevel = 0

-- 预览弹窗设置 (general_config.vim:65-67)
-- 配置预览窗口为浮动弹窗样式，用于 LeaderF、LSP、Telescope 等的预览功能
if vim.fn.exists('+previewpopup') == 1 then
    opt.previewpopup = 'height:10,width:60'
end

-- 透明度设置 (general_config.vim:69-76)
-- 设置弹出菜单和浮动窗口的轻微透明效果（需要真彩色支持）
if vim.o.termguicolors then
    opt.pumblend = 10   -- 弹出菜单 10% 透明
    opt.winblend = 10   -- 浮动窗口 10% 透明
end

-- 鼠标设置 (general_config.vim:81-86)
-- 所有系统都完全禁用鼠标支持
opt.mouse = ''
-- 原配置中 Windows 下的 <LeftRelease> 映射已删除（因为鼠标已禁用）

-- ========================================
-- 来自 nvim/core/special_config.vim
-- ========================================

-- 禁用 Python 2 提供程序 (special_config.vim:2)
g.loaded_python_provider = 0

-- Python 3 路径设置 (special_config.vim:4-8)
if vim.env.OS == 'Windows_NT' then
    g.python3_host_prog = 'C:/Scoop/apps/python/current/python.exe'
else
    g.python3_host_prog = '/usr/bin/python3'
end

-- ========================================
-- 来自 nvim/core/theme.vim
-- ========================================

-- 系统级真彩色支持 (theme.vim:5,7) - 为主题提供基础支持
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1  -- 统一使用数字格式
opt.termguicolors = true
-- background 和其他主题设置已移至 theme.lua

-- 光标设置已移至 theme.lua（视觉效果相关）

-- 终端设置 (theme.vim:15)
vim.o.t_ut = ''

-- 主题相关变量 (theme.vim:12-14)
g.space_vim_italic = 1
g.enable_bold_font = 1
g.enable_italic_font = 1

-- ========================================
-- 编码设置已移至 core/encoding.lua
-- ========================================
-- 编码相关设置已经在 encoding.lua 中完整实现
-- 包括基础编码设置和高级编码保持功能

-- ========================================
-- 来自 FZH_lua/general_setting.lua
-- ========================================

-- 基础显示设置
opt.wrap = false              -- 不自动换行，长行会水平滚动而不是自动折行
opt.showmatch = true          -- 输入括号时短暂高亮匹配的另一半括号
opt.hidden = true             -- 允许切换buffer而不保存当前文件，未保存的更改会保留在内存中
opt.fileformats = 'unix,dos,mac'  -- 支持的文件格式（行结束符）：Unix(\n)、DOS(\r\n)、Mac(\r)
opt.showcmd = true            -- 在状态栏右下角显示正在输入的命令（如 d2w 会显示）

-- Tab 和缩进设置
opt.textwidth = 80           -- 文本宽度限制为80字符，超过会自动换行（如果开启了自动格式化）
opt.expandtab = false        -- 保持真实的 Tab 字符，不转换为空格
opt.tabstop = 2              -- Tab 字符在屏幕上显示为2个字符宽度
opt.shiftwidth = 2           -- 自动缩进和手动缩进（>>、<<）时使用2个字符
opt.softtabstop = -1         -- 设为-1时，使用 shiftwidth 的值，保持 Tab 行为一致性
opt.smarttab = true          -- 行首按Tab时插入 shiftwidth 个空格，其他位置按 tabstop
opt.autoindent = true        -- 新行自动继承上一行的缩进级别
opt.smartindent = true       -- 智能缩进，在 { 后自动增加缩进，在 } 前自动减少缩进
opt.shiftround = true        -- 使用 >> 或 << 时，缩进取整到 shiftwidth 的倍数

-- 行号和光标设置
opt.number = true            -- 显示绝对行号
opt.numberwidth = 4          -- 行号列的最小宽度为4字符
opt.cursorline = true        -- 高亮当前行，方便定位光标位置

-- 备份和临时文件设置
opt.backup = false           -- 不创建备份文件（filename~）
opt.swapfile = false         -- 不创建交换文件（.filename.swp），提高性能但丢失崩溃保护
opt.writebackup = false      -- 保存时不创建临时备份文件
opt.undofile = false         -- 不保存撤销历史到文件，重启后无法撤销之前的操作

-- 搜索设置
opt.smartcase = true         -- 智能大小写：搜索全小写时忽略大小写，包含大写时精确匹配
opt.hlsearch = true          -- 高亮显示所有搜索匹配项
opt.wrapscan = true          -- 搜索到文件末尾时从头开始继续搜索，形成循环
opt.incsearch = true         -- 增量搜索：输入搜索内容时实时显示匹配结果

-- 标签页和分屏设置
opt.showtabline = 2          -- 总是显示标签页栏（0=从不，1=多于1个标签页时，2=总是）
opt.splitbelow = true        -- 水平分屏时新窗口在下方
opt.splitright = true        -- 垂直分屏时新窗口在右侧

-- 系统交互设置
opt.updatetime = 100         -- CursorHold 事件触发间隔（毫秒），影响插件响应速度
opt.autoread = true          -- 文件在外部被修改时自动重新加载

-- 模式和命令显示
opt.showmode = false         -- 不显示当前模式（INSERT、VISUAL等），因为状态栏已显示
opt.report = 0               -- 所有操作都报告影响的行数（默认只有2+行才报告）

-- 搜索和路径增强
opt.magic = true             -- 启用正则表达式的魔术字符（.、*、[]等有特殊含义）
vim.opt.path:append('**')    -- 在当前目录及所有子目录中搜索文件（:find 命令使用）
opt.isfname:remove('=')      -- 从文件名字符集中移除 =，避免 filename=value 被识别为文件名

-- 光标和编辑行为
opt.virtualedit = 'onemore'  -- 允许光标移动到行尾字符的下一个位置
vim.opt.formatoptions:remove({'t', 'c'})  -- 不自动格式化文本（t）和注释（c）

-- 视图和会话设置
opt.viewoptions = 'folds,cursor,curdir,slash,unix'  -- 保存视图时包含：折叠、光标位置、当前目录、路径分隔符、Unix格式
opt.sessionoptions = 'curdir,help,tabpages,winsize'  -- 保存会话时包含：当前目录、帮助窗口、标签页、窗口大小

-- 剪贴板设置
opt.clipboard = 'unnamed,unnamedplus'  -- 与系统剪贴板同步（unnamed=*, unnamedplus=+）

-- 命令行补全设置
opt.wildmenu = true          -- 命令行补全时显示菜单
opt.wildignorecase = true    -- 文件名补全时忽略大小写
-- 忽略的文件类型（用于文件补全和某些插件）
opt.wildignore:append({
    '.git', '.hg', '.svn', '.stversions',  -- 版本控制目录
    '*.pyc', '*.spl', '*.o', '*.out', '*~', '%*',  -- 编译和临时文件
    '*.jpg', '*.jpeg', '*.png', '*.gif', '*.zip',  -- 二进制文件
    '**/tmp/**', '*.DS_Store',  -- 系统临时文件
    '**/node_modules/**', '**/bower_modules/**', '*/.sass-cache/*',  -- Node.js相关
    'application/vendor/**', '**/vendor/ckeditor/**', 'media/vendor/**',  -- PHP vendor
    '__pycache__', '*.egg-info', '.pytest_cache', '.mypy_cache/**'  -- Python相关
})
opt.wildcharm = 9            -- Tab字符的ASCII码，用于映射中触发补全

-- 历史和补全设置  
opt.history = 1000           -- 命令历史记录保存1000条
opt.ignorecase = true        -- 搜索时忽略大小写（配合smartcase使用）
opt.infercase = true         -- 补全时根据已输入内容推断大小写
opt.complete = '.,w,b,k'     -- 补全来源：当前缓冲区(.)、其他窗口(w)、其他缓冲区(b)、字典(k)

-- 文本显示和换行设置
opt.linebreak = true         -- 在单词边界换行，不会在单词中间断开
opt.breakat = ' \t!@*-+;:,./?' -- 可以断行的字符集合
opt.startofline = false      -- G、gg等命令不自动移到行首，保持列位置
opt.whichwrap:append('h,l,<,>,[,],~')  -- 这些键可以在行首/行尾时跨行移动

-- 缓冲区切换设置
opt.switchbuf = 'useopen,vsplit'  -- 切换到已打开的缓冲区时：使用已有窗口，否则垂直分屏
opt.backspace = 'indent,eol,start'  -- Backspace可以删除：缩进、换行符、插入模式开始前的字符

-- Diff模式设置
opt.diffopt:append('filler,iwhite')  -- diff时：显示填充行，忽略空白字符差异

-- 补全菜单设置
opt.completeopt = 'longest,noinsert,menuone,noselect,preview'  -- 补全行为：最长匹配、不自动插入、单项也显示菜单、不自动选择、显示预览

-- 界面元素设置
opt.ruler = false            -- 不显示光标位置信息（行列号），状态栏已有
vim.opt.shortmess:append('c')  -- 不显示补全相关的消息
opt.scrolloff = 3            -- 滚动时保持光标上下至少3行的上下文

-- 特殊字符显示
opt.list = true              -- 显示特殊字符（Tab、空格、换行等）
opt.listchars = {
    tab = '  ',              -- Tab字符不显示（两个空格，完全隐藏）
    nbsp = '+',              -- 不间断空格显示为 +
    trail = '·',             -- 行尾空格显示为 ·
    extends = '→',           -- 行内容超出屏幕时右侧显示 →
    precedes = '←'           -- 行内容超出屏幕时左侧显示 ←
}

-- 窗口标题设置
opt.title = true             -- 设置终端/GUI的窗口标题
opt.titlelen = 95            -- 标题最大长度95字符

-- 窗口边框和填充字符
vim.opt.fillchars:append('vert:|')  -- 垂直分割线使用 | 字符
opt.fillchars = 'eob: '      -- 缓冲区结束标记使用空格（隐藏~符号）

-- 括号匹配设置
vim.opt.matchpairs:append('<:>')  -- 添加 <> 为匹配的括号对
opt.matchtime = 1            -- 括号匹配高亮持续0.1秒

-- 窗口大小设置
opt.winwidth = 30            -- 当前窗口最小宽度30列
opt.winminwidth = 10         -- 非当前窗口最小宽度10列  
opt.winminheight = 1         -- 窗口最小高度1行

-- 弹出菜单设置
opt.pumheight = 15           -- 弹出菜单最多显示15项

-- 帮助和预览窗口高度
opt.helpheight = 12          -- 帮助窗口高度12行
opt.previewheight = 12       -- 预览窗口高度12行

-- 窗口平衡设置
opt.equalalways = false      -- 不自动调整窗口大小使其相等

-- 状态栏设置
opt.laststatus = 2           -- 总是显示状态栏（0=从不，1=多窗口时，2=总是）
opt.display = 'lastline'     -- 显示长行的最后一行而不是 @ 符号

-- 符号列设置
opt.signcolumn = 'yes'       -- 总是显示符号列（用于git标记、LSP诊断等）

-- 语法高亮性能设置
opt.synmaxcol = 2500         -- 超过2500列的行不进行语法高亮，提高性能