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

-- Registrar todos los atajos con which-key
wk.register({
	-- NvimTree
	["<leader>e"] = { vim.cmd.NvimTreeFocus, "󰙅 Enfocar NvimTree" },
	["<C-n>"] = { vim.cmd.NvimTreeToggle, " Alternar NvimTree" },

	-- Navegación buffers simple (sin grupo)
	["<leader>1"] = { vim.cmd.bfirst, "󰁉 Primer buffer" },
	["<leader>0"] = { vim.cmd.blast, "󰧒 Último buffer" },
	["<Tab>"] = { vim.cmd.bnext, " Siguiente buffer" },
	["<S-Tab>"] = { vim.cmd.bprevious, " Buffer anterior" },

	-- Debug (Dap)
	["<leader>d"] = {
		name = "Debug",
		b = { vim.cmd.DapToggleBreakpoint, " Alternar breakpoint" },
		-- Puedes agregar más comandos DAP aquí, por ejemplo:
		c = { vim.cmd.DapContinue, " Continuar" },
	},

	-- Grupo buffers
	["<leader>b"] = {
		name = " Buffer",
		n = { "<cmd>bn<cr>", " Siguiente Buffer" },
		p = { "<cmd>bp<cr>", " Buffer Anterior" },
		d = { "<cmd>bdelete<cr>", " Cerrar buffer actual" },
		o = { close_other_buffers, "󰧮 Cerrar otros buffers" },
	},

	-- Cierre de ventanas
	["<leader>wd"] = { vim.cmd.close, " Cerrar ventana actual" },

	-- Otros
	["<leader>e"] = { "<cmd>noh<CR>", "󰚰 Eliminar resaltado de búsqueda" },

	-- Guardado rápido (modo normal)
	["<C-s>"] = { "<cmd>w<CR>", "󰈞 Guardar archivo" },
	["<S-s>"] = { "<cmd>x<CR>", "󰗼 Guardar y salir" },
	["<A-s>"] = { "<cmd>wa<CR>", " Guardar todos los archivos" },
}, { mode = "n" })
