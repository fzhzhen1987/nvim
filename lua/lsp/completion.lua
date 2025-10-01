-- lsp/completion.lua
-- nvim-cmp 自动补全配置

local M = {}

M.setup = function()
	-- 检查依赖
	local has_cmp, cmp = pcall(require, "cmp")
	if not has_cmp then
		vim.notify("nvim-cmp not found", vim.log.levels.WARN)
		return
	end

	local has_luasnip, luasnip = pcall(require, "luasnip")
	if not has_luasnip then
		vim.notify("luasnip not found", vim.log.levels.WARN)
		return
	end

	local has_lspkind, lspkind = pcall(require, "lspkind")

	-- Set completeopt
	vim.o.completeopt = "menuone,noselect"

	-- 格式化函数
	local cmpFormat = function(entry, vim_item)
		if has_lspkind then
			vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
		end

		vim_item.menu = ({
			buffer = "[Buffer]",
			nvim_lsp = "[LSP]",
			luasnip = "[Snippet]",
			nvim_lua = "[Lua]",
			path = "[Path]",
		})[entry.source.name]

		return vim_item
	end

	-- 配置 nvim-cmp
	cmp.setup {
		completion = {
			placeholder = false,
			autocomplete = {
				require('cmp.types').cmp.TriggerEvent.TextChanged,
			},
		},
		formatting = {
			format = cmpFormat
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end
		},
		mapping = cmp.mapping.preset.insert({
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false
			},
			['<Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { 'i', 's' }),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { 'i', 's' }),
		}),
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp", priority = 1000 },
			{ name = "luasnip", priority = 750 },
			{ name = "buffer", priority = 500 },
			{ name = "path", priority = 250 }
		}),
		experimental = {
			ghost_text = false,
		},
	}

	-- 自定义 confirm 行为（自动添加括号）
	local keymap = require("cmp.utils.keymap")
	cmp.confirm = function(option)
		option = option or {}
		local e = cmp.core.view:get_selected_entry() or (option.select and cmp.core.view:get_first_entry() or nil)
		if e then
			cmp.core:confirm(
				e,
				{ behavior = option.behavior },
				function()
					local myContext = cmp.core:get_context({ reason = cmp.ContextReason.TriggerOnly })
					cmp.core:complete(myContext)
					-- function() 自动增加()
					if e and e.resolved_completion_item and
						(e.resolved_completion_item.kind == 3 or e.resolved_completion_item.kind == 2) then
						vim.api.nvim_feedkeys(keymap.t("()<left>"), "n", true)
					end
				end
			)
			return true
		else
			if vim.fn.complete_info({ "selected" }).selected ~= -1 then
				keymap.feedkeys(keymap.t("<C-y>"), "n")
				return true
			end
			return false
		end
	end
end

return M
