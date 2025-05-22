-- formating.lua
-- Configuración de herramientas de formateo de código para múltiples lenguajes.
-- Fuente de referencia: https://www.josean.com/posts/neovim-linting-and-formatting

return {
	-- Tabla que define qué formateadores usar por tipo de archivo
	formatters_by_ft = {
		-- Web
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		graphql = { "prettier" },
		markdown = { "prettier" },

		-- Lua
		lua = { "stylua" },

		-- Python
		python = { "isort", "black" }, -- isort ordena imports, black formatea el resto

		-- Rust
		rust = { "rustfmt" },
	},

	-- Configuración para el autoformateo al guardar archivos
	format_on_save = {
		lsp_fallback = true, -- Si el LSP no tiene formateo, usar el formateador externo
		async = false, -- Formateo síncrono (espera a que termine antes de continuar)
		timeout_ms = 500, -- Tiempo máximo para el formateo
	},
}
