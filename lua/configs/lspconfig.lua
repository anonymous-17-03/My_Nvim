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

-- Atajos globales
wk.register({
	["<space>m"] = { vim.diagnostic.open_float, " Mostrar error flotante" },
	["<space>q"] = { vim.diagnostic.setloclist, " Mostrar lista de diagnósticos" },
	["[d"] = { vim.diagnostic.goto_prev, " Ir al error anterior" },
	["]d"] = { vim.diagnostic.goto_next, " Ir al siguiente error" },
}, { mode = "n" }) -- modo normal

-- Atajos agrupados bajo <leader>l para LSP
wk.register({
	["<leader>l"] = {
		name = "  LSP",

		g = {
			name = " Ir a",
			D = { vim.lsp.buf.declaration, " Ir a declaración" },
			d = { vim.lsp.buf.definition, " Ir a definición" },
			i = { vim.lsp.buf.implementation, " Ir a implementación" },
			r = { vim.lsp.buf.references, " Ver referencias" },
		},

		h = { vim.lsp.buf.hover, "󰘥 Mostrar documentación" },
		s = { vim.lsp.buf.signature_help, "󰘥 Ayuda de firma" },
		D = { vim.lsp.buf.type_definition, " Ver tipo de definición" },
		r = { vim.lsp.buf.rename, " Renombrar símbolo" },
		a = { vim.lsp.buf.code_action, " Acción de código" },
		f = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			" Formatear buffer",
		},

		w = {
			name = "󱂬 Workspace",
			a = {
				vim.lsp.buf.add_workspace_folder,
				"[+] Agregar carpeta al espacio de trabajo",
			},
			r = {
				vim.lsp.buf.remove_workspace_folder,
				"[-] Eliminar carpeta del espacio de trabajo",
			},
			l = {
				function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				"{.} Listar carpetas del espacio de trabajo",
			},
		},
	},
})
