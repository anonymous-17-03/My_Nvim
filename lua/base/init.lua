--Basic settings
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"

vim.wo.relativenumber = true
vim.wo.number = true
--Mappings
vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus)
vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>1", vim.cmd.bfirst)
vim.keymap.set("n", "<leader>0", vim.cmd.blast)
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>b", vim.cmd.DapToggleBreakpoint)
vim.keymap.set("n", "<leader>wd", vim.cmd.close, { desc = "Cerrar Ventana" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")
vim.keymap.set("n", "<S-s>", "<cmd>x<CR>")
vim.keymap.set("n", "<A-s>", "<cmd>wa<CR>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Cerrar Buffer" })
vim.keymap.set("n", "<leader>n", "<cmd>noh<CR>", { desc = "Desactivar Resaltado de Búsqueda" })

-- Function to close all buffers except the current one
local function close_other_buffers()
	local current_buf = vim.api.nvim_get_current_buf()
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in ipairs(buffers) do
		if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

-- Mapping to close all buffers except the current one
vim.keymap.set("n", "<leader>bo", close_other_buffers, { desc = "Cerrar los otros Buffers" })

-- Lazy requirement
require("base.plugins.lazy")

-- Notificaciones
vim.notify = require("notify")
local notify = require("notify")

-- Configuración global
notify.setup({
	-- Configuración opcional según tus necesidades
	icons = {
		ERROR = "",
		WARN = "",
		INFO = "",
		DEBUG = "",
		TRACE = "✎",
	},
	stages = "fade_in_slide_out", -- Animación de entrada y salida
	timeout = 5000, -- Tiempo por defecto para mostrar las notificaciones (en milisegundos)
	max_width = 50, -- Ancho máximo del mensaje
	background_colour = "#000000", -- Color de fondo para las animaciones de opacidad
})

-- Ejemplo de notificación
notify(" 🚀 Bienvenido de nuevo Victor", "info", {
	title = " Nvim",
})

notify(" 💀 Estas como root\n\tTen cuidado...", "error", {
	title = " Anonymous",
	timeout = 7000,
})

-- Utility functions shared between progress reports for LSP and DAP

local client_notifs = {}

local function get_notif_data(client_id, token)
	if not client_notifs[client_id] then
		client_notifs[client_id] = {}
	end

	if not client_notifs[client_id][token] then
		client_notifs[client_id][token] = {}
	end

	return client_notifs[client_id][token]
end

local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(client_id, token)
	local notif_data = get_notif_data(client_id, token)

	if notif_data.spinner then
		local new_spinner = (notif_data.spinner + 1) % #spinner_frames
		notif_data.spinner = new_spinner

		notif_data.notification = vim.notify(nil, nil, {
			hide_from_history = true,
			icon = spinner_frames[new_spinner],
			replace = notif_data.notification,
		})

		vim.defer_fn(function()
			update_spinner(client_id, token)
		end, 100)
	end
end

local function format_title(title, client_name)
	return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
	return (percentage and percentage .. "%\t" or "") .. (message or "")
end

-- LSP integration
-- Make sure to also have the snippet with the common helper functions in your config!

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
	local client_id = ctx.client_id

	local val = result.value

	if not val.kind then
		return
	end

	local notif_data = get_notif_data(client_id, result.token)

	if val.kind == "begin" then
		local message = format_message(val.message, val.percentage)

		notif_data.notification = vim.notify(message, "info", {
			title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
			icon = spinner_frames[1],
			timeout = false,
			hide_from_history = false,
		})

		notif_data.spinner = 1
		update_spinner(client_id, result.token)
	elseif val.kind == "report" and notif_data then
		notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
			replace = notif_data.notification,
			hide_from_history = false,
		})
	elseif val.kind == "end" and notif_data then
		notif_data.notification = vim.notify(val.message and format_message(val.message) or "Complete", "info", {
			icon = "",
			replace = notif_data.notification,
			timeout = 3000,
		})

		notif_data.spinner = nil
	end
end

-- table from lsp severity to vim severity.
local severity = {
	"error",
	"warn",
	"info",
	"info", -- map both hint and info to info?
}
vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
	vim.notify(method.message, severity[params.type])
end
