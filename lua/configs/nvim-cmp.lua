local cmp = require("cmp") -- Motor de autocompletado
local luasnip = require("luasnip") -- Motor de snippets
require("luasnip.loaders.from_vscode").lazy_load() -- Carga snippets estilo VSCode

cmp.setup({
	completion = {
		completeopt = "menu,menuone,preview,noselect", -- Opciones de menú para autocompletado
	},
	snippet = {
		-- Define cómo expandir snippets con luasnip
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-K>"] = cmp.mapping.select_prev_item(), -- Selecciona sugerencia anterior
		["<C-j>"] = cmp.mapping.select_next_item(), -- Selecciona siguiente sugerencia
		["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll arriba en docs
		["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll abajo en docs
		["<C-Space>"] = cmp.mapping.complete(), -- Mostrar sugerencias manualmente
		["<C-e>"] = cmp.mapping.abort(), -- Cierra el menú de sugerencias
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Confirmar selección con Enter
	}),
	sources = cmp.config.sources({
		{ name = "luasnip" }, -- Fuente: snippets
		{ name = "buffer" }, -- Fuente: contenido del buffer
		{ name = "path" }, -- Fuente: rutas de sistema de archivos
	}),
})
