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
		"koenverburg/peepsight.nvim",
		event = "BufReadPost",
		config = function()
			require("peepsight").setup({
				-- Go
				"function_declaration",
				"method_declaration",
				"func_literal",

				-- TypeScript / JS
				"class_declaration",
				"method_definition",
				"arrow_function",
				"function_declaration",
				"generator_function_declaration",

				-- Python
				"function_definition",
				"class_definition",
				"if_statement",
				"for_statement",
				"while_statement",

				-- Lua
				"function_declaration",
				"function_definition",
				"local_function",
				"do_statement",

				-- C/C++
				"function_definition",
				"compound_statement",

				-- Rust
				"function_item",
				"impl_item",

				-- Common
				"block",
			})
		end,
	},
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
			wk.register({
				["<leader>g"] = {
					name = "  Goto Preview",
					d = { gtp.goto_preview_definition, " Preview Definition" },
					D = { gtp.goto_preview_declaration, " Preview Declaration" },
					i = { gtp.goto_preview_implementation, "󰮲 Preview Implementation" },
					r = { gtp.goto_preview_references, " Preview References" },
					t = { gtp.goto_preview_type_definition, " Preview Type Definition" },
					c = { gtp.close_all_win, " Close all preview windows" },
				},
			}, { mode = "n" }) -- solo modo normal
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
					"astro",
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
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		config = function()
			require("glow").setup({
				border = "rounded",
				width = 100,
				height = 80,
				style = "dark",
				pager = false,
			})
		end,
	},
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end, -- <- más confiable que el cd && npm
		config = function()
			vim.g.mkdp_auto_start = 1
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_open_to_the_world = 1
			vim.g.mkdp_port = "8888"
			vim.g.mkdp_browser = "firefox" -- asegúrate que este sea el nombre exacto del navegador
			vim.g.mkdp_echo_preview_url = 1
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
	{
		"kdheepak/lazygit.nvim",
		lazy = false,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		-- Atajo de teclado
		keys = {
			{ "<leader>hg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		config = function()
			require("telescope").load_extension("lazygit")
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
					n = { "<cmd>NvimTreeFocus<cr>", " Enfocar NvimTree" },
					w = {
						name = " Ventana",
						h = { "<cmd>split<cr>", " División Horizontal" },
						v = { "<cmd>vsplit<cr>", " División Vertical" },
					},
					r = {
						name = "󰑕 Renombrar",
						v = { "<cmd>rv<cr>", " Renombrar Variable" },
					},
					c = {
						name = "󰯅 Corrección",
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
		config = function()
			-- Función auxiliar por si no tienes `getBorder()` definido
			local function getBorder()
				if vim.fn.has("nvim-0.11") == 1 then
					return vim.o.winborder
				else
					return "rounded"
				end
			end

			require("rip-substitute").setup({
				popupWin = {
					title = " rip-substitute",
					border = getBorder(),
					matchCountHlGroup = "Keyword",
					noMatchHlGroup = "ErrorMsg",
					position = "bottom",
					hideSearchReplaceLabels = false,
					hideKeymapHints = false,
					disableCompletions = true,
				},
				prefill = {
					normal = "cursorWord",
					visual = "selection",
					startInReplaceLineIfPrefill = false,
					alsoPrefillReplaceLine = false,
				},
				keymaps = {
					abort = "q",
					confirm = "<CR>",
					insertModeConfirm = "<C-CR>",
					prevSubstitutionInHistory = "<Up>",
					nextSubstitutionInHistory = "<Down>",
					toggleFixedStrings = "<C-f>",
					toggleIgnoreCase = "<C-c>",
					openAtRegex101 = "R",
					showHelp = "?",
				},
				incrementalPreview = {
					matchHlGroup = "IncSearch",
					rangeBackdrop = {
						enabled = true,
						blend = 50,
					},
				},
				regexOptions = {
					startWithFixedStringsOn = false,
					startWithIgnoreCase = false,
					pcre2 = false, -- Temporal | false
					autoBraceSimpleCaptureGroups = true,
				},
				editingBehavior = {
					autoCaptureGroups = false,
				},
				notification = {
					onSuccess = true,
					icon = "",
				},
				debug = true,
			})
		end,
	},
}
