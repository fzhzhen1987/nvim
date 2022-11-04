-- :TSInstallInfo 查看安装的解析器

local status_ok, nvim_treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	vim.notify("nvim_treesitter not found!")
	return
end

local setup = {
	highlight = {
		enable = true,
		disable = {},
	},
	ensure_installed = {
		"bash",
		"c",
		"diff",
		"dockerfile",
		"make",
		"markdown",
		"lua",
		"regex",
	},
	indent = {
		enable = false,
		disable = {},
	},
	incremental_selection = {
		enable = false,
	}
}

nvim_treesitter.setup(setup)
