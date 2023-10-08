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
		additional_vim_regex_highlighting = false,
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
	auto_install = true,
	indent = {
		enable = false,
		disable = {},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
			scope_incremental = "<tab>",
			node_decremental = "<BS>",
		}
	},
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		colors = {
			"#FF00FF",
			"#F2F2F2",
			"#FF8C00",
			"#FFB3FF",
			"#00FFFF",
			"#FFD700",
			"#FF4500",
		}, -- table of hex strings
		termcolors = {
			"Red",
			"Green",
			"Yellow",
			"Blue",
			"Magenta",
			"Cyan",
			"White",
		}, -- table of colour name strings
	},
}

nvim_treesitter.setup(setup)
