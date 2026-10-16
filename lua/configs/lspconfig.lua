-- Neovim 0.12: nvim-lspconfig aporta definiciones; Neovim activa los clientes.
local servers = {
	"pyright",
	"lua_ls",
	"ts_ls",
	"svelte",
	"bashls",
	"clangd",
	"astro",
	"gopls",
	"rust_analyzer",
	"html",
	"intelephense",
}
vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
		},
	},
})
vim.lsp.config("intelephense", {
	root_dir = function(bufnr, on_dir)
		local name = vim.api.nvim_buf_get_name(bufnr)
		on_dir(
			vim.fs.root(bufnr, { "composer.json", ".git" }) or (name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd())
		)
	end,
})
-- Un único responsable de activar LSP: la lista explícita inferior.
require("mason-lspconfig").setup({ automatic_enable = false })
vim.lsp.enable(servers)

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "always" },
})
vim.o.updatetime = 500
local group = vim.api.nvim_create_augroup("NovaLsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
	end,
})
vim.api.nvim_create_autocmd("CursorHold", {
	group = group,
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			scope = "line",
			prefix = "",
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
		})
	end,
})

-- =========================================================
-- WHICH-KEY
-- =========================================================

local wk = require("which-key")

-- =========================================================
-- Mapeos LSP
-- =========================================================

wk.add({

	-- -------------------------------------------------------
	-- Globales
	-- -------------------------------------------------------

	{
		"<space>q",
		vim.diagnostic.setloclist,
		desc = " Mostrar lista de diagnósticos",
	},

	{
		"[d",
		function()
			vim.diagnostic.jump({ count = -1, float = true })
		end,
		desc = " Ir al error anterior",
	},

	{
		"]d",
		function()
			vim.diagnostic.jump({ count = 1, float = true })
		end,
		desc = " Ir al siguiente error",
	},

	-- -------------------------------------------------------
	-- Grupo general LSP
	-- -------------------------------------------------------

	{
		"<leader>l",
		group = "  LSP",
	},

	-- -------------------------------------------------------
	-- Subgrupo: Ir a
	-- -------------------------------------------------------

	{
		"<leader>lg",
		group = " Ir a",
	},

	{
		"<leader>lgD",
		vim.lsp.buf.declaration,
		desc = " Ir a declaración",
	},

	{
		"<leader>lgd",
		vim.lsp.buf.definition,
		desc = " Ir a definición",
	},

	{
		"<leader>lgi",
		vim.lsp.buf.implementation,
		desc = " Ir a implementación",
	},

	{
		"<leader>lgr",
		vim.lsp.buf.references,
		desc = " Ver referencias",
	},

	-- -------------------------------------------------------
	-- Acciones generales
	-- -------------------------------------------------------

	{
		"<leader>lh",
		vim.lsp.buf.hover,
		desc = "󰘥 Mostrar documentación",
	},

	{
		"<leader>ls",
		vim.lsp.buf.signature_help,
		desc = "󰘥 Ayuda de firma",
	},

	{
		"<leader>lD",
		vim.lsp.buf.type_definition,
		desc = " Ver tipo de definición",
	},

	{
		"<leader>lr",
		vim.lsp.buf.rename,
		desc = " Renombrar símbolo",
	},

	{
		"<leader>la",
		vim.lsp.buf.code_action,
		desc = " Acción de código",
	},

	-- -------------------------------------------------------
	-- Formatear buffer
	-- -------------------------------------------------------

	{
		"<leader>lf",

		function()
			require("conform").format({
				lsp_format = "fallback",
				async = true,
			})
		end,

		desc = " Formatear buffer",
	},

	-- -------------------------------------------------------
	-- Workspace
	-- -------------------------------------------------------

	{
		"<leader>lw",
		group = "󱂬 Workspace",
	},

	{
		"<leader>lwa",
		vim.lsp.buf.add_workspace_folder,
		desc = "[+] Agregar carpeta al espacio de trabajo",
	},

	{
		"<leader>lwr",
		vim.lsp.buf.remove_workspace_folder,
		desc = "[-] Eliminar carpeta del espacio de trabajo",
	},

	{
		"<leader>lwl",

		function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end,

		desc = "{.} Listar carpetas del espacio de trabajo",
	},

	-- -------------------------------------------------------
	-- Información del LSP
	-- -------------------------------------------------------

	{
		"<leader>li",

		function()
			vim.cmd("checkhealth vim.lsp")
		end,

		desc = "󰒓 Ver información de LSP",
	},
}, {
	mode = "n",
})
