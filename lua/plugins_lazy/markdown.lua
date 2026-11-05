return {
	-- Renderiza archivos Markdown directamente en Neovim con estilo elegante.
	-- Usa Glow (escrito en Go) como backend para el renderizado.
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
	-- Render Markdown: Renderizado visual de Markdown directamente
	-- en el buffer de Neovim, sin necesidad de abrir un navegador.
	-- Decora encabezados, listas, tablas, bloques de código y otros elementos.
	{
		"MeanderingProgrammer/render-markdown.nvim",

		-- Cargar al abrir un archivo Markdown.
		ft = { "markdown" },

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},

		opts = {
			enabled = true,

			-- Presentación decorada en modo normal y comandos.
			render_modes = { "n", "c" },

			-- Mantener la decoración en la línea del cursor.
			anti_conceal = {
				enabled = false,
			},

			win_options = {
				conceallevel = {
					default = vim.o.conceallevel,
					rendered = 3,
				},
				concealcursor = {
					default = vim.o.concealcursor,
					rendered = "nc",
				},
			},
		},
	},
	-- Markdown Preview: Previsualización de documentos Markdown
	-- en el navegador mediante un servidor local.
	-- Permite visualizar el resultado final con estilos HTML y CSS.
	{
		"iamcco/markdown-preview.nvim",

		cmd = {
			"MarkdownPreview",
			"MarkdownPreviewStop",
			"MarkdownPreviewToggle",
		},

		ft = { "markdown" },

		-- Instalar mediante Vimscript.
		build = ":call mkdp#util#install()",

		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_browser = ""
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_refresh_slow = 0
			vim.g.mkdp_theme = "dark"
		end,

		keys = {
			{
				"<leader>mp",
				"<cmd>MarkdownPreviewToggle<CR>",
				ft = "markdown",
				desc = "Alternar previsualización Markdown",
			},
		},
	},
}
