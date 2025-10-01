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

-- ================== 高亮辅助函数 ==================
local function setup_search_highlight(search_term)
    if search_term and search_term ~= "" then
        -- 提取纯搜索词（去掉引号和 rg 参数）
        local clean_term = search_term:match('^"([^"]+)"') or
                          search_term:match('^([^%s]+)') or
                          search_term
        vim.fn.setreg('/', clean_term)
        vim.o.hlsearch = true
    end
end

-- 创建带高亮的 live_grep_args 包装函数
local function live_grep_args_with_highlight(opts)
    opts = opts or {}

    -- 添加 attach_mappings 来处理高亮
    opts.attach_mappings = function(prompt_bufnr, map)
        local action_state = require("telescope.actions.state")

        -- 在输入时更新高亮
        map("i", "<C-r>", function()
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local prompt = current_picker:_get_prompt()
            setup_search_highlight(prompt)
        end)

        -- 打开预览时设置高亮
        local actions = require("telescope.actions")
        actions.select_default:replace(function()
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local prompt = current_picker:_get_prompt()
            setup_search_highlight(prompt)

            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
                vim.cmd('edit ' .. selection.path)
                vim.api.nvim_win_set_cursor(0, {selection.lnum, 0})
                vim.cmd('normal! n')
            end
        end)

        return true
    end

    -- 初始设置
    if opts.default_text then
        setup_search_highlight(opts.default_text)
    end

    require('telescope').extensions.live_grep_args.live_grep_args(opts)
end

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

-- ================== 智能调整视图的辅助函数 ==================
local function center_cursor_if_needed()
	-- 检测光标位置，如果在屏幕下半部则自动居中
	local win_height = vim.api.nvim_win_get_height(0)
	local cursor_line = vim.fn.winline()

	-- 如果光标在屏幕下60%的位置，先居中显示
	if cursor_line > win_height * 0.6 then
		vim.cmd("normal! zz")
	end
end

-- 【修复】创建智能启动函数的工厂 - 合并配置而不是覆盖
local function create_smart_telescope_func(telescope_func, additional_options, picker_name)
	return function()
		center_cursor_if_needed()

		-- 获取 telescope setup 中该 picker 的默认配置
		local default_config = {}
		if picker_name and telescope.setup_config and telescope.setup_config.pickers and telescope.setup_config.pickers[picker_name] then
			default_config = telescope.setup_config.pickers[picker_name]
		end

		-- 合并配置：默认配置 + 额外选项
		local merged_options = vim.tbl_deep_extend("force", default_config, additional_options or {})

		telescope_func(merged_options)
	end
end

-- 智能启动函数
local M = {}

M.smart_lsp_definitions = create_smart_telescope_func(
	require('telescope.builtin').lsp_definitions,
	{ jump_type = 'never' },
	'lsp_definitions'
)

M.smart_lsp_declarations = create_smart_telescope_func(
	require('telescope.builtin').lsp_definitions,
	{ jump_type = 'never', prompt_title = 'Declaration' },
	'lsp_definitions'
)

M.smart_lsp_implementations = create_smart_telescope_func(
	require('telescope.builtin').lsp_implementations,
	{ jump_type = 'never' },
	'lsp_implementations'
)

M.smart_lsp_type_definitions = create_smart_telescope_func(
	require('telescope.builtin').lsp_type_definitions,
	{ jump_type = 'never' },
	'lsp_type_definitions'
)

M.smart_lsp_incoming_calls = create_smart_telescope_func(
	require('telescope.builtin').lsp_incoming_calls,
	{},
	'lsp_incoming_calls'
)

M.smart_lsp_outgoing_calls = create_smart_telescope_func(
	require('telescope.builtin').lsp_outgoing_calls,
	{},
	'lsp_outgoing_calls'
)

M.smart_lsp_references = create_smart_telescope_func(
	require('telescope.builtin').lsp_references,
	{ jump_type = 'never', include_declaration = false },
	'lsp_references'
)

M.smart_lsp_document_symbols = create_smart_telescope_func(
	require('telescope.builtin').lsp_document_symbols,
	{},
	'lsp_document_symbols'
)

M.smart_lsp_dynamic_workspace_symbols = create_smart_telescope_func(
	require('telescope.builtin').lsp_dynamic_workspace_symbols,
	{},
	'lsp_dynamic_workspace_symbols'
)

M.smart_diagnostics = create_smart_telescope_func(
	require('telescope.builtin').diagnostics,
	{ bufnr = nil },
	'diagnostics'
)

M.smart_help_tags = create_smart_telescope_func(
	require('telescope.builtin').help_tags,
	{},
	'help_tags'
)

-- 导出智能函数
_G.smart_telescope = M

-- 【重要】保存 setup 配置供智能函数使用
local telescope_config = {
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
			theme = "ivy",
			layout_config = {
				height = 0.5,  -- 统一使用 50% 屏幕高度
			}
		},
		lsp_references = {
			jump_type = "never",
			include_declaration = false,
			theme = "ivy",
			layout_config = {
				height = 0.5,
			}
		},
		lsp_type_definitions = {
			jump_type = "never",
			theme = "ivy",
			layout_config = {
				height = 0.5,
			}
		},
		lsp_implementations = {
			jump_type = "never",
			theme = "ivy",
			layout_config = {
				height = 0.5,
			}
		},
		-- 添加缺失的 LSP pickers
		lsp_document_symbols = {
			theme = "ivy",
			layout_config = {
				height = 0.5,
			}
		},
		lsp_dynamic_workspace_symbols = {
			theme = "ivy",
			layout_config = {
				height = 0.5,
			}
		},
		lsp_incoming_calls = {
			theme = "ivy",
			layout_config = {
				height = 0.5,
			}
		},
		lsp_outgoing_calls = {
			theme = "ivy",
			layout_config = {
				height = 0.5,
			}
		},
		diagnostics = {
			theme = "ivy",
			layout_config = {
				height = 0.5,  -- 与其他功能保持一致
			}
		},
		help_tags = {
			theme = "ivy",
			layout_config = {
				height = 0.5,
			}
		},
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

-- 保存配置供智能函数访问
telescope.setup_config = telescope_config

telescope.setup(telescope_config)

vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"

telescope.load_extension('fzf')
telescope.load_extension("live_grep_args")
-- telescope.load_extension("frecency")
--telescope.load_extension('dap')
-- telescope.load_extension('vim_bookmarks')

-- load project extension. see project.lua file

-- ================== 带高亮的搜索函数 ==================
-- 新增：<Space>gG 的包装函数
_G.grep_global_with_highlight = function()
    live_grep_args_with_highlight()
end

-- 新增：<Space>gg 的包装函数
_G.grep_word_under_cursor_with_highlight = function()
    local word = vim.fn.expand("<cword>")
    setup_search_highlight(word)

    require('telescope-live-grep-args.shortcuts').grep_word_under_cursor({
        postfix = " ",
        attach_mappings = function(prompt_bufnr, map)
            -- 继承高亮设置
            return true
        end,
    })
end

-- 修改原有的 grep_in_files 函数
_G.grep_in_files = function(pattern)
    local word = vim.fn.expand("<cword>")
    local search_text = '"' .. word .. '" -g ' .. (pattern or "*.{c,h}")

    setup_search_highlight(word)
    live_grep_args_with_highlight({
        default_text = search_text
    })
end

-- 修改原有的 grep_exclude 函数
_G.grep_exclude = function(exclude_pattern)
    local word = vim.fn.expand("<cword>")
    local search_text = '"' .. word .. '" -g !' .. (exclude_pattern or "*/test/*")

    setup_search_highlight(word)
    live_grep_args_with_highlight({
        default_text = search_text
    })
end

-- ================== 增强预览窗口高亮的自动命令 ==================
-- Telescope 预览窗口自动高亮
vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function(args)
        local search_term = vim.fn.getreg('/')
        if search_term and search_term ~= "" then
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(args.buf) then
                    vim.api.nvim_buf_call(args.buf, function()
                        -- 清除之前的高亮
                        vim.fn.clearmatches()
                        -- 添加新的高亮
                        vim.fn.matchadd('Search', search_term)
                    end)
                end
            end)
        end
    end,
})
