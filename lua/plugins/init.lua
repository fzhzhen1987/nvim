-- plugins/init.lua
-- 插件系统主入口 - 加载所有插件分类

return {
    -- 导入所有插件分类
    { import = "plugins.editor" },    -- 编辑器增强
    { import = "plugins.ui" },        -- UI和主题
    { import = "plugins.coding" },    -- LSP和编程
    { import = "plugins.tools" },     -- 工具和搜索
    { import = "plugins.git" },       -- Git相关
    { import = "plugins.markdown" },  -- Markdown相关
}