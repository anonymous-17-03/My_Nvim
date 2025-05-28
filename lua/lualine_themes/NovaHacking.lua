-- Basado en un tema "Bubbles" con colores e íconos inspirados en el tema Eviline.
-- Definimos resaltados personalizados para los buffers activos e inactivos en la línea de estado
vim.cmd([[
  highlight LualineBuffersCurrent guifg=#d183e8 guibg=#202328 gui=bold
  highlight LualineBuffers guifg=#808080 guibg=#202328
]])

-- Esto indica a Neovim que nunca muestre la tabline nativa, incluso si otros plugins la intentan usar.
vim.o.showtabline = 0

-- Cargamos el módulo de lualine
local lualine = require("lualine")

-- Definimos una tabla de colores para usar en el tema y componentes
local colors = {
	blue = "#80a0ff",
	cyan = "#79dac8",
	black = "#080808",
	white = "#c6c6c6",
	red = "#ff5189",
	violet = "#d183e8",
	grey = "#303030",
	bg = "#202328",
	fg = "#bbc2cf",
	yellow = "#ECBE7B",
	green = "#98be65",
	orange = "#FF8800",
	magenta = "#c678dd",
}

-- Funciones condicionales para mostrar u ocultar ciertos componentes basados en el contexto actual

local conditions = {
	-- Verifica que el buffer actual no esté vacío
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	-- Verifica que el ancho de la ventana sea mayor a 80 caracteres para mostrar componentes extensos
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	-- Verifica si estamos dentro de un workspace git para mostrar información git
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		-- Retorna true si se encontró un directorio .git y está dentro del path
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Tema personalizado para lualine basado en "Bubbles" con colores Eviline
local bubbles_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.violet },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.white, bg = colors.bg },
	},
	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },
	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white, bg = colors.bg },
	},
}

-- Configuración principal de lualine
local config = {
	options = {
		-- Usamos el tema definido arriba
		theme = bubbles_theme,
		-- Separadores entre componentes y secciones
		component_separators = { left = "│", right = "│" },
		section_separators = { left = "", right = "" },
		globalstatus = true, -- Usa la barra de estado global (Neovim >= 0.7)
	},
	sections = {
		-- Sección izquierda A (modo actual y un icono personalizado)
		lualine_a = {
			{
				-- Muestra un icono personalizado
				function()
					return ""
				end,
				separator = { left = "" },
				color = { fg = "#000000" }, -- Color negro para el icono
				padding = { left = 1, right = 1 },
			},
			-- Muestra el modo actual (NORMAL, INSERT, etc)
			{ "mode", separator = { left = "", right = "" }, right_padding = 2 },
		},
		-- Sección izquierda B (nombre del archivo)
		lualine_b = {
			{
				"filename",
				path = 1, -- Mostrar el path relativo del archivo
				symbols = { modified = "⦿", readonly = "", unnamed = "[No Name]" },
				color = { gui = "bold" }, -- Nombre en negrita
				cond = conditions.buffer_not_empty, -- Solo si buffer no está vacío
			},
		},
		-- Sección central C (tamaño archivo, diagnósticos y buffers abiertos)
		lualine_c = {
			{ "filesize", cond = conditions.buffer_not_empty },
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					error = { fg = colors.red },
					warn = { fg = colors.yellow },
					info = { fg = colors.cyan },
				},
			},
			{
				-- Muestra la lista de buffers abiertos con colores personalizados para el buffer activo
				function()
					local buffers = vim.fn.getbufinfo({ buflisted = true })
					local result = {}
					for i, buffer in ipairs(buffers) do
						local name = vim.fn.fnamemodify(buffer.name, ":t")
						if buffer.bufnr == vim.fn.bufnr("%") then
							table.insert(result, "%#LualineBuffersCurrent#" .. name .. "%#LualineBuffers#")
						else
							table.insert(result, "%#LualineBuffers#" .. name)
						end
						if i < #buffers then
							table.insert(result, " │ ")
						end
					end
					return table.concat(result)
				end,
				color = { fg = colors.grey }, -- Gris para buffers inactivos
			},
		},
		-- Sección derecha X (LSP, codificación, formato, rama git y diferencias)
		lualine_x = {
			{
				-- Muestra el cliente LSP activo o "No Active Lsp" si no hay ninguno
				function()
					local msg = "No Active Lsp"
					local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
					local clients = vim.lsp.get_active_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
					return msg
				end,
				icon = "│   LSP:",
				color = { fg = colors.blue, gui = "bold" },
			},
			{
				"o:encoding", -- Muestra codificación (UTF-8, etc)
				fmt = string.upper, -- Mayúsculas
				cond = conditions.hide_in_width, -- Solo si ventana suficientemente ancha
				color = { fg = colors.green, gui = "bold" },
			},
			{
				"fileformat", -- Formato de archivo (unix, dos, mac)
				fmt = string.upper,
				icons_enabled = true,
				color = { fg = colors.green, gui = "bold" },
			},
			{
				"branch", -- Rama git actual
				icon = "",
				color = { fg = colors.violet, gui = "bold" },
			},
			{
				"diff", -- Cambios git: añadidos, modificados, eliminados
				symbols = { added = " ", modified = "󰝤 ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			},
		},
		-- Sección derecha Y (tipo de archivo y progreso en el buffer)
		lualine_y = { "filetype", "progress" },
		-- Sección derecha Z (posición del cursor con separadores)
		lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
	},
	-- Secciones para ventanas inactivas (sin foco)
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {}, -- No se usa configuración para la tabline
	extensions = {
		{
			sections = {
				lualine_a = {
					function()
						return "  CheatSheet"
					end,
				},
			},
			filetypes = { "nvcheatsheet" },
		},
		{
			sections = {
				lualine_a = {
					function()
						return "  Oil"
					end,
				},
			},
			filetypes = { "oil" },
		},
		{
			sections = {
				lualine_a = {
					function()
						return "  LazyGit"
					end,
				},
			},
			filetypes = { "lazygit" },
		},
		{
			sections = {
				lualine_a = {
					function()
						return "󰕮  DASHBOARD"
					end,
				},
			},
			filetypes = { "dashboard" },
		},
		{
			sections = {
				lualine_a = {
					function()
						return "   Typr"
					end,
				},
			},
			filetypes = { "typr" },
		},
		{
			sections = {
				lualine_a = {
					function()
						return "   TyprStats"
					end,
				},
			},
			filetypes = { "typrstats" },
		},

		"toggleterm",
		"mason",
		"man",
		"lazy",
		"fzf",
		"quickfix",
	}, -- Extensiones adicionales
}

-- Finalmente, se inicializa lualine con la configuración arriba definida
lualine.setup(config)
