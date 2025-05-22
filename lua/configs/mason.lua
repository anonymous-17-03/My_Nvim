return {
	ensure_installed = {
		-- Lenguajes y herramientas que Mason debe instalar automáticamente
		"lua-language-server",
		"stylua", -- formateador Lua
		"rust-analyzer",
		"pyright",
		"clangd",
		"prettier", -- formateador JS/HTML/CSS
		"rustfmt", -- formateador Rust
		"black", -- formateador Python
		"isort", -- organizador de imports Python
		"typescript-language-server",
		"svelte-language-server",
		"codelldb", -- depurador para C/C++
		"debugpy", -- depurador para Python
		"bash-language-server",
	},
	max_concurrent_installers = 15, -- Límite de instalaciones simultáneas
}
