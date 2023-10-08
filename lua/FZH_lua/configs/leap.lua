local status_ok, leap = pcall(require, "leap")
if not status_ok then
	vim.notify("leap not found!")
	return
end

leap.add_default_mappings()

-- 删除默认全窗口gs和默认查找s
vim.keymap.del({ "x", "o", "n" }, "gs")
vim.keymap.del({ "x", "o", "n" }, "s")

-- Disable auto jump first match

leap.opts.highlight_unlabeled_phase_one_targets = true

