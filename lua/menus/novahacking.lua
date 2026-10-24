-- Menú NovaHacking: lua/menus/novahacking.lua
-- rtxt muestra una etiqueta; no registra un atajo de teclado.
local hl = vim.api.nvim_set_hl

-- Paleta pastel original.
hl(0, "PastelRose", { fg = "#d36a60" })
hl(0, "PastelGreen", { fg = "#81c995" })
hl(0, "PastelPurple", { fg = "#d7aefb" })
hl(0, "PastelOrange", { fg = "#ee9f4f" })
hl(0, "PastelYellow", { fg = "#ffd274" })
hl(0, "PastelTeal", { fg = "#a7ffeb" })

return {
	{
		name = "󰈔  Formatear Archivo",
		hl = "PastelPurple",
		cmd = function()
			local ok, conform = pcall(require, "conform")
			if ok then
				conform.format({ lsp_format = "fallback", async = true })
			else
				vim.lsp.buf.format({ async = true })
			end
		end,
		rtxt = "<leader>lf",
	},
	{
		name = "󰘦  Acciones de Código",
		hl = "PastelPurple",
		cmd = vim.lsp.buf.code_action,
		rtxt = "<leader>ca",
	},
	{
		name = "󰞋  Ir a definición",
		hl = "PastelPurple",
		cmd = vim.lsp.buf.definition,
		rtxt = "<leader>lgd",
	},
	{
		name = "󰜢  Ver Referencias",
		hl = "PastelPurple",
		cmd = vim.lsp.buf.references,
		rtxt = "<leader>lgr",
	},
	{ name = "separator" },
	{
		name = "󰈬  Mostrar Errores",
		hl = "PastelRose",
		cmd = function()
			-- Diagnósticos de la línea actual, sin requerir Trouble.
			vim.diagnostic.open_float(nil, { scope = "line", border = "rounded" })
		end,
	},
	{
		name = "  Acciones LSP",
		hl = "Exblue",
		items = "lsp",
	},
	{ name = "separator" },
	{
		name = "  Terminal flotante",
		hl = "ExRed",
		cmd = "ToggleTerm direction=float",
		rtxt = "<leader>tf",
	},
	{
		name = "  Terminal Horizontal",
		hl = "ExRed",
		cmd = "ToggleTerm direction=horizontal",
		rtxt = "<leader>th",
	},
	{
		name = "  Terminal Vertical",
		hl = "ExRed",
		cmd = "ToggleTerm direction=vertical",
		rtxt = "<leader>tv",
	},
	{ name = "separator" },
	{
		name = "󰈞  Buscar Archivos",
		hl = "PastelYellow",
		cmd = function()
			require("telescope.builtin").find_files()
		end,
		rtxt = "<leader>ff",
	},
	{
		name = "󰊄  Buscar en Texto",
		hl = "PastelYellow",
		cmd = function()
			require("telescope.builtin").live_grep()
		end,
		rtxt = "<leader>fg",
	},
	{
		name = "󱎸  Buscar Buffers",
		hl = "PastelYellow",
		cmd = function()
			require("telescope.builtin").buffers()
		end,
		rtxt = "<leader>fb",
	},
	{ name = "separator" },
	{
		name = "󰺕  Ver Cambios Git",
		cmd = function()
			require("gitsigns").preview_hunk()
		end,
		rtxt = "<leader>hp",
	},
	{
		name = "󰦨  Cambios de línea",
		cmd = function()
			require("gitsigns").toggle_linehl()
		end,
		rtxt = ":Gitsigns toggle_linehl",
	},
	{ name = "separator" },
	{
		name = "󰈙  Copiar Todo",
		hl = "PastelTeal",
		cmd = "%y+",
		rtxt = ":%y+",
	},
	{
		name = "󰆴  Borrar Todo",
		hl = "PastelTeal",
		cmd = "%d",
		rtxt = ":%d",
	},
	{
		name = "󰏘  Selector de Color",
		hl = "PastelOrange",
		cmd = function()
			require("minty.huefy").open()
		end,
		rtxt = ":Huefy",
	},
	{
		name = "  Practica con el teclado",
		hl = "PastelOrange",
		cmd = "Typr",
		rtxt = ":Typr",
	},
	{
		name = "󰕮  Estadísticas del teclado",
		hl = "PastelOrange",
		cmd = "TyprStats",
		rtxt = ":TyprStats",
	},
	{ name = "separator" },
	{
		name = "󰸱  Ver Markdown (Glow)",
		hl = "PastelGreen",
		cmd = "Glow",
		rtxt = ":Glow",
	},
}
