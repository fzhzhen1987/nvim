-- core/text_selection.lua
-- txt 文件中使用回车快速选择内容

-- 只在 txt 和 markdown 文件中启用
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"text", "txt", "markdown", "md"},
    callback = function()
        -- 回车键：选中当前行（进入 Visual Line 模式）
        vim.keymap.set('n', '<CR>', 'V', {
            buffer = true,
            silent = true,
            desc = "选中当前行"
        })
    end,
})