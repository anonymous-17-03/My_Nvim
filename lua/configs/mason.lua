local M = {}
-- Ejecuta :MasonInstallAll cuando quieras instalar las herramientas de esta lista.
-- rustfmt pertenece al toolchain de Rust, no al registro de Mason.
M.tools = {
	"lua-language-server",
	"stylua",
	"rust-analyzer",
	"pyright",
	"clangd",
	"prettier",
	"black",
	"isort",
	"typescript-language-server",
	"svelte-language-server",
	"codelldb",
	"debugpy",
	"bash-language-server",
	"shfmt",
	"astro-language-server",
	"html-lsp",
	"intelephense",
	"php-cs-fixer",
	"gopls",
	"gofumpt",
	"goimports",
}
function M.setup()
	require("mason").setup({
		ui = {
			border = "rounded",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		max_concurrent_installers = 7,
	})
	vim.api.nvim_create_user_command("MasonInstallAll", function()
		vim.cmd("MasonInstall " .. table.concat(M.tools, " "))
	end, { desc = "Instalar herramientas de NovaHacking" })
end
return M
