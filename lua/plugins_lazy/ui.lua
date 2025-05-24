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
				{ "<leader>rv", "<cmd>rv<cr>", desc = " Renombrar Variable" },

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
}
