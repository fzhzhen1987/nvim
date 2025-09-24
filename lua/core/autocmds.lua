-- core/autocmds.lua
-- Neovim 自动命令配置

local api = vim.api
local autocmd = api.nvim_create_autocmd

-- 记住上次文件位置 - 重新打开文件时自动跳转到上次编辑的位置
autocmd('BufReadPost', {
    pattern = '*',
    callback = function()
        local mark = api.nvim_buf_get_mark(0, '"')
        local line_count = api.nvim_buf_line_count(0)
        local ft = vim.bo.filetype

        -- 排除 commit 类型的文件（Git 提交消息等）
        if mark[1] > 0 and mark[1] <= line_count and ft ~= 'commit' then
            pcall(api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = '恢复上次编辑位置'
})