return {
	-- Plugin para mostrar notificaciones flotantes y mensajes del sistema Neovim de forma elegante.
	-- Integra `nvim-notify` para mejorar los mensajes de `vim.notify` y `nui.nvim` para UIs más modernas.
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- tu configuración va aquí
			-- o déjalo vacío para usar la configuración por defecto
			-- consulta la sección de configuración en la documentación

			bigfile = { enabled = true }, -- Maneja archivos grandes eficientemente
			dashboard = { enabled = false }, -- Muestra un panel de inicio declarativo y estético
			explorer = { enabled = false }, -- Explorador de archivos (similar a un picker disfrazado)
			indent = { enabled = true }, -- Guías de indentación y detección de bloques
			input = { enabled = false }, -- Mejora la interfaz para vim.ui.input
			picker = { enabled = true }, -- Selector de elementos (estilo fzf/telescope)
			notifier = { enabled = false }, -- Notificaciones visuales atractivas con vim.notify
			quickfile = { enabled = true }, -- Abre archivos rápidamente antes de cargar plugins
			scope = { enabled = true }, -- Detecta bloques y permite moverse entre ellos (treesitter/indent)
			scroll = { enabled = false }, -- Desplazamiento suave al navegar por archivos
			statuscolumn = { enabled = true }, -- Columna de estado bonita (para signos, líneas, etc.)
			words = { enabled = true }, -- Muestra referencias LSP y permite navegar entre ellas fácilmente
		},
	},

	-- Incline.nvim muestra una pequeña barra flotante encima de cada ventana con el nombre del archivo.
	-- Personalizable con íconos de archivo gracias a `nvim-web-devicons` y estilos con colores.
	{
		"b0o/incline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Necesario para los íconos
		event = "VeryLazy", -- Carga perezosa opcional
		config = function()
			local helpers = require("incline.helpers")
			local devicons = require("nvim-web-devicons")

			require("incline").setup({
				window = {
					padding = 0,
					margin = { horizontal = 0 },
					placement = {
						horizontal = "right",
						vertical = "top",
					},
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end

					local ft_icon, ft_color = devicons.get_icon_color(filename)
					local modified = vim.bo[props.buf].modified

					return {
						ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) }
							or "",
						" ",
						{ filename, gui = modified and "bold,italic" or "italic", guifg = "#ffffff" },
						" ",
						guibg = "#303030", -- "#44406e",
					}
				end,
			})
		end,
	},

	-- Plugin para mejorar la escritura táctil dentro de Neovim.
	-- Ofrece estadísticas y un entorno interactivo para practicar tipeo.
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},

	-- Proporciona una pantalla de inicio interactiva al abrir Neovim.
	-- Se carga automáticamente al evento `VimEnter`.
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Barra de estado personalizable y moderna para Neovim.
	-- Muestra información como modo, rama Git, LSP, y más.
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			return require("configs.lualine")
		end,
	},

	-- Explorador de archivos tipo árbol con atajos y visual moderno.
	-- Reemplaza al obsoleto `netrw` con funciones más potentes.
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			return require("configs.nvimtree")
		end,
		config = function(_, opts)
			require("nvim-tree").setup(opts)
		end,
	},

	-- Complemento del ecosistema `mini.nvim` que ofrece iconos útiles.
	-- Diseñado para integrarse con otros módulos mini o mejorar la UI.
	{
		"nvim-mini/mini.icons",
		version = "*",
	},

	-- Muestra los posibles atajos de teclas al presionar el líder (`<leader>`).
	-- Se carga de forma perezosa con el evento `VeryLazy` o usando `<leader>?`.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "󰺽 Buffer Local Keymaps",
			},
		},
		config = function()
			local wk = require("which-key")
			wk.setup({
				win = {
					border = "rounded",
				},
			})

			wk.add({
				{ "<leader>c", group = "󰯅 Corrección" },
				{ "<leader>ca", vim.lsp.buf.code_action, desc = " Acciones de Código" },

				{ "<leader>r", group = "󰑕 Renombrar" },

				{ "<leader>w", group = " Ventana" },
				{ "<leader>wh", "<cmd>split<cr>", desc = " División Horizontal" },
				{ "<leader>wv", "<cmd>vsplit<cr>", desc = " División Vertical" },
				{ "<leader>wd", vim.cmd.close, desc = " Cerrar ventana actual" },
			})
		end,
	},

	-- Fuzzy finder poderoso para archivos, buffers, LSP, y más.
	-- Se integra con `plenary.nvim` para funciones extendidas en Lua.
	{
		"nvim-telescope/telescope.nvim",

		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.telescope")
		end,
	},

	-- Themes: Ej. tokyonight
	-- Tema visual elegante y personalizable inspirado en Tokyo Night.
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Opciones
			require("tokyonight").setup({
				style = "night", -- themes: night, storm, day, moon.
				transparent = true,
				terminal_colors = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})

			vim.cmd([[colorscheme tokyonight]])

			local highlight_groups = {
				"Normal",
				"NormalNC",
				"TelescopeNormal",
				"TelescopeBorder",
				"TelescopePromptNormal",
				"TelescopePromptBorder",
				"TelescopeResultsNormal",
				"TelescopeResultsBorder",
				"TelescopePreviewNormal",
				"TelescopePreviewBorder",
				"LazyNormal",
			}

			for _, group in ipairs(highlight_groups) do
				-- Para fondo solido usar -> guibg=#1f2335 o el color que desee.
				vim.cmd("hi " .. group .. " guibg=NONE ctermbg=NONE")
			end
		end,
	},

	-- Explorador de archivos minimalista que reemplaza a `netrw`.
	-- Abre en modo flotante con `:Oil` o usando la tecla `-`.
	{
		"stevearc/oil.nvim",
		cmd = "Oil", -- Carga perezosa al usar el comando :Oil
		keys = {
			{ "-", "<cmd>Oil --float<cr>", desc = "󱥇 Open Oil File Explorer" },
		},
		opts = {
			default_file_explorer = false, -- NvimTree abre directorios; Oil se usa con -
			view_options = {
				show_hidden = true, -- Muestra archivos ocultos
			},
			float = {
				padding = 2,
				border = "rounded",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Opcional para íconos
	},

	-- Enfoca la línea actual al oscurecer el resto del buffer.
	-- Perfecto para sesiones de escritura o concentración.
	{
		"folke/twilight.nvim",
		opts = {
			dimming = {
				alpha = 0.25, -- amount of dimming
				-- we try to get the foreground from the highlight groups or fallback color
				color = { "Normal", "#ffffff" },
				term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
				inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
			},
			context = 10, -- amount of lines we will try to show around the current line
			treesitter = true, -- use treesitter when available for the filetype
			-- treesitter is used to automatically expand the visible text,
			-- but you can further control the types of nodes that should always be fully expanded
			expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
				"function",
				"method",
				"table",
				"if_statement",
			},
			exclude = {}, -- exclude these filetypes
		},
	},

	-- Plugin visual para manipular colores y modificar tonos dentro de Neovim.
	-- Se activa con los comandos `:Shades` y `:Huefy` para alterar esquemas de color.
	{
		"nvzone/minty",
		dependencies = { "nvzone/volt" },
		cmd = { "Shades", "Huefy" },
	},

	-- Menús cargados al usar sus atajos. Volt es dependencia directa.
	{
		"nvzone/menu",
		dependencies = { "nvzone/volt", "nvzone/minty" },
		keys = (function()
			local keys = {}
			for _, item in ipairs({
				{ "md", "default", "default" },
				{ "ml", "lsp", "LSP" },
				{ "mg", "gitsigns", "Git" },
				{ "mn", "nvimtree", "NvimTree" },
				{ "mh", "novahacking", "NovaHacking" },
			}) do
				local menu_name = item[2]
				keys[#keys + 1] = {
					"<leader>" .. item[1],
					function()
						local ok, entries = pcall(require, "menus." .. menu_name)
						if not ok then
							vim.notify(
								"Falta lua/menus/"
									.. menu_name
									.. ".lua. "
									.. "Copia tu menú personalizado dentro de la configuración.",
								vim.log.levels.WARN
							)
							return
						end
						require("menu").open(entries, { border = true, mouse = false })
					end,
					desc = " Abrir menú " .. item[3],
				}
			end
			return keys
		end)(),
	},
}
