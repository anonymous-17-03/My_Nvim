return {
	-- Plugin para mostrar notificaciones flotantes y mensajes del sistema Neovim de forma elegante.
	-- Integra `nvim-notify` para mejorar los mensajes de `vim.notify` y `nui.nvim` para UIs más modernas.
	-- Reemplaza los mensajes tradicionales con ventanas flotantes estilizadas y configurables.
	-- Muy útil para mejorar la UX en Neovim con más claridad visual en errores, advertencias o información.
	-- Se carga de manera perezosa al inicio con el evento `VeryLazy`.
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	-- Incline.nvim muestra una pequeña barra flotante encima de cada ventana con el nombre del archivo.
	-- Personalizable con íconos de archivo gracias a `nvim-web-devicons` y estilos con colores.
	-- Indica visualmente en qué ventana estás trabajando.
	-- Ideal para entornos con múltiples splits o buffers abiertos al mismo tiempo.
	-- Se carga de forma perezosa usando `VeryLazy` y tiene una configuración visual limpia.
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
	-- Se carga con los comandos :Typr y :TyprStats, útil para sesiones enfocadas.
	-- Depende del plugin `nvzone/volt`, por lo que debe estar presente.
	-- Ideal para usuarios que quieren mejorar su velocidad de escritura en Neovim.
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},

	-- Proporciona una pantalla de inicio interactiva al abrir Neovim.
	-- Se carga automáticamente al evento `VimEnter`.
	-- Puede mostrar atajos, plugins recientes o sesiones anteriores.
	-- Depende de `nvim-web-devicons` para mostrar íconos atractivos.
	-- Mejora la estética y usabilidad inicial del entorno de desarrollo.
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
	-- Utiliza íconos con `nvim-web-devicons` para una mejor experiencia visual.
	-- Configurado desde un archivo externo en `configs.lualine`.
	-- Se carga al inicio y mejora significativamente la interfaz inferior.
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			return require("configs.lualine")
		end,
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},

	-- Explorador de archivos tipo árbol con atajos y visual moderno.
	-- Reemplaza al obsoleto `netrw` con funciones más potentes.
	-- Se carga desde el inicio (`lazy = false`) para acceso inmediato.
	-- Configurado externamente desde `configs.nvimtree`.
	-- Compatible con íconos si se incluye `nvim-web-devicons`.
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
	-- Compatible con temas personalizados y plugins como `lualine`.
	-- Puede ser usado para reemplazar iconos pesados de otros plugins.
	-- Está siempre actualizado (`version = "*"`), manteniendo compatibilidad.
	{
		"echasnovski/mini.icons",
		version = "*",
	},

	-- Muestra los posibles atajos de teclas al presionar el líder (`<leader>`).
	-- Se carga de forma perezosa con el evento `VeryLazy` o usando `<leader>?`.
	-- Ayuda a recordar comandos y jerarquías sin salir de Neovim.
	-- Configura grupos de atajos organizados y accesibles visualmente.
	-- Mejora la productividad y descubrimiento de combinaciones de teclas.
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
				{ "<leader>ca", "<cmd>ca<cr>", desc = " Acciones de Código" },

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
	-- Configurado desde `configs.telescope` para ajustes personalizados.
	-- Ofrece interfaz flotante y búsqueda instantánea en múltiples fuentes.
	-- Una de las herramientas más potentes de navegación en Neovim.
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			return require("configs.telescope")
		end,
	},

	-- Themes: Ej. tokyonight
	-- Tema visual elegante y personalizable inspirado en Tokyo Night.
	-- Compatible con transparencia, terminales y estilos en flotantes.
	-- Se configura automáticamente al cargarse, cambiando el `colorscheme`.
	-- Aplica transparencia global a múltiples grupos de resaltado.
	-- Altamente recomendado para un entorno de desarrollo estético y moderno.
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
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
				vim.cmd("hi " .. group .. " guibg=NONE ctermbg=NONE")
			end
		end,
	},

	-- Explorador de archivos minimalista que reemplaza a `netrw`.
	-- Abre en modo flotante con `:Oil` o usando la tecla `-`.
	-- Compatible con íconos y navegación de directorios estilo Vim.
	-- Configurable para mostrar archivos ocultos y ajustar apariencia flotante.
	-- Ideal para usuarios que buscan un file manager ágil y visualmente limpio.
	{
		"stevearc/oil.nvim",
		cmd = "Oil", -- Carga perezosa al usar el comando :Oil
		keys = {
			{ "-", "<cmd>Oil --float<cr>", desc = "󱥇 Open Oil File Explorer" },
		},
		opts = {
			default_file_explorer = true, -- Reemplaza netrw
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
	-- Utiliza Treesitter para expandir bloques relevantes automáticamente.
	-- Permite personalizar el nivel de dimming y colores.
	-- Aporta una experiencia de enfoque visual muy agradable.
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

	-- Muestra un cheatsheet visual con atajos de teclado organizados.
	-- Incluye header ASCII, secciones de navegación, edición, y más.
	-- Activado con `<leader>a`, ideal para memorizar keybindings complejos.
	-- Permite personalizar colores, secciones y hasta el estilo visual.
	-- Una excelente herramienta para usuarios que personalizan mucho Neovim.
	{
		"smartinellimarco/nvcheatsheet.nvim",
		opts = {
			-- Default header
			header = {
				"                                      ",
				"                                      ",
				"                                      ",
				"█▀▀ █░█ █▀▀ ▄▀█ ▀█▀ █▀ █░█ █▀▀ █▀▀ ▀█▀",
				"█▄▄ █▀█ ██▄ █▀█ ░█░ ▄█ █▀█ ██▄ ██▄ ░█░",
				"                                      ",
				"                                      ",
				"                                      ",
			},
			-- Example keymaps (this doesn't create any)
			keymaps = {
				["Oil"] = {
					{ "Ejecutar Oil", "-" },
					{ "Ejecutar desde comando", ":Oil --float<CR>" },
				},

				["Comment"] = {
					{ "Comentar línea actual", "gcc" },
					{ "Comentar líneas seleccionadas", "gc" },
				},

				["Navegación"] = {
					{ "Ir al principio", "gg" },
					{ "Ir al final", "G" },
				},

				["Menú"] = {
					{ "Abrir Opciones de Menú", "<leader>m" },
					{ "Abrir Menú Default", "<leader>md" },
					{ "Abrir Menú LSP", "<leader>ml" },
					{ "Abrir Menú Git", "<leader>mg" },
					{ "Abrir Menú nvimtree", "<leader>mn" },
					{ "Abrir Menú NovaHacking", "<leader>mh" },
				},

				["NvimTree"] = {
					{ "Enfocar NvimTree", "<leader>n" },
					{ "Alternar NvimTree", "<C-n>" },
				},

				["Buffers"] = {
					{ "Primer buffer", "<leader>1" },
					{ "Último buffer", "<leader>0" },
					{ "Siguiente buffer", "<Tab>" },
					{ "Buffer anterior", "<S-Tab>" },
					{ "Siguiente Buffer", "<leader>bn" },
					{ "Buffer Anterior", "<leader>bp" },
					{ "Cerrar buffer actual", "<leader>bd" },
					{ "Cerrar otros buffers", "<leader>bo" },
				},

				["Debug"] = {
					{ "Abrir menú Debug", "<leader>d" },
					{ "Ejecutar DapSidebar", "<leader>ds" },
					{ "Alternar breakpoint", "<leader>db" },
					{ "Continuar", "<leader>dc" },
				},

				["Funciones comunes"] = {
					{ "Salir de todos los buffers", ":qa<CR>" },
					{ "Abrir archivo", ":e <archivo>" },
					{ "Abrir archivo nuevo", ":new<CR>" },
					{ "División vertical", ":vsplit<CR>" },
					{ "División horizontal", ":split<CR>" },
					{ "Moverse entre divisiones", "<C-w>h / j / k / l" },
					{ "Cerrar ventana", ":close<CR>" },
					{ "Limpiar pantalla", ":nohlsearch<CR>" },
					{ "Buscar texto", ":/<texto>" },
					{ "Buscar siguiente coincidencia", "n" },
					{ "Buscar anterior coincidencia", "N" },
					{ "Reemplazo en línea", ":%s/palabra/nueva/g<CR>" },
					{ "Ver lista de buffers", ":ls<CR>" },
					{ "Cambiar a buffer", ":b <número>" },
					{ "Ver historial de comandos", "q:" },
					{ "Ver historial de búsqueda", "q/" },
				},

				["Otros"] = {
					{ "Eliminar resaltado de búsqueda", "<leader>e" },
					{ "Buffer Local Keymaps", "<leader>?" },
					{ "Opciones de Corrección", "<leader>c" },
					{ "Acciones de Código", "<leader>ca" },
					{ "Practicar con el teclado", ":Typr<CR>" },
					{ "Estadísticas del teclado", ":TyprStats<CR>" },
				},

				["Guardado"] = {
					{ "Guardar archivo", "<C-s>" },
					{ "Guardar y salir", "<S-s>" },
					{ "Guardar todos los archivos", "<A-s>" },
					{ "Guardar archivo", ":w<CR>" },
					{ "Guardar todo (buffers)", ":wa<CR>" },
					{ "Cerrar archivo", ":q<CR>" },
					{ "Cerrar sin guardar", ":q!<CR>" },
					{ "Guardar y salir", ":wq<CR>" },
					{ "Guardar todo y salir", ":wqa<CR>" },
				},

				["Cmp"] = {
					{ "Seleccionar sugerencia anterior", "<C-K>" },
					{ "Seleccionar sugerencia siguiente", "<C-j>" },
					{ "Scroll arriba en docs", "<C-b>" },
					{ "Scroll abajo en docs", "<C-f>" },
					{ "Mostrar sugerencias", "<C-Space>" },
					{ "Cerrar sugerencias", "<C-e>" },
					{ "Confirmar selección con Enter", "<CR>" },
					{ "Confirmar selección", "<C-y>" },
				},

				["Gitsigns"] = {
					{ "Abrir menú Hunk", "<leader>h" },
					{ "Stage hunk", "<leader>hs" },
					{ "Undo stage hunk", "<leader>hu" },
					{ "Reset hunk", "<leader>hr" },
					{ "Preview hunk", "<leader>hp" },
					{ "Blame line", "<leader>hb" },
				},

				["Telescope"] = {
					{ "Abrir menú Telescope", "<leader>f" },
					{ "Buscar Archivo", "<leader>ff" },
					{ "Buscar Texto", "<leader>fg" },
					{ "Ver Buffers", "<leader>fb" },
					{ "Buscar Ayuda", "<leader>fh" },
					{ "Archivos Recientes", "<leader>fr" },
					{ "Nuevo Archivo", "<leader>fn" },
				},

				["Goto Preview"] = {
					{ "Abrir menú Goto Preview", "<leader>g" },
					{ "Preview Definition", "<leader>gd" },
					{ "Preview Declaration", "<leader>gD" },
					{ "Preview Implementation", "<leader>gi" },
					{ "Preview References", "<leader>gr" },
					{ "Preview Type Definition", "<leader>gt" },
					{ "Close all preview windows", "<leader>gc" },
				},

				["LazyGit"] = {
					{ "Abrir LazyGit", "<leader>hg" },
				},

				["Spectre"] = {
					{ "Abrir Spectre", "<leader>s" },
					{ "Opciones para Renombrar", "<leader>r" },
					{ "Buscar palabra bajo el cursor", "<leader>rw" },
					{ "Buscar en archivo actual", "<leader>ra" },
					{ "Mostrar menú de opciones", "<leader>o" },
					{ "Mostrar atajos de teclados de Spectre", "?" },
				},

				["Ventanas"] = {
					{ "Opciones para ventanas", "<leader>w" },
					{ "División Horizontal", "<leader>wh" },
					{ "División Vertical", "<leader>wv" },
					{ "Cerrar ventana actual", "<leader>wd" },
				},

				["Terminales"] = {
					{ "Opciones para Terminales", "<leader>w" },
					{ "Terminal Flotante", "<leader>wf" },
					{ "Terminal Horizontal", "<leader>wh" },
					{ "Terminal Vertical", "<leader>wv" },
				},
			},
		},

		-- Atajo para el Cheatsheet
		vim.keymap.set("n", "<leader>a", function()
			require("nvcheatsheet").toggle()
		end, { desc = "󱓵 Abrir cheatsheet" }),

		-- Esquema de colores
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				-- Base Tokyonight colors
				local c = require("tokyonight.colors").setup({ style = "night" })

				-- Header del ASCII (nombre del proyecto u otro título visual)
				vim.api.nvim_set_hl(0, "NvChAsciiHeader", { fg = c.yellow, bg = "NONE", bold = true })

				-- Fondo de las secciones del cheatsheet
				vim.api.nvim_set_hl(0, "NvChSection", { bg = "#252535" })

				-- Colores de etiquetas
				vim.api.nvim_set_hl(0, "NvCheatsheetOrange", {
					fg = c.bg_dark,
					bg = c.orange,
					bold = false,
				})

				vim.api.nvim_set_hl(0, "NvCheatsheetCyan", {
					fg = c.bg_dark,
					bg = c.cyan,
					bold = false,
				})

				vim.api.nvim_set_hl(0, "NvCheatsheetRed", {
					fg = c.bg_dark,
					bg = c.red,
					bold = false,
				})

				vim.api.nvim_set_hl(0, "NvCheatsheetGreen", {
					fg = c.bg_dark,
					bg = c.green,
					bold = false,
				})

				vim.api.nvim_set_hl(0, "NvCheatsheetYellow", {
					fg = c.bg_dark,
					bg = c.yellow,
					bold = false,
				})

				vim.api.nvim_set_hl(0, "NvCheatsheetPurple", {
					fg = c.bg_dark,
					bg = c.magenta,
					bold = false,
				})

				vim.api.nvim_set_hl(0, "NvCheatsheetWhite", {
					fg = c.bg_dark,
					bg = c.blue,
					bold = false,
				})
			end,
		}),

		-- Plugin visual para manipular colores y modificar tonos dentro de Neovim.
		-- Se activa con los comandos `:Shades` y `:Huefy` para alterar esquemas de color.
		-- Permite experimentar con gradientes y armonías de color directamente en el editor.
		-- Útil para diseñadores o usuarios que crean sus propios colorescheme personalizados.
		-- Carga manual bajo demanda para evitar afectar el tiempo de arranque.
	},
	{
		"nvzone/minty",
		cmd = { "Shades", "Huefy" },
	},

	-- Proporciona un sistema de menús visuales para agrupar acciones frecuentes.
	-- Se carga perezosamente (`lazy = true`) y se activa mediante atajos personalizados.
	-- Permite definir múltiples menús como `default`, `lsp`, `gitsigns`, etc.
	-- Ideal para entornos sin ratón, ofreciendo navegación rápida con teclado.
	-- Muy útil para usuarios que organizan flujos de trabajo por categorías visuales.
	{
		"nvzone/menu",
		lazy = true,

		-- Atajo para abrir los diferentes menus
		vim.keymap.set("n", "<leader>md", function()
			require("menu").open("default", {
				border = true,
				mouse = false,
			})
		end, { desc = " Abrir menú default" }),

		vim.keymap.set("n", "<leader>ml", function()
			require("menu").open("lsp", {
				border = true,
				mouse = false,
			})
		end, { desc = " Abrir menú LSP" }),

		vim.keymap.set("n", "<leader>mg", function()
			require("menu").open("gitsigns", {
				border = true,
				mouse = false,
			})
		end, { desc = " Abrir menú Git" }),

		vim.keymap.set("n", "<leader>mn", function()
			require("menu").open("nvimtree", {
				border = true,
				mouse = false,
			})
		end, { desc = " Abrir menú nvimtree" }),

		-- Clonar: https://github.com/anonymous-17-03/menu
		-- Agregar -> novahacking.lua a -> ~/.local/share/nvim/lazy/menu/lua/menus
		vim.keymap.set("n", "<leader>mh", function()
			require("menu").open("novahacking", {
				border = true,
				mouse = false,
			})
		end, { desc = " Abrir menú NovaHacking" }),
	},
}
