local hl = vim.api.nvim_set_hl

-- Paleta pastel
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
				conform.format({ lsp_fallback = true })
			else
				vim.lsp.buf.format()
			end
		end,
		rtxt = "<leader>fm",
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
		rtxt = "gd",
	},

	{
		name = "󰜢  Ver Referencias",
		hl = "PastelPurple",
		cmd = vim.lsp.buf.references,
		rtxt = "gr",
	},

	{
		name = "separator",
	},

	{
		name = "󰈬  Mostrar Errores",
		hl = "PastelRose",
		cmd = function()
			local ok, trouble = pcall(require, "trouble")
			if ok then
				trouble.toggle()
			else
				vim.diagnostic.open_float()
			end
		end,
		rtxt = "<leader>x",
	},

	{
		name = "  Acciones LSP",
		hl = "Exblue",
		items = "lsp",
	},

	{
		name = "separator",
	},

	{
		name = "  Terminal flotante",
		hl = "ExRed",
		cmd = function()
			local Terminal = require("toggleterm.terminal").Terminal
			local term = Terminal:new({
				direction = "float",
				float_opts = {
					border = "rounded",
				},
			})
			term:toggle()
		end,
		rtxt = "<leader>tt",
	},

	{
		name = "  Terminal Horizontal",
		hl = "ExRed",
		cmd = function()
			local Terminal = require("toggleterm.terminal").Terminal
			local term = Terminal:new({ direction = "horizontal" })
			term:toggle()
		end,
		rtxt = "<leader>th",
	},

	{
		name = "  Terminal Vertical",
		hl = "ExRed",
		cmd = function()
			local Terminal = require("toggleterm.terminal").Terminal
			local term = Terminal:new({ direction = "vertical" })
			term:toggle()
		end,
		rtxt = "<leader>tv",
	},

	{
		name = "separator",
	},

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

	{
		name = "separator",
	},

	{
		name = "󰺕  Ver Cambios Git",
		cmd = function()
			local ok, gs = pcall(require, "gitsigns")
			if ok then
				gs.preview_hunk()
			else
				vim.cmd("Git")
			end
		end,
		rtxt = "<leader>gp",
	},

	{
		name = "󰦨  Cambios de línea",
		cmd = function()
			require("gitsigns").toggle_linehl()
		end,
		rtxt = "<leader>gl",
	},

	{
		name = "separator",
	},

	{
		name = "󰈙  Copiar Todo",
		hl = "PastelTeal",
		cmd = "%y+",
		rtxt = "<C-c>",
	},

	{
		name = "󰆴  Borrar Todo",
		hl = "PastelTeal",
		cmd = "%d",
		rtxt = "dc",
	},

	{
		name = "󰏘  Selector de Color",
		hl = "PastelOrange",
		cmd = function()
			require("minty.huefy").open()
		end,
		rtxt = "<leader>cp",
	},

	{
		name = "  Practica con el teclado",
		hl = "PastelOrange",
		cmd = "Typr",
		rtxt = "tr",
	},

	{
		name = "󰕮  Estadísticas del teclado",
		hl = "PastelOrange",
		cmd = "TyprStats",
		rtxt = "td",
	},

	{
		name = "separator",
	},

	{
		name = "󰸱  Ver Markdown (Glow)",
		hl = "PastelGreen",
		cmd = function()
			vim.cmd("Glow")
		end,
		rtxt = "<leader>mg",
	},
	{
		name = "󰸱  Ver Markdown (Peek)",
		hl = "PastelGreen",
		cmd = function()
			require("peek").open()
		end,
		rtxt = "<leader>mp",
	},

	{
		name = "󰸱  Ver Markdown (MkPreview)",
		hl = "PastelGreen",
		cmd = function()
			vim.cmd("MarkdownPreview")
		end,
		rtxt = "<leader>mm",
	},
}
