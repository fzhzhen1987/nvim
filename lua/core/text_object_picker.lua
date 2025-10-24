-- core/text_object_picker.lua
-- 为 nvim-surround 提供文本对象选择弹窗

local M = {}

-- 所有可用的文本对象及其说明
local text_objects = {
    -- 单词和句子
    { key = "iw", desc = "单词内" },
    { key = "aw", desc = "单词(含空格)" },
    { key = "is", desc = "句子内" },
    { key = "as", desc = "句子(含空格)" },

    -- 段落
    { key = "ip", desc = "段落内" },
    { key = "ap", desc = "段落(含空行)" },

    -- 括号
    { key = "i(", desc = "圆括号内" },
    { key = "a(", desc = "圆括号(含括号)" },
    { key = "i[", desc = "方括号内" },
    { key = "a[", desc = "方括号(含括号)" },
    { key = "i{", desc = "花括号内" },
    { key = "a{", desc = "花括号(含括号)" },
    { key = "i<", desc = "尖括号内" },
    { key = "a<", desc = "尖括号(含括号)" },

    -- 引号
    { key = "i\"", desc = "双引号内" },
    { key = "a\"", desc = "双引号(含引号)" },
    { key = "i'", desc = "单引号内" },
    { key = "a'", desc = "单引号(含引号)" },
    { key = "i`", desc = "反引号内" },
    { key = "a`", desc = "反引号(含引号)" },

    -- 标签
    { key = "it", desc = "标签内" },
    { key = "at", desc = "标签(含标签)" },
}

-- 创建选择弹窗
function M.show_picker(callback)
    -- 创建浮动窗口的内容
    local lines = { "选择文本对象 (输入数字或直接按键):", "" }
    for i, obj in ipairs(text_objects) do
        table.insert(lines, string.format("%2d. %-4s  %s", i, obj.key, obj.desc))
    end

    -- 计算窗口大小
    local width = 50
    local height = #lines
    local bufnr = vim.api.nvim_create_buf(false, true)

    -- 设置缓冲区内容
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    -- 设置缓冲区选项
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
    vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')

    -- 计算窗口位置（居中）
    local ui = vim.api.nvim_list_uis()[1]
    local win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (ui.width - width) / 2,
        row = (ui.height - height) / 2,
        style = 'minimal',
        border = 'rounded',
        title = ' 文本对象选择器 ',
        title_pos = 'center',
    }

    -- 创建浮动窗口
    local winnr = vim.api.nvim_open_win(bufnr, true, win_opts)

    -- 设置窗口高亮
    vim.api.nvim_win_set_option(winnr, 'winhl', 'Normal:Normal,FloatBorder:FloatBorder')

    -- 设置语法高亮
    vim.cmd([[syntax match TextObjectKey /\v^\s*\d+\.\s+\zs\S+/]])
    vim.cmd([[syntax match TextObjectDesc /\v\(.{-}\)/]])
    vim.cmd([[hi link TextObjectKey Keyword]])
    vim.cmd([[hi link TextObjectDesc Comment]])

    -- 键盘映射
    local function close_and_select(text_obj)
        vim.api.nvim_win_close(winnr, true)
        if callback then
            callback(text_obj)
        end
    end

    -- 数字输入缓冲区
    local input_buffer = ""

    -- 数字键处理 (0-9)
    for digit = 0, 9 do
        local key = tostring(digit)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', key, '', {
            callback = function()
                input_buffer = input_buffer .. key
                local num = tonumber(input_buffer)

                -- 如果是两位数，立即执行
                if #input_buffer == 2 then
                    if num >= 1 and num <= #text_objects then
                        close_and_select(text_objects[num].key)
                    else
                        -- 无效的数字，清空缓冲区
                        input_buffer = ""
                        vim.notify("无效的选项: " .. num, vim.log.levels.WARN)
                    end
                end
                -- 单位数等待回车或继续输入
            end,
            noremap = true,
            silent = true,
        })
    end

    -- 回车键：确认单位数选择
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', '', {
        callback = function()
            if input_buffer ~= "" then
                local num = tonumber(input_buffer)
                if num >= 1 and num <= #text_objects then
                    close_and_select(text_objects[num].key)
                else
                    input_buffer = ""
                    vim.notify("无效的选项: " .. num, vim.log.levels.WARN)
                end
            end
        end,
        noremap = true,
        silent = true,
    })

    -- 直接按文本对象的键
    for _, obj in ipairs(text_objects) do
        -- 对于特殊字符，需要转义
        local key = obj.key
        vim.api.nvim_buf_set_keymap(bufnr, 'n', key, '', {
            callback = function()
                close_and_select(key)
            end,
            noremap = true,
            silent = true,
        })
    end

    -- ESC 和 q 关闭窗口
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<ESC>', '', {
        callback = function()
            vim.api.nvim_win_close(winnr, true)
        end,
        noremap = true,
        silent = true,
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
        callback = function()
            vim.api.nvim_win_close(winnr, true)
        end,
        noremap = true,
        silent = true,
    })
end

-- 包装 surround 添加功能，显示选择器
function M.surround_with_picker()
    M.show_picker(function(text_obj)
        -- 模拟输入文本对象
        vim.api.nvim_feedkeys(text_obj, 'n', false)
    end)
end

return M
