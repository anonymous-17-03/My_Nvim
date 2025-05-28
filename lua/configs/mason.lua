return {
	ui = {
		border = "rounded", -- requerido para activar los siguientes caracteres
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	-- Lenguajes y herramientas que Mason debe instalar automáticamente
	ensure_installed = {
		"lua-language-server", -- LSP para Lua
		"stylua", -- Formateador para Lua
		"rust-analyzer", -- LSP para Rust
		"pyright", -- LSP para Python
		"clangd", -- LSP para C y C++
		"prettier", -- Formateador para JavaScript, TypeScript, HTML, CSS, JSON, Markdown
		"rustfmt", -- Formateador para Rust
		"black", -- Formateador para Python
		"isort", -- Organizador de imports para Python
		"typescript-language-server", -- LSP para TypeScript y JavaScript
		"svelte-language-server", -- LSP para Svelte
		"codelldb", -- Depurador para C y C++
		"debugpy", -- Depurador para Python
		"bash-language-server", -- LSP para Bash
		"shfmt", -- Formateador para Bash
		"astro-language-server", -- LSP para Astro (framework frontend)
		"html-lsp", -- LSP para HTML
		"intelephense", -- LSP para PHP
		"php-cs-fixer", -- Formateador para PHP
	},
	max_concurrent_installers = 7, -- Límite de instalaciones simultáneas
}
