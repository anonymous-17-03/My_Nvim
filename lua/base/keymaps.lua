local keymap = vim.keymap
local wk = require("which-key")

-- Función para cerrar todos los buffers excepto el actual
local function close_other_buffers()
	local current_buf = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

wk.add({
	-- Grupo para agregar configuraciones de menú
	{ "<leader>m", group = " Menú" },

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
	{ "<leader>db", vim.cmd.DapToggleBreakpoint, desc = " Alternar breakpoint" },
	{ "<leader>dc", vim.cmd.DapContinue, desc = " Continuar" },

	-- 📑 Buffers
	{ "<leader>b", group = " Buffer" },
	{ "<leader>bn", "<cmd>bn<cr>", desc = " Siguiente Buffer" },
	{ "<leader>bp", "<cmd>bp<cr>", desc = " Buffer Anterior" },
	{ "<leader>bd", "<cmd>bdelete<cr>", desc = " Cerrar buffer actual" },
	{ "<leader>bo", close_other_buffers, desc = "󰧮 Cerrar otros buffers" },

	-- 🪟 Ventanas
	{ "<leader>wd", vim.cmd.close, desc = " Cerrar ventana actual" },

	-- ✨ Otros
	{ "<leader>e", "<cmd>noh<CR>", desc = "󰚰 Eliminar resaltado de búsqueda" },

	-- 💾 Guardado rápido
	{ "<C-s>", "<cmd>w<CR>", desc = "󰈞 Guardar archivo" },
	{ "<S-s>", "<cmd>x<CR>", desc = "󰗼 Guardar y salir" },
	{ "<A-s>", "<cmd>wa<CR>", desc = " Guardar todos los archivos" },
}, { mode = "n" })
