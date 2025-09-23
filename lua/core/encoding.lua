-- core/encoding.lua
-- 文件编码处理模块，支持日语文件自动识别并保持原编码

local M = {}

-- ========================================
-- 基础编码设置
-- ========================================
local function setup_basic_encoding()
    -- 内部编码（Neovim 内部使用的编码）
    vim.opt.encoding = 'utf-8'
    -- 新文件的默认编码
    vim.opt.fileencoding = 'utf-8'
    -- 文件编码检测顺序（UTF-8 优先，避免误判）
    vim.opt.fileencodings = 'ucs-bom,utf-8,sjis,cp932,euc-jp,iso-2022-jp,gbk,gb2312,gb18030,big5,latin1'
    -- 终端编码
    vim.opt.termencoding = 'utf-8'
    -- 不使用 BOM（字节顺序标记）
    vim.opt.bomb = false
end

-- ========================================
-- 编码保持机制 - 核心功能
-- ========================================
local function setup_encoding_preservation()
    -- 文件读取后，记录原始编码
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("EncodingPreservation", { clear = true }),
        callback = function()
            local original_encoding = vim.bo.fileencoding
            if original_encoding and original_encoding ~= "" then
                -- 保存到 buffer 变量中
                vim.b.original_fileencoding = original_encoding
                vim.b.encoding_preserved = true

                -- 如果不是 UTF-8，在状态栏显示提示
                if original_encoding ~= 'utf-8' then
                    vim.b.encoding_warning = '⚠ ' .. string.upper(original_encoding)
                end
            else
                -- 如果检测不到编码，默认为 UTF-8
                vim.b.original_fileencoding = 'utf-8'
                vim.b.encoding_preserved = false
            end
        end
    })

    -- 保存前，恢复原始编码
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("EncodingRestore", { clear = true }),
        callback = function()
            -- 如果有原始编码记录且用户没有手动更改编码意图
            if vim.b.original_fileencoding and vim.b.encoding_preserved then
                local current_encoding = vim.bo.fileencoding

                -- 恢复原始编码
                vim.bo.fileencoding = vim.b.original_fileencoding

                -- 如果编码发生了变化，给用户提示
                if current_encoding ~= vim.b.original_fileencoding then
                    vim.notify(
                        string.format("保持原始编码: %s (避免编码改变)", vim.b.original_fileencoding),
                        vim.log.levels.INFO
                    )
                end
            end
        end
    })
end

-- ========================================
-- 乱码检测和自动修复
-- ========================================
local function check_for_garbled_text()
    -- 只检查特定文件类型
    local ft = vim.bo.filetype
    local valid_filetypes = { 'c', 'cpp', 'text', 'log', 'conf', '' }

    local is_valid_type = false
    for _, valid_ft in ipairs(valid_filetypes) do
        if ft == valid_ft then
            is_valid_type = true
            break
        end
    end

    if not is_valid_type then
        return
    end

    -- 只在非 UTF-8 编码时检查
    local current_encoding = vim.bo.fileencoding
    if current_encoding == 'utf-8' or current_encoding == '' then
        return
    end

    -- 检查前20行是否有乱码特征
    local total_lines = vim.api.nvim_buf_line_count(0)
    local check_lines = math.min(total_lines, 20)
    local lines = vim.api.nvim_buf_get_lines(0, 0, check_lines, false)

    local garbled_patterns = 0

    for _, line in ipairs(lines) do
        -- 检查常见的乱码模式
        if string.match(line, '[�？]') or string.match(line, '[\128-\255]\128-\255]\128-\255]') then
            garbled_patterns = garbled_patterns + 1
        end

        -- 检查是否包含日语半角假名但编码不对
        if string.match(line, '[ｱ-ﾝ]') and current_encoding ~= 'sjis' and current_encoding ~= 'cp932' then
            garbled_patterns = garbled_patterns + 1
        end
    end

    -- 如果发现乱码模式，延迟提示用户
    if garbled_patterns >= 2 then
        vim.defer_fn(function()
            vim.notify(
                string.format(
                    "检测到可能的编码问题。当前编码: %s\n" ..
                    "尝试: :SJ (Shift_JIS) 或 :UTF8 (UTF-8) 或 :FileEncodingInfo 查看详情",
                    current_encoding
                ),
                vim.log.levels.WARN
            )
        end, 100)
    end
end

-- ========================================
-- 用户命令
-- ========================================
local function setup_commands()
    -- SJ 命令：用 Shift_JIS 重新打开当前文件
    vim.api.nvim_create_user_command('SJ', function()
        local filepath = vim.fn.expand('%:p')
        if filepath == '' then
            vim.notify("没有打开的文件", vim.log.levels.ERROR)
            return
        end

        local original_fenc = vim.bo.fileencoding
        vim.cmd('bdelete!')
        vim.cmd('edit ++enc=sjis ' .. vim.fn.fnameescape(filepath))

        -- 标记为手动更改编码，不再自动保持原编码
        vim.b.encoding_preserved = false
        vim.b.original_fileencoding = 'sjis'

        vim.notify(string.format("已用 Shift_JIS 编码重新打开 (原编码: %s)", original_fenc))
    end, { desc = "用 Shift_JIS 重新打开文件" })

    -- UTF8 命令：用 UTF-8 重新打开当前文件
    vim.api.nvim_create_user_command('UTF8', function()
        local filepath = vim.fn.expand('%:p')
        if filepath == '' then
            vim.notify("没有打开的文件", vim.log.levels.ERROR)
            return
        end

        local original_fenc = vim.bo.fileencoding
        vim.cmd('bdelete!')
        vim.cmd('edit ++enc=utf-8 ' .. vim.fn.fnameescape(filepath))

        -- 标记为手动更改编码
        vim.b.encoding_preserved = false
        vim.b.original_fileencoding = 'utf-8'

        vim.notify(string.format("已用 UTF-8 编码重新打开 (原编码: %s)", original_fenc))
    end, { desc = "用 UTF-8 重新打开文件" })

    -- ConvertToUTF8 命令：将当前文件转换为 UTF-8 并保存
    vim.api.nvim_create_user_command('ConvertToUTF8', function()
        local original_fenc = vim.bo.fileencoding
        vim.bo.fileencoding = 'utf-8'
        vim.b.original_fileencoding = 'utf-8'
        vim.b.encoding_preserved = false
        vim.b.encoding_warning = nil

        vim.notify(string.format("文件编码已设置为 UTF-8 (原编码: %s)", original_fenc))
    end, { desc = "将文件编码转换为 UTF-8" })

    -- SaveAsEncoding 命令：以指定编码保存文件
    vim.api.nvim_create_user_command('SaveAsEncoding', function(opts)
        local encoding = opts.args
        if encoding == '' then
            vim.notify("用法: :SaveAsEncoding <编码> (如 utf-8, sjis, cp932)", vim.log.levels.ERROR)
            return
        end

        vim.bo.fileencoding = encoding
        vim.b.original_fileencoding = encoding
        vim.b.encoding_preserved = false

        vim.cmd('write')
        vim.notify(string.format("已保存为 %s 编码", encoding))
    end, { 
        nargs = 1, 
        desc = "以指定编码保存文件",
        complete = function()
            return { 'utf-8', 'sjis', 'cp932', 'euc-jp', 'iso-2022-jp' }
        end
    })

    -- FileEncodingInfo 命令：显示文件编码信息
    vim.api.nvim_create_user_command('FileEncodingInfo', function()
        local info = {
            "=== 文件编码信息 ===",
            "encoding (内部编码): " .. vim.o.encoding,
            "fileencoding (文件编码): " .. vim.bo.fileencoding,
            "fileencodings (检测顺序): " .. vim.o.fileencodings,
            "fileformat (文件格式): " .. vim.bo.fileformat,
            "bomb (BOM标记): " .. tostring(vim.bo.bomb),
            "",
            "原始编码: " .. (vim.b.original_fileencoding or "未知"),
            "编码保持: " .. (vim.b.encoding_preserved and "是" or "否"),
            "",
            "提示: :SJ (Shift_JIS) | :UTF8 (UTF-8) | :ConvertToUTF8 | :SaveAsEncoding <编码>"
        }

        -- 在浮动窗口中显示
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, info)

        local width = 70
        local height = #info + 2
        local win = vim.api.nvim_open_win(buf, false, {
            relative = 'cursor',
            width = width,
            height = height,
            row = 1,
            col = 0,
            border = 'rounded',
            style = 'minimal'
        })

        -- 3秒后自动关闭
        vim.defer_fn(function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end, 3000)
    end, { desc = "显示文件编码信息" })

    -- 十六进制查看命令
    vim.api.nvim_create_user_command('HexView', function()
        vim.cmd('%!xxd')
    end, { desc = "以十六进制查看文件" })

    vim.api.nvim_create_user_command('HexRevert', function()
        vim.cmd('%!xxd -r')
    end, { desc = "从十六进制恢复文件" })
end

-- ========================================
-- 状态栏编码显示函数
-- ========================================
function M.get_file_encoding()
    local enc = vim.bo.fileencoding
    if enc == '' then
        enc = vim.o.encoding
    end

    -- 如果有编码警告，显示警告标记
    if vim.b.encoding_warning then
        return vim.b.encoding_warning
    end

    -- 如果不是 UTF-8，添加警告标记
    if enc ~= 'utf-8' and enc ~= '' then
        return '⚠ ' .. string.upper(enc)
    end

    return string.upper(enc)
end

-- ========================================
-- 自动命令设置
-- ========================================
local function setup_autocmds()
    -- 乱码检测
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("JapaneseFileDetection", { clear = true }),
        pattern = { "*.c", "*.h", "*.cpp", "*.txt", "*.log", "*.conf" },
        callback = check_for_garbled_text
    })

    -- 保存前编码确认（仅新文件）
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("EncodingConfirmation", { clear = true }),
        callback = function()
            local current_encoding = vim.bo.fileencoding
            local filepath = vim.fn.expand('%:p')

            -- 如果是新文件且编码不是 UTF-8
            if current_encoding ~= 'utf-8' and current_encoding ~= '' and not vim.fn.filereadable(filepath) then
                local choice = vim.fn.confirm(
                    string.format("新文件将以 %s 编码保存，是否继续？", current_encoding),
                    "&Yes\n&No\n&UTF-8",
                    3
                )

                if choice == 2 then
                    -- 取消保存
                    error("Save cancelled")
                elseif choice == 3 then
                    -- 改为 UTF-8
                    vim.bo.fileencoding = 'utf-8'
                    vim.b.original_fileencoding = 'utf-8'
                    vim.b.encoding_preserved = false
                    vim.notify("已改为 UTF-8 编码")
                end
            end
        end
    })
end

-- ========================================
-- 初始化函数
-- ========================================
function M.setup()
    setup_basic_encoding()
    setup_encoding_preservation()
    setup_commands()
    setup_autocmds()

    vim.notify("编码处理模块已加载 - 支持日语文件自动识别并保持原编码", vim.log.levels.INFO)
end

-- 自动初始化
M.setup()

return M
