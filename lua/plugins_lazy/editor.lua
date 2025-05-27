return {
	-- Autocompleta paréntesis, llaves, corchetes, etc., automáticamente.
	-- Usa Treesitter para mejorar el comportamiento según el contexto del lenguaje.
	-- Permite desactivar en ciertos lenguajes (ej. Java, strings en Lua/JS).
	-- Configuración mínima y directa.
	-- Mejora la experiencia de escritura de código.
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- Usa árboles de sintaxis para una mejor detección
				ts_config = {
					lua = { "string" }, -- Deshabilitar para estructuras de cadenas en Lua
					javascript = { "template_string" }, -- Deshabilitar para plantillas de cadenas en JavaScript
					java = false, -- Deshabilitar completamente en Java
				},
			})
		end,
	},

	-- Abre vistas previas flotantes de definiciones, declaraciones, referencias, etc.
	-- Usa Telescope para mostrar referencias en modo dropdown.
	-- Atajos definidos con <leader>g* para navegación rápida.
	-- Integrado con which-key para mostrar los atajos.
	-- Muy útil para navegar código sin perder el contexto del archivo actual.
	{
		"rmagatti/goto-preview",
		dependencies = {
			"rmagatti/logger.nvim",
			"folke/which-key.nvim", -- para mostrar los atajos en pantalla
		},
		event = "BufEnter",
		config = function()
			-- Setup de goto-preview
			require("goto-preview").setup({
				width = 120,
				height = 25,
				border = "rounded", -- Bordes bonitos
				resizing_mappings = false,
				debug = false,
				opacity = nil,
				post_open_hook = nil,
				post_close_hook = nil,
				references = {
					telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
				},
			})

			-- Setup de which-key
			local wk = require("which-key")
			local gtp = require("goto-preview")

			wk.add({
				-- Grupo principal: Goto Preview
				{ "<leader>g", group = "  Goto Preview" },

				-- Mapeos individuales
				{ "<leader>gd", gtp.goto_preview_definition, desc = " Preview Definition" },
				{ "<leader>gD", gtp.goto_preview_declaration, desc = " Preview Declaration" },
				{ "<leader>gi", gtp.goto_preview_implementation, desc = "󰮲 Preview Implementation" },
				{ "<leader>gr", gtp.goto_preview_references, desc = " Preview References" },
				{ "<leader>gt", gtp.goto_preview_type_definition, desc = " Preview Type Definition" },
				{ "<leader>gc", gtp.close_all_win, desc = " Close all preview windows" },
			}, { mode = "n" }) -- solo modo normal
		end,
	},

	-- Proporciona resaltado de sintaxis avanzado y árbol de sintaxis por lenguaje.
	-- Permite indentación inteligente y mejoras visuales en muchos lenguajes.
	-- Se instala automáticamente para varios lenguajes comunes.
	-- Puede expandirse fácilmente con plugins relacionados.
	-- Mejora la precisión en resaltado comparado con regex tradicional.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vim",
					"lua",
					"vimdoc",
					"html",
					"css",
					"javascript",
					"typescript",
					"tsx",
					"c",
					"rust",
					"svelte",
					"cpp",
					"python",
					"yaml",
					"json",
					"astro",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Muestra el contexto del código (como la función actual) fijado en la parte superior.
	-- Actualmente deshabilitado (enabled = false).
	-- Ideal para no perder de vista en qué clase/función estás.
	-- Se integra con treesitter.
	-- Requiere poca configuración.
	{
		"nvim-treesitter/nvim-treesitter-context",
		-- config = function()
		-- 	require("treesitter-context").setup({})
		-- end,
		enabled = false,
	},

	-- Dibuja guías de indentación para mejorar legibilidad del código.
	-- Se excluyen ciertos tipos de archivos (ej. NvimTree, help).
	-- Usa el módulo ibl para configuración limpia.
	-- Mejora la estructura visual de bloques de código.
	-- Compatible con Treesitter y otros plugins.
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					"help",
					"startify",
					"dashboard",
					"packer",
					"neogitstatus",
					"NvimTree",
					"Trouble",
				},
			},
		},
	},

	-- Administra binarios LSP, DAP y herramientas de formato/linting.
	-- Se integra con mason-lspconfig y lspconfig.
	-- Comandos personalizados para instalar múltiples herramientas a la vez.
	-- Define lista de herramientas requeridas (ensure_installed).
	-- Facilita configuración de entornos de desarrollo.
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate", "MasonUninstallAll" },
		opts = function()
			return require("configs.mason")
		end,
		config = function(_, opts)
			require("mason").setup(opts)
			vim.api.nvim_create_user_command("MasonInstallAll", function()
				if opts.ensure_installed and #opts.ensure_installed > 0 then
					vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
				end
			end, {})
			vim.g.mason_binaries_list = opts.ensure_installed
		end,
	},

	-- Puente entre mason.nvim y lspconfig.
	-- Asegura que Mason maneje los servidores LSP correctamente.
	-- Sin configuración directa aquí (usa la de Mason y LSPConfig).
	-- Muy útil para instalación automática de LSPs.
	-- Simplifica la conexión entre instalación y configuración.
	{
		"williamboman/mason-lspconfig.nvim",
	},

	-- Configura y activa los servidores de lenguaje (LSP).
	-- Depende de Mason para la instalación de LSPs.
	-- Carga configuración externa desde configs.lspconfig.
	-- Es el núcleo del soporte LSP en Neovim.
	-- Base esencial para autocompletado, diagnósticos, etc.
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			require("configs.lspconfig")
		end,
	},

	-- Autocompletado inteligente y extensible.
	-- Integra múltiples fuentes: LSP, buffer, path, snippets, etc.
	-- Usa lspkind para íconos y formato visual atractivo.
	-- Mapeos para navegar sugerencias y confirmar selección.
	-- Incluye integración con snippets (LuaSnip) y Treesitter.
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy", -- InsertEnter, VeryLazy
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-git",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"ray-x/cmp-treesitter",
			"hrsh7th/cmp-calc",
		},
		opts = function()
			return require("configs.nvim-cmp")
		end,
		config = function()
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
		end,
	},

	-- Agrega íconos visuales al autocompletado del LSP (nvim-cmp, etc).
	-- Facilita identificar rápidamente el tipo de sugerencia (función, variable, clase, etc).
	-- Totalmente integrado con `nvim-cmp` y otros motores de completado.
	-- No requiere configuración por defecto, pero puede personalizarse.
	-- Mejora la estética y usabilidad del sistema de autocompletado.
	{
		"onsails/lspkind.nvim",
	},

	-- Formateo automático y flexible al guardar archivos.
	-- Compatible con múltiples lenguajes y herramientas externas (prettier, black, shfmt, etc).
	-- Se integra con `mason.nvim` para instalar y configurar formatters fácilmente.
	-- Usa un archivo personalizado en `lua/configs/formating.lua` para definir qué formateadores usar por archivo o tipo.
	-- Se carga al abrir o crear un buffer, lo cual mejora el tiempo de arranque.
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return require("configs.formating")
		end,
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},

	-- Soporte oficial para Rust en Vim/Neovim.
	-- Incluye integración con `rustfmt` para formateo automático de código Rust.
	-- También añade resaltado de sintaxis mejorado y comandos específicos de Rust.
	-- Se activa automáticamente solo al abrir archivos `.rs`.
	-- Permite configurar `rustfmt_autosave = 1` para formatear al guardar.
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},

	-- Cliente LSP especializado para Rust basado en `rust-analyzer`.
	-- Reemplaza configuraciones manuales y ofrece integración avanzada con herramientas del ecosistema Rust.
	-- Provee asistencia contextual, navegación entre archivos, documentación y más.
	-- Compatible con `nvim-lspconfig`, lo que permite extender la configuración global del LSP.
	-- Se recomienda usar versión ^4 (estable).
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
		ft = "rust",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},

	-- Proporciona un sistema de debugging (depuración) interactivo en Neovim.
	-- Compatible con múltiples lenguajes mediante adaptadores DAP (como lldb, debugpy, etc).
	-- Permite establecer breakpoints, inspeccionar variables, ejecutar paso a paso.
	-- Incluye widgets visuales (como scopes, pilas de llamadas, etc) para depurar con interfaz dentro de Neovim.
	-- Aquí se define un comando personalizado `:DapSidebar` para abrir la vista lateral de scopes.
	{
		"mfussenegger/nvim-dap",
		--lldb is required for debuggin to work:
		config = function()
			vim.api.nvim_create_user_command("DapSidebar", function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end, {})
		end,
	},

	-- Extensión de `nvim-dap` para depurar programas en Python usando `debugpy`.
	-- Permite debugging completo: breakpoints, inspección de variables, ejecución paso a paso.
	-- Se carga automáticamente en archivos Python.
	-- Usa la ruta del entorno virtual instalado por `mason.nvim` para `debugpy`.
	-- Integración fluida con `nvim-dap` sin configuración compleja.
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
		end,
	},
}
