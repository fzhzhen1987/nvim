local M = {}

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

-- 可以添加更多 quickfix 相关的功能
-- 例如：导航快捷键
vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "上一个 quickfix 项" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "下一个 quickfix 项" })

return M
