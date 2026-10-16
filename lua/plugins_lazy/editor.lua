return {
	-- Autocompleta paréntesis, llaves, corchetes, etc., automáticamente.
	-- Usa Treesitter para mejorar el comportamiento según el contexto del lenguaje.
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
	{
		"rmagatti/goto-preview",
		dependencies = {
			"rmagatti/logger.nvim",
			"nvim-telescope/telescope.nvim",
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

	-- API de la rama main; los parsers se instalan explícitamente.
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("configs.treesitter")
		end,
	},

	{
		"mason-org/mason.nvim",
		lazy = false,
		config = function()
			require("configs.mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("configs.lspconfig")
		end,
	},

	-- Autocompletado inteligente y extensible.
	-- Integra múltiples fuentes: LSP, buffer, path, snippets, etc.
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy", -- InsertEnter, VeryLazy
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"windwp/nvim-autopairs",
			"hrsh7th/cmp-calc",
			"ray-x/cmp-treesitter",
		},
		config = function()
			return require("configs.nvim-cmp")
		end,
	},

	-- Agrega íconos visuales al autocompletado del LSP (nvim-cmp, etc).
	-- Facilita identificar rápidamente el tipo de sugerencia (función, variable, clase, etc).
	{
		"onsails/lspkind.nvim",
	},

	-- Formateo automático y flexible al guardar archivos.
	-- Compatible con múltiples lenguajes y herramientas externas (prettier, black, shfmt, etc).
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return require("configs.formatting")
		end,
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},

	-- Mantiene los comandos Rust; Conform es el único encargado de formatear al guardar.
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 0
		end,
	},

	-- Proporciona un sistema de debugging (depuración) interactivo en Neovim.
	-- Compatible con múltiples lenguajes mediante adaptadores DAP (como lldb, debugpy, etc).
	{
		"mfussenegger/nvim-dap",
		--lldb is required for debuggin to work:
		config = function()
			require("configs.dap")
			vim.api.nvim_create_user_command("DapSidebar", function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end, {})
		end,
	},

	-- Extensión de `nvim-dap` para depurar programas en Python usando `debugpy`.
	-- Permite debugging completo: breakpoints, inspección de variables, ejecución paso a paso.
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			if vim.fn.executable(path) ~= 1 then
				vim.notify("Instala debugpy con :MasonInstall debugpy", vim.log.levels.WARN)
				return
			end
			require("dap-python").setup(path)
		end,
	},
}
