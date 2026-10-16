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
}
