local M = {}

-- Carga funciones de utilidad personalizadas desde configs/utils.lua
local utils = require("configs.utils")

-- Configuración para indent-blankline.nvim
M.blankline = {
	indentLine_enabled = 1, -- Habilita indentLine
	filetype_exclude = { -- Excluye ciertos tipos de archivo
		"help",
		"terminal",
		"lazy",
		"lspinfo",
		"TelescopePrompt",
		"TelescopeResults",
		"mason",
		"nvdash",
		"nvcheatsheet",
		"", -- Archivos sin tipo
	},
	buftype_exclude = { "terminal" }, -- Excluye terminales
	show_trailing_blankline_indent = false, -- No mostrar indentación al final
	show_first_indent_level = false, -- No mostrar primer nivel de indentación
	show_current_context = true, -- Muestra el contexto actual
	show_current_context_start = true, -- Muestra el inicio del contexto actual
}

-- Configuración para luasnip y carga de snippets
M.luasnip = function(opts)
	require("luasnip").config.set_config(opts) -- Aplica opciones de configuración

	-- Carga snippets en formato VSCode
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load({
		paths = vim.g.vscode_snippets_path or "", -- Ruta opcional personalizada
	})

	-- Carga snippets en formato SnipMate
	require("luasnip.loaders.from_snipmate").load()
	require("luasnip.loaders.from_snipmate").lazy_load({
		paths = vim.g.snipmate_snippets_path or "",
	})

	-- Carga snippets en formato Lua
	require("luasnip.loaders.from_lua").load()
	require("luasnip.loaders.from_lua").lazy_load({
		paths = vim.g.lua_snippets_path or "",
	})

	-- Limpia los snippets al salir del modo insert si ya no están activos
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			if
				require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
				and not require("luasnip").session.jump_active
			then
				require("luasnip").unlink_current()
			end
		end,
	})
end

-- Configuración para gitsigns.nvim
local wk = require("which-key")

local function gitsigns_attach_mappings(bufnr)
	wk.register({
		["<leader>h"] = {
			name = "󰊢 Hunk",
			s = { ":Gitsigns stage_hunk<CR>", " Stage hunk" },
			u = { ":Gitsigns undo_stage_hunk<CR>", "󰑐 Undo stage hunk" },
			r = { ":Gitsigns reset_hunk<CR>", " Reset hunk" },
			p = { ":Gitsigns preview_hunk<CR>", " Preview hunk" },
			b = { ":Gitsigns blame_line<CR>", "󰊛 Blame line" },
		},
	}, { buffer = bufnr, mode = "n" })
end

M = {}

M.gitsigns = {
	signs = {
		add = { text = "│" }, -- Línea para líneas añadidas
		change = { text = "│" }, -- Línea para líneas modificadas
		delete = { text = "󰍵" }, -- Símbolo para líneas borradas
		topdelete = { text = "‾" }, -- Símbolo para borrado al inicio
		changedelete = { text = "~" }, -- Línea para cambios + borrado
		untracked = { text = "│" }, -- Línea para archivos nuevos sin seguimiento
	},
	on_attach = function(bufnr)
		gitsigns_attach_mappings(bufnr)
	end,
}

return M
