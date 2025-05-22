return {

	-- Editor: Ej. autopairs, treesitter, indent, mason
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
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
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
	{ "williamboman/mason-lspconfig.nvim" },
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
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		opts = function()
			return require("configs.nvim-cmp")
		end,
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,preview,noselect",
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
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
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
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
		ft = "rust",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
	{
		"mfussenegger/nvim-dap",
		--lldb is required for debuggin to work:
		--vim.keymap.set("n", "<leader>ds", vim.cmd.DapSidebar)
		config = function()
			vim.api.nvim_create_user_command("DapSidebar", function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end, {})
		end,
	},
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

	-- ui: Ej. noice, notify, tokyonight, dashboard, lualine, nvim-tree
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

	-- Terminal: Ej. toggleterm
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				shade_filetypes = {},
				shade_terminals = true,
				start_in_insert = true,
				persist_size = true,
				direction = "float",
				shell = "zsh",
				float_opts = {
					border = "rounded",
				},
				size = function(term)
					if term.direction == "horizontal" then
						return 17
					elseif term.direction == "vertical" then
						return 80
					end
					return 20
				end,
			})

			-- Mapeos para abrir terminales en diferentes direcciones
			-- Registro en which-key con íconos
			local wk = require("which-key")
			wk.register({
				["<leader>"] = {
					t = {
						name = " Terminal",
						f = { "<cmd>ToggleTerm direction=float<cr>", " Terminal Flotante" },
						v = { "<cmd>ToggleTerm direction=vertical<cr>", " Terminal Vertical" },
						h = { "<cmd>ToggleTerm direction=horizontal<cr>", " Terminal Horizontal" },
					},
				},
			})
		end,
	},

	-- Markdown: Ej. markdown-preview
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = "cd app && npm install",
		config = function()
			vim.g.mkdp_auto_start = 1
			vim.g.mkdp_open_to_the_world = 1
			vim.g.mkdp_port = "8888"
			vim.g.mkdp_browser = "google-chrome"
		end,
	},

	-- Git: Ej. gitsigns
	{
		"lewis6991/gitsigns.nvim",
		ft = { "gitcommit", "diff" },
		init = function()
			vim.api.nvim_create_autocmd({ "BufRead" }, {
				group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
				callback = function()
					vim.fn.jobstart({ "git", "-C", vim.loop.cwd(), "rev-parse" }, {
						on_exit = function(_, return_code)
							if return_code == 0 then
								vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
								vim.schedule(function()
									require("lazy").load({ plugins = { "gitsigns.nvim" } })
								end)
							end
						end,
					})
				end,
			})
		end,
		opts = function()
			return require("configs.others").gitsigns
		end,
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			return require("configs.telescope")
		end,
	},

	-- Keymaps: Ej. which-key
	{
		"folke/which-key.nvim",
		lazy = false,
		config = function()
			local wk = require("which-key")

			wk.setup({})
			wk.register({
				["<leader>"] = {
					n = { vim.cmd.NvimTreeFocus, " Enfocar NvimTree" },
					w = {
						name = " Ventana",
						s = { "<cmd>split<cr>", "󰯌 División Horizontal" },
						v = { "<cmd>vsplit<cr>", "󰯅 División Vertical" },
					},
					r = {
						name = "󰑕 Renombrar",
						v = { "<cmd>rv<cr>", " Renombrar Variable" },
					},
					c = {
						name = "󰛲 Corrección",
						a = { "<cmd>ca<cr>", " Acciones de Código" },
					},
				},
			})
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

	-- Rip Substitute
	{
		"chrisgrieser/nvim-rip-substitute",
		cmd = "RipSubstitute",
		opts = {},
		keys = {
			{
				"<leader>rs",
				function()
					require("rip-substitute").sub()
				end,
				mode = { "n", "x" },
				desc = " rip substitute",
			},
		},
	},
}
