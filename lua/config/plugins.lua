-- config/plugins.lua
-- 统一的插件配置文件 - 所有插件配置都在这里

local M = {}

-- ========================================
-- auto-pairs 配置
-- 来源：plug_list.vim line 76-84
-- ========================================
M.setup_autopairs = function()
    -- 禁用所有默认快捷键
    vim.g.AutoPairsShortcutJump = ''
    vim.g.AutoPairsShortcutBackInsert = ''
    vim.g.AutoPairsShortcutToggle = ''
    vim.g.AutoPairsShortcutFastWrap = ''

    -- 配置配对符号
    vim.g.AutoPairs = {
        ['('] = ')',
        ['['] = ']',
        ['{'] = '}',
        ["'"] = "'",
        ['"'] = '"'
    }
    vim.g.AutoPairs['<'] = '>'

    -- 其他设置
    vim.g.AutoPairsMapCh = 0
    vim.g.AutoPairsFlyMode = 0
    vim.g.AutoPairsMultilineClose = 0
end

-- ========================================
-- vim-bbye 配置
-- 来源：plug_list.vim line 95-96
-- ========================================
M.setup_bbye = function()
    -- 键位映射：Shift+Tab 关闭当前 buffer
    vim.keymap.set('n', '<S-Tab>', ':Bdelete<CR>', {
        silent = true,
        desc = '关闭当前buffer'
    })
end

-- ========================================
-- vim-highlighter 配置
-- 来源：plug_list.vim line 98-103
-- ========================================
M.setup_highlighter = function()
    -- 键位映射
    vim.g.HiSet = '<leader>m'      -- 高亮当前单词
    vim.g.HiErase = '<leader>me'   -- 删除高亮
    vim.g.HiClear = '<leader>M'    -- 清除所有高亮
    vim.g.HiFind = 'f<Tab>'        -- 查找高亮的单词
    vim.g.HiSetSL = 't<CR>'        -- 设置

    -- 启用分屏同步模式
    vim.g.HiSyncMode = 1
end

-- ========================================
-- vim_current_word 配置
-- 来源：plug_list.vim line 108-112
-- ========================================
M.setup_current_word = function()
    -- 高亮相同单词
    vim.g.vim_current_word_highlight_twins = 1
    -- 高亮当前单词
    vim.g.vim_current_word_highlight_current_word = 1
    -- 在所有窗口显示高亮，不限于当前窗口
    vim.g.vim_current_word_highlight_only_in_focused_window = 0
end

-- ========================================
-- vim-gitgutter 配置
-- 来源：plug_list.vim line 344-352
-- ========================================
M.setup_gitgutter = function()
    -- 不允许覆盖其他插件的标记
    vim.g.gitgutter_sign_allow_clobber = 0

    -- 禁用默认键位映射
    vim.g.gitgutter_map_keys = 0

    -- 不覆盖符号列高亮
    vim.g.gitgutter_override_sign_column_highlight = 0

    -- 使用浮动窗口显示预览
    vim.g.gitgutter_preview_win_floating = 1

    -- 自定义 git 状态符号
    vim.g.gitgutter_sign_added = '▎'              -- 新增行
    vim.g.gitgutter_sign_modified = '░'           -- 修改行
    vim.g.gitgutter_sign_removed = '▏'            -- 删除行
    vim.g.gitgutter_sign_removed_first_line = '▔' -- 删除首行
    vim.g.gitgutter_sign_modified_removed = '▒'   -- 修改并删除

    -- 在 diff 预览窗口中按 q 或 h 关闭
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "diff",
        callback = function()
            vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, silent = true })
            vim.keymap.set('n', 'h', '<cmd>close<cr>', { buffer = true, silent = true })
        end
    })
end

-- ========================================
-- vim-indent-guides 配置
-- 来源：plug_list.vim line 282-291
-- ========================================
-- 已替换为 indent-blankline.nvim，此配置已弃用
--[[
M.setup_indent_guides = function()
    -- 禁用默认键位映射
    vim.g.indent_guides_default_mapping = 0
    vim.keymap.set('n', '<nop>', '<Plug>IndentGuidesToggle', { silent = true })

    -- 启动时自动开启
    vim.g.indent_guides_enable_on_vim_startup = 1

    -- 禁用自动颜色
    vim.g.indent_guides_auto_colors = 0

    -- 设置缩进线颜色（需要在主题加载后设置）
    vim.api.nvim_create_autocmd({"VimEnter", "Colorscheme"}, {
        pattern = "*",
        callback = function()
            vim.cmd("hi IndentGuidesOdd guibg=green ctermbg=3")
            vim.cmd("hi IndentGuidesEven guibg=purple ctermbg=4")
        end
    })

    -- 颜色变化百分比
    vim.g.indent_guides_color_change_percent = 5

    -- 从第2级开始显示
    vim.g.indent_guide_start_level = 2

    -- 缩进线宽度
    vim.g.indent_guides_guide_size = 1

    -- 不显示空格缩进线
    vim.g.indent_guides_space_guides = 0
end
--]]

-- ========================================
-- vim-visual-multi 配置
-- 来源：plug_list.vim line 294-306
-- ========================================
M.setup_visual_multi = function()
    -- vim-visual-multi 的键位配置必须在插件加载前设置
    -- 使用 Lua 表格式
    vim.g.VM_maps = {
        ['Find Under'] = '<C-k>',          -- 查找光标下的单词并添加光标
        ['Find Subword Under'] = '<C-k>',  -- 查找子词
        ['Goto Next'] = '<C-n>',           -- 跳转到下一个光标
        ['Goto Prev'] = '<C-p>',           -- 跳转到上一个光标
        ['Find Next'] = '',                -- 禁用查找下一个
        ['Find Prev'] = '',                -- 禁用查找上一个
        ['Seek Next'] = '',                -- 禁用 Seek
        ['Seek Prev'] = '',                -- 禁用 Seek
        ['Remove Region'] = 'q',           -- 移除当前光标
        ['Skip Region'] = '',              -- 禁用跳过区域
        ['Undo'] = 'u',                    -- 撤销
        ['Redo'] = '<C-r>',                -- 重做
    }
end

-- ========================================
-- vim-lsp-cxx-highlight 配置
-- 来源：plug_list.vim line 355-358
-- ========================================
M.setup_lsp_cxx_highlight = function()
    -- 使用 text properties 进行高亮（性能更好）
    vim.g.lsp_cxx_hl_use_text_props = 1

    -- 语法高亮优先级（确保 LSP 高亮覆盖默认语法高亮）
    vim.g.lsp_cxx_hl_syntax_priority = 100
end

-- ========================================
-- vim-gutentags 配置
-- 来源：plug_list.vim line 275-296
-- ========================================
M.setup_gutentags = function()
    -- 启用高级命令
    vim.g.gutentags_define_advanced_commands = 1

    -- 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
    vim.g.gutentags_project_root = {'.stop_gun', '.root', '.svn', '.git', '.hg', '.project'}

    -- 同时开启 ctags 和 gtags 支持
    vim.g.gutentags_modules = {}
    if vim.fn.executable('gtags-cscope') == 1 and vim.fn.executable('gtags') == 1 then
        vim.g.gutentags_modules = {'gtags_cscope'}
    end

    -- 检测 ~/.cache/tags 不存在就新建
    -- 将自动生成的tags文件全部放入~/.cache/tags 目录中，避免污染工程目录
    local vim_tags = vim.fn.expand('~/.cache/tags')
    vim.g.Lf_CacheDirectory = vim_tags
    vim.g.gutentags_cache_dir = vim.fn.expand(vim.g.Lf_CacheDirectory .. '/LeaderF/gtags')

    if vim.fn.isdirectory(vim_tags) == 0 then
        vim.fn.mkdir(vim_tags, 'p')
    end

    -- 禁用gutentags自动加载gtags数据库的行为
    vim.g.gutentags_auto_add_gtags_cscope = 0
end

-- ========================================
-- LeaderF 配置
-- 来源：plug_list.vim line 298-366
-- ========================================
M.setup_leaderf = function()
    -- 基础设置
    vim.g.Lf_HideHelp = 1                        -- 不显示帮助信息
    vim.g.Lf_UseCache = 0                        -- 不使用缓存
    vim.g.Lf_UseVersionControlTool = 0           -- 不使用版本控制工具
    vim.g.Lf_IgnoreCurrentBufferName = 1         -- 忽略当前缓冲区名称

    -- Gtags 设置
    vim.g.Lf_GtagsAutoGenerate = 0               -- 不自动生成 gtags
    vim.g.Lf_GtagsGutentags = 1                  -- 使用 gutentags 管理 gtags
    vim.g.Lf_RootMarkers = {'.stop_gun', '.root', '.svn', '.git', '.hg', '.project'}

    -- 窗口和预览设置
    vim.g.Lf_WindowPosition = 'right'            -- 窗口位置：右侧
    vim.g.Lf_PreviewInPopup = 1                  -- 在弹出窗口中预览
    vim.g.Lf_PreviewHorizontalPosition = 'right' -- 预览窗口水平位置
    vim.g.Lf_JumpToExistingWindow = 0            -- 不跳转到已存在的窗口
    vim.g.Lf_PopupWidth = 0.8                    -- 弹窗宽度 80%
    vim.g.Lf_PopupHeight = 0.6                   -- 弹窗高度 60%
    vim.g.Lf_PreviewCode = 1                     -- 预览代码
    vim.g.Lf_StlSeparator = {
        left = '',
        right = '',
        font = 'DejaVu Sans Mono for Powerline'
    }
    vim.g.Lf_PreviewResult = {
        Function = 0,
        BufTag = 0
    }

    -- 默认搜索模式
    vim.g.Lf_DefaultMode = 'Regex'

    -- 键位映射
    -- Alt+. : 查找光标下单词的定义
    vim.keymap.set('n', '<A-.>', ':<C-U><C-R>=printf("Leaderf gtags -d %s --top --auto-preview", expand("<cword>"))<CR><CR>',
        { silent = true, desc = '查找定义' })

    -- Alt+, : 查找光标下单词的引用
    vim.keymap.set('n', '<A-,>', ':<C-U><C-R>=printf("Leaderf gtags -r %s --top --auto-preview", expand("<cword>"))<CR><CR>',
        { silent = true, desc = '查找引用' })

    -- Alt+p : 召回上次的 gtags 搜索
    vim.keymap.set('n', '<A-p>', ':<C-U><C-R>=printf("Leaderf gtags --recall %s --top --auto-preview", "")<CR><CR>',
        { silent = true, desc = '召回搜索' })

    -- Alt+/ : 在当前缓冲区搜索光标下的单词
    vim.keymap.set('n', '<A-/>', ':<C-U><C-R>=printf("Leaderf rg --current-buffer -F -e %s --no-sort --no-auto-preview --preview-position cursor", expand("<cword>"))<CR><CR>',
        { silent = true, desc = '缓冲区搜索' })

    -- 修改键位映射
    vim.g.Lf_CommandMap = {
        ['<C-P>'] = {'<C-R>'},
        ['<C-K>'] = {'<C-P>'},
        ['<C-J>'] = {'<C-N>'},
        ['<ESC>'] = {'<C-Q>', '<ESC>'},
        ['<C-UP>'] = {'<C-K>'},
        ['<C-DOWN>'] = {'<C-J>'},
        ['<C-X>'] = {'<C-O>'},
        ['<C-]>'] = {'<C-E>'},
        ['<Home>'] = {'<C-A>'},
        ['<Right>'] = {'<C-F>'},
        ['<Left>'] = {'<C-B>'},
    }

    -- 禁用默认快捷键
    vim.g.Lf_ShortcutF = '<nop>'
    vim.g.Lf_ShortcutB = '<nop>'
end

-- ========================================
-- 主题配置
-- 来源：theme.vim - 使用 hybrid_reverse
-- ========================================
M.setup_theme = function()
    -- 主题设置（来自 theme.vim line 4-7）
    vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = '1'
    vim.o.background = 'dark'
    vim.o.termguicolors = true
    vim.g.space_vim_italic = 1
    vim.g.enable_bold_font = 1
    vim.g.enable_italic_font = 1
    vim.o.t_ut = ''

    -- 应用主题
    local ok = pcall(vim.cmd, "colorscheme hybrid_reverse")
    if not ok then
        vim.notify("hybrid_reverse 主题加载失败，使用默认主题", vim.log.levels.WARN)
    end
end

-- ========================================
-- nvim-bqf + quickfix 配置
-- 来源：configs/nvimbqf.lua + configs/quickfix.lua
-- ========================================
M.setup_nvimbqf = function()
    local status_ok, nvim_bqf = pcall(require, "bqf")
    if not status_ok then
        vim.notify("nvim_bqf not found!")
        return
    end

    -- nvim-bqf 插件配置
    local setup = {
        auto_enable = true,
        magic_window = false,
        auto_resize_height = true, -- highly recommended enable
        preview = {
            win_height = 20,
            win_vheight = 20,
            delay_syntax = 80,
            border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
            show_title = false,
            should_preview_cb = function(bufnr, qwinid)
                local ret = true
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                local fsize = vim.fn.getfsize(bufname)
                if fsize > 100 * 1024 then
                    -- skip file size greater than 100k
                    ret = false
                elseif bufname:match('^fugitive://') then
                    -- skip fugitive buffer
                    ret = false
                end
                return ret
            end
        },
        -- make `drop` and `tab drop` to become preferred
        func_map = {
            prevfile = '',
            nextfile = '',
            pscrollup = '<C-k>',
            pscrolldown = '<C-j>',
            fzffilter = 'f',
            drop = 'o',
            openc = 'O',
            vsplit = '<C-e>',
            tabdrop = '<C-t>',
            tabc = '',
            ptogglemode = 'z,',
        },
        filter = {
            fzf = {
                action_for = {['ctrl-e'] = 'vsplit', ['ctrl-t'] = 'tab drop', ['ctrl-c'] = '', ['ctrl-q'] = 'closeall'},
                extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
            }
        }
    }

    nvim_bqf.setup(setup)

    -- quickfix 键位映射
    -- 智能切换 quickfix 窗口
    local function toggle_quickfix()
        local qf_exists = false
        for _, win in pairs(vim.fn.getwininfo()) do
            if win["quickfix"] == 1 then
                qf_exists = true
                break
            end
        end
        if qf_exists then
            vim.cmd("cclose")
        else
            vim.cmd("copen")
        end
    end

    -- 设置快捷键
    vim.keymap.set("n", "<Space>q", toggle_quickfix, {
        desc = "📋 切换 Quickfix 窗口",
        noremap = true,
        silent = true
    })

    -- quickfix 导航快捷键
    vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "上一个 quickfix 项" })
    vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "下一个 quickfix 项" })
end

-- ========================================
-- undotree 配置已移到 plugins/editor.lua
-- 使用 mbbill/undotree（经典稳定版本），配置在插件定义处
-- ========================================

-- ========================================
-- Comment.nvim 配置（替换 kommentary）
-- 来源：configs/whichkey.lua line 95, 122
-- 保持原有的 <Space>c 键位习惯
-- ========================================
M.setup_comment = function()
    local status_ok, comment = pcall(require, "Comment")
    if not status_ok then
        vim.notify("Comment.nvim not found!")
        return
    end

    comment.setup({
        -- 基础设置
        padding = true,   -- 注释符号和代码之间添加空格
        sticky = true,    -- 保持光标位置
        ignore = nil,     -- 忽略空行

        -- 禁用默认键位映射，使用自定义的 <Space>c
        mappings = {
            basic = false,   -- 禁用 gcc, gbc
            extra = false,   -- 禁用 gcO, gco, gcA
        },
    })

    -- 自定义键位映射：保持你的 <Space>c 习惯
    local api = require("Comment.api")

    -- Normal 模式：<Space>c 注释当前行
    vim.keymap.set("n", "<Space>c", function()
        api.toggle.linewise.current()
    end, { desc = "💬 代码注释切换", noremap = true, silent = true })

    -- Visual 模式：<Space>c 注释选中的行
    vim.keymap.set("x", "<Space>c", function()
        local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'nx', false)
        api.toggle.linewise(vim.fn.visualmode())
    end, { desc = "💬 可视模式代码注释", noremap = true, silent = true })
end

-- ========================================
-- nvim-treesitter 配置
-- 来源：configs/nvim-treesitter.lua
-- ========================================
M.setup_treesitter = function()
    local status_ok, nvim_treesitter = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
        vim.notify("nvim_treesitter not found!")
        return
    end

    nvim_treesitter.setup({
        -- 语法高亮
        highlight = {
            enable = true,
            disable = {},  -- 禁用特定语言的高亮（如果有问题）
            additional_vim_regex_highlighting = false,  -- 禁用 vim 正则高亮（提升性能）
        },

        -- 自动安装的语言解析器
        ensure_installed = {
            "bash",
            "c",
            "cpp",         -- C++
            "rust",        -- Rust（支持 Linux 内核开发）
            "diff",
            "dockerfile",
            "make",
            "markdown",
            "lua",
            "regex",
        },

        -- 自动安装缺失的解析器
        auto_install = true,

        -- 智能缩进（关闭，因为有时不准确）
        indent = {
            enable = false,
            disable = {},
        },

        -- 增量选择（按 Enter 扩大选择范围）
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",      -- 初始化选择
                node_incremental = "<CR>",    -- 增量扩大选择
                scope_incremental = "<tab>",  -- 扩大到作用域
                node_decremental = "<BS>",    -- 减小选择
            }
        },
    })

    -- ========================================
    -- 彩虹括号配置（使用 rainbow-delimiters.nvim）
    -- 来源：configs/nvim-treesitter.lua line 39-62
    -- ========================================
    local rainbow_status_ok, rainbow = pcall(require, "rainbow-delimiters")
    if not rainbow_status_ok then
        vim.notify("rainbow-delimiters not found!")
        return
    end

    -- 配置彩虹括号
    vim.g.rainbow_delimiters = {
        strategy = {
            [''] = rainbow.strategy['global'],  -- 全局策略
            vim = rainbow.strategy['local'],    -- vim 文件使用局部策略
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
        },
        highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
        },
    }

    -- 设置彩虹括号的颜色（和原配置一致）
    vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = '#FF00FF' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = '#FFD700' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#00FFFF' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = '#FF8C00' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = '#F2F2F2' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = '#FFB3FF' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = '#FF4500' })
end

-- ========================================
-- nvim-surround 配置
-- 来源：plugins_new.lua line 105-126 + whichkey.lua line 121-167
-- ========================================
M.setup_surround = function()
	local status_ok, nvim_surround = pcall(require, "nvim-surround")
	if not status_ok then
		vim.notify("nvim-surround not found!")
		return
	end

	-- 禁用所有默认键位，使用 which-key 中定义的 <Space>t 系列键位
	nvim_surround.setup({
		keymaps = {
			insert = false,            -- 插入模式：触发 add
			insert_line = false,       -- 插入模式（新行）
			normal = false,            -- 普通模式：标准 add
			normal_cur = false,        -- 普通模式：在当前行 add
			normal_line = false,       -- 普通模式：在行上 add
			normal_cur_line = false,   -- 普通模式：在当前行并换行 add
			visual = false,            -- 可视模式：环绕选中区域
			visual_line = false,       -- 可视行模式：在新行环绕选中
			delete = false,            -- 删除 surround
			change = false,            -- 改变 surround
			change_line = false,       -- 在新行改变 surround
		},
	})
end

return M