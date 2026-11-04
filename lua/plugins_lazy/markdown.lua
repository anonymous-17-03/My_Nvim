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
}
