local lspconfig = require("lspconfig") -- Importa configuración para servidores LSP

-- Ejecutar al adjuntar LSP a un buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Habilita autocompletado con <C-x><C-o>
	end,
})

-- Configuración de servidores LSP
lspconfig.pyright.setup({}) -- Python
lspconfig.lua_ls.setup({}) -- Lua
-- lspconfig.tsserver.setup({}) -> Deprecated
lspconfig.ts_ls.setup({}) -- TypeScript
lspconfig.svelte.setup({}) -- Svelte
lspconfig.bashls.setup({}) -- Bash

-- Registro en which-key
local wk = require("which-key")

-- Mapeos en modo normal
wk.add({
	-- Globales
	{ "<space>q", vim.diagnostic.setloclist, desc = " Mostrar lista de diagnósticos" },
	{ "[d", vim.diagnostic.goto_prev, desc = " Ir al error anterior" },
	{ "]d", vim.diagnostic.goto_next, desc = " Ir al siguiente error" },

	-- Grupo general LSP
	{ "<leader>l", group = "  LSP" },

	-- Subgrupo: Ir a
	{ "<leader>lg", group = " Ir a" },
	{ "<leader>lgD", vim.lsp.buf.declaration, desc = " Ir a declaración" },
	{ "<leader>lgd", vim.lsp.buf.definition, desc = " Ir a definición" },
	{ "<leader>lgi", vim.lsp.buf.implementation, desc = " Ir a implementación" },
	{ "<leader>lgr", vim.lsp.buf.references, desc = " Ver referencias" },

	-- Acciones generales
	{ "<leader>lh", vim.lsp.buf.hover, desc = "󰘥 Mostrar documentación" },
	{ "<leader>ls", vim.lsp.buf.signature_help, desc = "󰘥 Ayuda de firma" },
	{ "<leader>lD", vim.lsp.buf.type_definition, desc = " Ver tipo de definición" },
	{ "<leader>lr", vim.lsp.buf.rename, desc = " Renombrar símbolo" },
	{ "<leader>la", vim.lsp.buf.code_action, desc = " Acción de código" },

	{
		"<leader>lf",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		desc = " Formatear buffer",
	},

	-- Subgrupo: Workspace
	{ "<leader>lw", group = "󱂬 Workspace" },
	{ "<leader>lwa", vim.lsp.buf.add_workspace_folder, desc = "[+] Agregar carpeta al espacio de trabajo" },
	{ "<leader>lwr", vim.lsp.buf.remove_workspace_folder, desc = "[-] Eliminar carpeta del espacio de trabajo" },
	{
		"<leader>lwl",
		function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end,
		desc = "{.} Listar carpetas del espacio de trabajo",
	},
}, { mode = "n" }) -- modo normal
