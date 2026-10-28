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
		php = { "php_cs_fixer" },

		-- Lua
		lua = { "stylua" },

		-- Python
		python = { "isort", "black" }, -- isort ordena imports, black formatea el resto

		-- Rust
		rust = { "rustfmt" },

		-- Bash
		bash = { "shfmt" },
		sh = { "shfmt" },

		-- Go
		go = { "gofumpt", "goimports" },
	},

	-- Configuración para el autoformateo al guardar archivos
	format_on_save = function(bufnr)
		-- Si desactivaste el formato para este buffer,
		-- Conform no formateará automáticamente al guardar.
		if vim.b[bufnr].nova_disable_autoformat then
			return
		end

		-- En los demás casos, conserva el comportamiento habitual.
		return {
			lsp_format = "fallback", -- Usar LSP solo si no hay formateador externo disponible
			timeout_ms = 1000, -- Tiempo máximo para el formateo
		}
	end,
}
