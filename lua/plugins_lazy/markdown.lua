return {
	-- Renderiza archivos Markdown directamente en Neovim con estilo elegante.
	-- Usa Glow (escrito en Go) como backend para el renderizado.
	-- Se ejecuta con el comando `:Glow`, mostrando el resultado en una ventana flotante.
	-- Personalizable: altura, anchura, borde y modo oscuro.
	-- Ideal para lectura rápida sin salir del editor.
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

	-- Previsualiza archivos Markdown en el navegador usando Deno.
	-- Comandos personalizados `:PeekOpen` y `:PeekClose` para control manual.
	-- Se construye con Deno (`build:fast`) para una carga rápida.
	-- Muy ligero: carga en `VeryLazy` y sin dependencias externas en Neovim.
	-- Útil para edición y vista previa HTML/CSS de Markdown en tiempo real.
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

	-- Previsualiza Markdown en el navegador con soporte interactivo.
	-- Se activa automáticamente al abrir archivos `.md`, y cierra al salir.
	-- Configurable: puerto, navegador, visibilidad externa y URL en consola.
	-- Usa una pequeña webapp como servidor local para renderizar Markdown.
	-- Requiere una instalación inicial (`vim.fn["mkdp#util#install"]()`).
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end, -- Más confiable que el cd && npm
		config = function()
			vim.g.mkdp_auto_start = 1
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_open_to_the_world = 1
			vim.g.mkdp_port = "8888"
			vim.g.mkdp_browser = "firefox" -- Asegúrate que este sea el nombre exacto del navegador
			vim.g.mkdp_echo_preview_url = 1
		end,
	},
}
