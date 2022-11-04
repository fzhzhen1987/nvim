local tree_cb = require'nvim-tree.config'.nvim_tree_callback
-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	vim.notify("nvim_tree not found!")
	return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local setup = {
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	hijack_cursor       = true,
	update_cwd          = true,
	diagnostics = {
		enable = true,
	},
	renderer = {
		icons = {
			symlink_arrow = " >> ",
		},
		highlight_git = true,
	},
	view = {
		width = 30,
		hide_root_folder = false,
		side = 'left',
		mappings = {
			custom_only = false,
			list = {
				{ key = "c",                        cb = tree_cb("copy") },
				{ key = "x",                        cb = tree_cb("cut") },
				{ key = "p",                        cb = tree_cb("paste") },
				{ key = "n",                        cb = tree_cb("create") },
				{ key = "d",                        cb = tree_cb("remove") },
				
				{ key = "r",                        cb = tree_cb("full_rename") },
				{ key = "gn",                       cb = tree_cb("copy_name") },
				{ key = "gp",                       cb = tree_cb("copy_absolute_path") },
				
				{ key = "q",                        cb = tree_cb("close") },
				{ key = "<Tab>",                    cb = tree_cb("preview") },
				{ key = "e",                        cb = tree_cb("edit") },
				{ key = "<C-e>",                    cb = tree_cb("vsplit") },
				{ key = "<C-b>",                    cb = tree_cb("close_node") },
				{ key = "b",                        cb = tree_cb("parent_node") },
				{ key = "-",                        cb = tree_cb("dir_up") },
				{ key = "?",                        cb = tree_cb("toggle_help") },
				{ key = "<C-t>",                    cb = tree_cb("tabnew") },
				{ key = {"y","o","Y","gy","<C-r>","D","a","R","H","I","J","K","[c","]c","<BS>","P","<",">","<C-x>","<C-v>","s","g?","<2-RightMouse>","<C-]>"},    cb = tree_cb("refresh") },
			}
		},
	number = true,
	},
	trash = {
		cmd = "trash",
	}
}

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", opts)

vim.cmd("hi NvimTreeFolderIcon guibg=blue")

nvim_tree.setup(setup)
