vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	vim.notify("nvim_tree not found!")
	return
end

local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- Default mappings
	api.config.mappings.default_on_attach(bufnr)

	local keys_to_remove = {
		"y", "o", "Y", "gy", "<C-r>", "D", "a", "R", "H", "I", "J", "K",
		"[c", "]c", "<BS>", "P", "<", ">", "<C-x>", "<C-v>", "s", "g?",
		"<2-RightMouse>", "<C-]>"
	}

	for _, key in ipairs(keys_to_remove) do
		vim.keymap.del('n', key, { buffer = bufnr })
	end

	-- Custom mappings
	vim.keymap.set('n', 'c',  api.fs.copy.node,          opts("Copy"))
	vim.keymap.set('n', 'x',  api.fs.cut,                opts("Cut"))
	vim.keymap.set('n', 'p',  api.fs.paste,              opts("Paste"))
	vim.keymap.set('n', 'n',  api.fs.create,             opts("Create"))
	vim.keymap.set('n', 'd',  api.fs.remove,             opts("Delete"))
	vim.keymap.set('n', 'r',  api.fs.rename,             opts("Rename"))
	vim.keymap.set('n', 'gn', api.fs.copy.filename,      opts("Copy Name"))
	vim.keymap.set('n', 'gp', api.fs.copy.absolute_path, opts("Copy Absolute Path"))
	vim.keymap.set('n', 'q',  api.tree.close,            opts("Close"))
	vim.keymap.set('n', '<Tab>', api.node.open.preview,  opts("Open Preview"))
	vim.keymap.set('n', 'e',  api.node.open.edit,        opts("Edit"))
	vim.keymap.set('n', '<C-e>', api.node.open.vertical, opts("Open: Vertical Split"))
	vim.keymap.set('n', '<C-b>', api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set('n', 'b', api.node.navigate.parent,   opts("Parent Directory"))
	vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set('n', '?', api.tree.toggle_help,       opts("Help"))
	vim.keymap.set('n', '<C-t>', api.node.open.tab,      opts("Open: New Tab"))
	vim.keymap.set('n', 'R', api.tree.reload,            opts("Refresh"))
end

nvim_tree.setup {
	on_attach           = my_on_attach,
	hijack_cursor       = true,
	update_cwd          = true,
	diagnostics = {
		enable            = true,
	},
	renderer = {
		icons = {
			symlink_arrow   = " >> ",
		},
		highlight_git     = true,
		group_empty       = true,
	},
	view = {
		width             = 30,
		side              = 'left',
		number            = true,
	},
	actions = {
		open_file = {
			quit_on_open    = true,
		},
	},
	filters = {
		dotfiles         = false,
	},
}

-- Key mapping outside of the tree
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", opts)

vim.cmd("hi NvimTreeFolderIcon guibg=blue")
