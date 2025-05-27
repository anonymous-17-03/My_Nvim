local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text", -- Puedes usar también 'symbol' o 'text'
			maxwidth = 50, -- Acorta sugerencias muy largas
			ellipsis_char = "...", -- Usa ... para cortar
			symbol_map = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰜢",
				Variable = "󰀫",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "",
				-- NUEVOS
				KeywordConditional = "󰘦",
				KeywordReturn = "󰌑",
				KeywordOperator = "󰌋",
				Comment = "󰅺",
				Boolean = "",
				Array = "",
				Null = "",
				Object = "",
				String = "",
				Package = "󰏖",
				Macro = "",
				Namespace = "",
				Number = "󰎠",
			},
		}),
	},
	completion = {
		completeopt = "menu,menuone,preview,noselect",
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	snippet = { -- configure how nvim-mp interacts with snippet engine
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-K>"] = cmp.mapping.select_prev_item(), --previous suggestion
		["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		["<C-y>"] = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000 },
		{ name = "luasnip", priority = 750 },
		{ name = "treesitter", priority = 700 },
		{ name = "buffer", priority = 500 },
		{ name = "path", priority = 250 },
		{ name = "calc", priority = 100 },
	}),
})
-- Completado para comandos `:`
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Completado para búsqueda `/` y `?`
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Integración con autopairs para cerrar paréntesis al confirmar
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
