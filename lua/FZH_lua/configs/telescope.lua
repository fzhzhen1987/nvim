-- NOTE: install ripgrep for live_grep picker

-- ====for live_grep raw====:
-- for rp usage: reference: https://segmentfault.com/a/1190000016170184
-- -i ignore case
-- -s 大小写敏感
-- -w match word
-- -e 正则表达式匹配
-- -v 反转匹配
-- -g 通配符文件或文件夹，可以用!来取反
-- -F fixed-string 原意字符串，类似python的 r'xxx'

-- examples:
-- command	Description
-- rg image utils.py	Search in a single file utils.py
-- rg image src/	Search in dir src/ recursively
-- rg image	Search image in current dir recursively
-- rg '^We' test.txt	Regex searching support (lines starting with We)
-- rg -i image	Search image and ignore case (case-insensitive search)
-- rg -s image	Smart case search
-- rg -F '(test)'	Search literally, i.e., without using regular expression
-- rg image -g '*.py'	File globing (search in certain files), can be used multiple times
-- rg image -g '!*.py'	Negative file globing (do not search in certain files)
-- rg image --type py or rg image -tpy1	Search image in Python file
-- rg image -Tpy	Do not search image in Python file type
-- rg -l image	Only show files containing image (Do not show the lines)
-- rg --files-without-match image	Show files not containing image
-- rg -v image	Inverse search (search files not containing image)
-- rg -w image	Search complete word
-- rg --count	Show the number of matching lines in a file
-- rg --count-matches	Show the number of matchings in a file
-- rg neovim --stats	Show the searching stat (how many matches, how many files searched etc.)

-- ====for fzf search=====
-- Token	Match type	Description
-- sbtrkt	fuzzy-match	Items that match sbtrkt
-- 'wild	exact-match (quoted)	Items that include wild
-- ^music	prefix-exact-match	Items that start with music
-- .mp3$	suffix-exact-match	Items that end with .mp3
-- !fire	inverse-exact-match	Items that do not include fire
-- !^music	inverse-prefix-exact-match	Items that do not start with music
-- !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3

-- A single bar character term acts as an OR operator.
-- For example, the following query matches entries that start with core and end with either go, rb, or py.
-- ^core go$ | rb$ | py$


local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	vim.notify("telescope not found!")
	return
end

local actions = require "telescope.actions"
-- 添加 live_grep_args actions
local lga_actions = require "telescope-live-grep-args.actions"

-- disable preview binaries
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
	filepath = vim.fn.expand(filepath)
	Job:new({
		command = "file",
		args = { "--mime-type", "-b", filepath },
		on_exit = function(j)
			local mime_type = vim.split(j:result()[1], "/")[1]
			if mime_type == "text" then
				previewers.buffer_previewer_maker(filepath, bufnr, opts)
			else
				-- maybe we want to write something to the buffer here
				vim.schedule(function()
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
				end)
			end
		end
	}):sync()
end

telescope.setup {
	defaults = {
		buffer_previewer_maker = new_maker,

		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },

		mappings = {
			i = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-j>"] = actions.preview_scrolling_down,
				["<C-k>"] = actions.preview_scrolling_up,
				["<C-o>"] = actions.select_horizontal,
				["<C-e>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
				["<CR>"] = actions.select_default,
				["<C-q>"] = actions.close,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-c>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-c>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["<M-n>"] = actions.cycle_history_next,
				["<M-p>"] = actions.cycle_history_prev,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
				["<C-f>"] = function(rightmove)
					local pos = vim.fn.getcurpos()
					pos[3] = pos[3] + 1
					vim.fn.setpos(".", pos)
				end,
			},

			n = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-j>"] = actions.preview_scrolling_down,
				["<C-k>"] = actions.preview_scrolling_up,
				["<C-o>"] = actions.select_horizontal,
				["<C-e>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
				["<CR>"] = actions.select_default,
				["<C-q>"] = actions.close,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-c>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-c>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["<M-n>"] = actions.cycle_history_next,
				["<M-p>"] = actions.cycle_history_prev,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<C-_>"] = actions.which_key,
			},
		},
	},
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false,
			-- find_command = { "find", "-type", "f" },
			find_command = { "fd", "-H" , "-I"},  -- "-H" search hidden files, "-I" do not respect to gitignore
		},
		lsp_definitions = { 
			jump_type = "never",
			theme = "ivy"
		},
		lsp_references = { 
			jump_type = "never",
			include_declaration = false,
			theme = "ivy"
		},
		lsp_type_definitions = { 
			jump_type = "never",
			theme = "ivy"
		},
		lsp_implementations = { 
			jump_type = "never",
			theme = "ivy"
		},

		-- Default configuration for builtin pickers goes here:
		-- picker_name = {
		--   picker_config_key = value,
		--   ...
		-- }
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
	},
	extensions = {
		-- Your extension configuration goes here:
		-- extension_name = {
		--   extension_config_key = value,
		-- }

		-- 添加 live_grep_args 配置
		live_grep_args = {
			auto_quoting = true, -- 启用自动引号
			-- 定义参数如何传递给 rg
			mappings = { -- 扩展的映射
				i = {
					["<C-u>"] = lga_actions.quote_prompt(),  -- 使用 Ctrl+2 添加引号
					["<C-g>"] = function(prompt_bufnr)
						-- 只添加 -g，不加引号
						local current_picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
						local prompt = current_picker:_get_prompt()
						current_picker:set_prompt(prompt .. " -g ")
					end,
					["<C-i>"] = function(prompt_bufnr)
						-- 只添加 --iglob，不加引号
						local current_picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
						local prompt = current_picker:_get_prompt()
						current_picker:set_prompt(prompt .. " --iglob ")
					end,
				},
			},
			-- ... 也可以传递额外的选项给 `live_grep`，例如:
			-- "hidden" 会传递 `--hidden` 参数给 "rg"
			theme = "ivy", -- 使用 ivy 主题
			
			-- 设置默认的 ripgrep 参数
			-- 如果你总是想看到行号，可以设置:
			-- vimgrep_arguments = {
			--   "rg",
			--   "--color=never",
			--   "--no-heading",
			--   "--with-filename",
			--   "--line-number",
			--   "--column",
			--   "--smart-case",
			--   "--hidden", -- 搜索隐藏文件
			--   "--glob=!.git/*", -- 但排除 .git
			-- },
		},

		-- fzf syntax
		-- Token	Match type	Description
		-- sbtrkt	fuzzy-match	Items that match sbtrkt
		-- 'wild'	exact-match (quoted)	Items that include wild
		-- ^music	prefix-exact-match	Items that start with music
		-- .mp3$	suffix-exact-match	Items that end with .mp3
		-- !fire	inverse-exact-match	Items that do not include fire
		-- !^music	inverse-prefix-exact-match	Items that do not start with music
		-- !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
}

vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"

telescope.load_extension('fzf')
telescope.load_extension("live_grep_args")
-- telescope.load_extension("frecency")
--telescope.load_extension('dap')
-- telescope.load_extension('vim_bookmarks')

-- load project extension. see project.lua file

-- 创建一些有用的全局函数来简化使用
_G.grep_in_files = function(pattern)
	-- 在特定文件类型中搜索
	require('telescope').extensions.live_grep_args.live_grep_args({
		default_text = '"' .. vim.fn.expand("<cword>") .. '" -g ' .. (pattern or "*.{c,h}")
	})
end

_G.grep_exclude = function(exclude_pattern)
	-- 排除特定文件搜索
	require('telescope').extensions.live_grep_args.live_grep_args({
		default_text = '"' .. vim.fn.expand("<cword>") .. '" -g !' .. (exclude_pattern or "*/test/*")
	})
end

