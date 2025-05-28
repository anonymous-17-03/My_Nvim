local lspconfig = require("lspconfig") -- Importa configuración para servidores LSP

-- Bordes redondeados para todas las ventanas flotantes de LSP
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- ejecutar al adjuntar LSP a un buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Habilita autocompletado con <C-x><C-o>
	end,
})

vim.diagnostic.config({
	virtual_text = false, -- Desactiva el texto virtual al lado del código
	virtual_lines = false, -- Desactiva líneas virtuales (si lo usas)
	signs = true, -- Puedes dejar los signos (en el margen)
	underline = true, -- Subrayado del código con errores
	update_in_insert = false, -- No actualizar diagnósticos en modo Insert
	severity_sort = true, -- Ordenar severidad (Error > Warn > Info > Hint)
})

vim.o.updatetime = 500

-- muestra diagnósticos flotantes al detener el cursor
vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = "",
			scope = "line",
		})
	end,
})

-- Configuración de servidores LSP
lspconfig.pyright.setup({}) -- Python
lspconfig.lua_ls.setup({}) -- Lua
lspconfig.ts_ls.setup({}) -- TypeScript
lspconfig.svelte.setup({}) -- Svelte
lspconfig.bashls.setup({}) -- Bash
lspconfig.clangd.setup({}) -- C y C++
lspconfig.astro.setup({}) -- Astro

local util = require("lspconfig.util")
lspconfig.rust_analyzer.setup({
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = function(fname)
		-- 1. Buscar carpeta con Cargo.toml
		local cargo_crate_dir = util.root_pattern("Cargo.toml")(fname)

		-- 2. Ejecutar `cargo metadata` para obtener workspace_root
		local cargo_workspace_dir = nil
		if cargo_crate_dir then
			local manifest_path = util.path.join(cargo_crate_dir, "Cargo.toml")
			local cmd = { "cargo", "metadata", "--no-deps", "--format-version", "1", "--manifest-path", manifest_path }

			-- Ejecutar comando de forma segura
			local cargo_metadata = vim.fn.system(cmd)
			if vim.v.shell_error == 0 then
				local ok, decoded = pcall(vim.fn.json_decode, vim.fn.trim(cargo_metadata))
				if ok and decoded and decoded["workspace_root"] then
					cargo_workspace_dir = decoded["workspace_root"]
				end
			end
		end

		-- 3. Retornar raíz válida o buscar alternativas
		return cargo_workspace_dir
			or cargo_crate_dir
			or util.root_pattern("rust-project.json")(fname)
			or util.find_git_ancestor(fname)
			or vim.fn.getcwd() -- último recurso
	end,

	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true, -- si usas features opcionales
			},
		},
	},
}) -- Rust

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup({
	capabilities = capabilities,
}) -- html

local util = require("lspconfig.util")
lspconfig.intelephense.setup({
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_dir = function(pattern)
		local cwd = vim.loop.cwd()
		local root = util.root_pattern("composer.json", ".git")(pattern)

		-- Si no se encuentra root, usar el directorio actual
		if not root then
			root = cwd
		end

		-- Preferir cwd si root está dentro
		return util.path.is_descendant(cwd, root) and cwd or root
	end,
}) -- php

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

	-- Ver información del LSP en ventana flotante con bordes
	{
		"<leader>li",
		function()
			vim.cmd("LspInfo")
		end,
		desc = "󰒓 Ver información de LSP",
	},
}, { mode = "n" }) -- modo normal
