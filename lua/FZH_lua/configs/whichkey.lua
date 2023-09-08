-- :WhichKey " 显示所有的绑定
-- :WhichKey <leader> " 显示所有<leader>绑定
-- :WhichKey <leader> v " 显示所有v模式下的<leader>绑定
-- :WhichKey '' v " 显示所有v模式下的绑定
-- :checkhealth which_key

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	vim.notify("which-key not found!")
	return
end

local G = require('FZH_lua.G')

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = false, -- default bindings on <c-w>
			nav = false, -- misc bindings to work with windows
			z = false, -- bindings for folds, spelling and others prefixed with z
			g = false, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<C-j>", -- binding to scroll down inside the popup
		scroll_up = "<C-k>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true,
	show_keys = true,
	triggers = { "<auto>" }, -- automatically setup triggers
}

local n_opts = {
	mode = "n", -- NORMAL mode
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local n_mappings = {
	-- Leaderf 特有功能（lsp_base.lua 中没有的）
	["<Space>j"] = { name = "Lsp 操作" },
	["<Space>js"] = {"<cmd>execute printf('Leaderf gtags -s %s --top --auto-preview', expand('<cword>'))<cr>", "Leaderf symbol查询"},
	["<Space>jc"] = {"<cmd>execute printf('Leaderf mru %s --stayOpen --preview-position cursor --no-auto-preview', expand(''))<cr>", "Leaderf 最近文件"},
	["<Space>jl"] = {"<cmd>execute printf('Leaderf line %s --no-sort --stayOpen --preview-position cursor --no-auto-preview', expand(''))<cr>", "Leaderf 逐行"},
	["<Space>jz"] = {"<cmd>lua require('telescope.builtin').help_tags()<cr>", "nvim 帮助"},
	["<Space>jp"] = {"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "Lsp 路径显示"},

	-- telescope 查找和 git
	["<Space>g"] = { name = "telescope 查找内容和git" },
	["<Space>gg"] = {"<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "查找内容"},
	["<Space>gc"] = {"<cmd>lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<cr>", "当前光标查找内容:-g !*.c"},
	["<Space>gp"] = {"<cmd>GitGutterPrevHunk<CR>", "git 上个修改块"},
	["<Space>gn"] = {"<cmd>GitGutterNextHunk<CR>", "git 下个修改块"},
	["<Space>gh"] = {"<cmd>GitGutterLineHighlightsToggle<CR>", "git 高亮修改"},

	--代码注释
	["<Space>c"] = {"<Plug>kommentary_line_default", "代码注释"},

	-- 其他功能
	["h"] = {"<cmd>GitGutterPreviewHunk<CR>", "git 修改块显示"},
	["<C-r>"] = {"<cmd>lua require('undotree').toggle()<cr>", "undotree"},
}

local x_opts = {
	mode = "x", -- x mode
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local x_mappings = {
	--代码注释
	["<Space>c"] = {"<Plug>kommentary_visual_default", "代码注释"},
}

local leap_opts = {
	mode = { "x", "n", "o"}, -- x,n,o mode
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local leap_mappings = {
	--光标移动
	["F"] = {"<Plug>(leap-backward-to)", "Leap 向前查找"},
	["f"] = {"<Plug>(leap-forward-to)", "Leap 向后查找,s向前查找"},
	["<Space><Space>"] = {"<Plug>(leap-cross-window)", "Leap 全窗口跳转"},
}

which_key.setup(setup)
which_key.register(n_mappings, n_opts)
which_key.register(x_mappings, x_opts)
which_key.register(leap_mappings, leap_opts)
