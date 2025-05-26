return {
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
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
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
	{
		"echasnovski/mini.icons",
		version = "*",
	},
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
			wk.setup({})

			wk.add({
				{ "<leader>c", group = "󰯅 Corrección" },
				{ "<leader>ca", "<cmd>ca<cr>", desc = " Acciones de Código" },

				{ "<leader>r", group = "󰑕 Renombrar" },

				{ "<leader>w", group = " Ventana" },
				{ "<leader>wh", "<cmd>split<cr>", desc = " División Horizontal" },
				{ "<leader>wv", "<cmd>vsplit<cr>", desc = " División Vertical" },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			return require("configs.telescope")
		end,
	},

	-- Themes: Ej. tokyonight
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
	{
		"stevearc/oil.nvim",
		cmd = "Oil", -- Carga perezosa al usar el comando :Oil
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "󱥇 Open Oil File Explorer" },
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
					{ "Toggle oil (closes without saving)", "<leader>q" },
					{ "Select entry", "⏎" },
					{ "Select entry", "l" },
					{ "Go to parent", "h" },
					{ "Open vertical split", "⌃v" },
					{ "Open horizontal split", "⌃x" },
					{ "Go to current working directory", "." },
				},
				["Cmp"] = {
					{ "Select entry", "⌃f" },
					{ "Next result - Jump to next snippet placeholder", "⌃n" },
					{ "Previous result - Jump to previous snippet placeholder", "⌃p" },
					{ "Scroll up in preview", "⌃u" },
					{ "Scroll down in preview", "⌃d" },
					{ "Abort autocompletion", "⌃e" },
				},
				["Comment"] = {
					{ "Comment line toggle", "gcc" },
					{ "Comment block toggle", "gbc" },
					{ "Comment visual selection", "gc" },
					{ "Comment visual selection using block delimiters", "gb" },
					{ "Comment out text object line wise", "gc<motion>" },
					{ "Comment out text object block wise", "gb<motion>" },
					{ "Add comment on the line above", "gcO" },
					{ "Add comment on the line below", "gco" },
					{ "Add comment at the end of line", "gcA" },
				},
				["Navegación"] = {
					{ "Ir al principio", "gg" },
					{ "Ir al final", "G" },
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
	},
	{
		"nvzone/minty",
		cmd = { "Shades", "Huefy" },
	},
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
