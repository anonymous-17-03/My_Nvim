local wk = require("which-key")

-- Función para cerrar todos los buffers excepto el actual
local function close_other_buffers()
	local current_buf = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
			if vim.bo[buf].modified or vim.bo[buf].buftype == "terminal" then
				vim.notify("Se conserva el buffer " .. buf .. " (modificado o terminal)", vim.log.levels.WARN)
			else
				vim.api.nvim_buf_delete(buf, { force = false })
			end
		end
	end
end

wk.add({
	-- Grupo para agregar configuraciones de menú
	{ "<leader>m", group = " Menú" },

	-- Grupo para Git y Hunk
	{ "<leader>h", group = "󰊢 Hunk" },

	-- 🎨 Opciones de la interfaz y comportamiento
	{ "<leader>u", group = "󰒓 Opciones" },

	-- 🔳 NvimTree
	{ "<leader>n", vim.cmd.NvimTreeFocus, desc = "󰙅 Enfocar NvimTree" },
	{ "<C-n>", vim.cmd.NvimTreeToggle, desc = " Alternar NvimTree" },

	-- 🔃 Navegación de Buffers sin grupo
	{ "<leader>1", vim.cmd.bfirst, desc = "󰁉 Primer buffer" },
	{ "<leader>0", vim.cmd.blast, desc = "󰧒 Último buffer" },
	{ "<Tab>", vim.cmd.bnext, desc = " Siguiente buffer" },
	{ "<S-Tab>", vim.cmd.bprevious, desc = " Buffer anterior" },

	-- 🐞 Debug (DAP)
	{ "<leader>d", group = "Debug" },
	{ "<leader>ds", vim.cmd.DapSidebar, desc = "$ Ejecutar DapSidebar" },
	{ "<leader>db", vim.cmd.DapToggleBreakpoint, desc = " Alternar breakpoint" },
	{ "<leader>dc", vim.cmd.DapContinue, desc = " Continuar" },

	-- 📑 Buffers
	{ "<leader>b", group = " Buffer" },
	{ "<leader>bn", "<cmd>bn<cr>", desc = " Siguiente Buffer" },
	{ "<leader>bp", "<cmd>bp<cr>", desc = " Buffer Anterior" },
	{ "<leader>bd", "<cmd>bdelete<cr>", desc = " Cerrar buffer actual" },
	{ "<leader>bo", close_other_buffers, desc = "󰧮 Cerrar otros buffers" },

	-- ✨ Otros
	{ "<leader>e", "<cmd>noh<CR>", desc = "󰚰 Eliminar resaltado de búsqueda" },

	-- 💾 Guardado rápido
	{ "<C-s>", "<cmd>w<CR>", desc = "󰈞 Guardar archivo" },
	{ "<S-s>", "<cmd>x<CR>", desc = "󰗼 Guardar y salir" },
	{ "<A-s>", "<cmd>wa<CR>", desc = " Guardar todos los archivos" },
}, { mode = "n" })

-- Alternar el formato automático al guardar para el buffer actual.
vim.api.nvim_create_user_command("FormatToggle", function()
	local bufnr = vim.api.nvim_get_current_buf()

	local disabled = not vim.b[bufnr].nova_disable_autoformat
	vim.b[bufnr].nova_disable_autoformat = disabled

	local filename = vim.api.nvim_buf_get_name(bufnr)
	filename = filename ~= "" and vim.fn.fnamemodify(filename, ":t") or "[Sin nombre]"

	local estado = disabled and "desactivado" or "activado"

	vim.notify(
		("Formato al guardar: %s\nArchivo: %s"):format(estado, filename),
		vim.log.levels.INFO,
		{ title = "NovaHacking · Formato" }
	)
end, {
	desc = "Alternar formato automático en el buffer actual",
})

vim.keymap.set("n", "<leader>uf", "<cmd>FormatToggle<CR>", {
	desc = "Alternar formato al guardar",
	silent = true,
})
