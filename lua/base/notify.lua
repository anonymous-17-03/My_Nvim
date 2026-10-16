-- Configuración y sobreescritura de notificaciones de Neovim con notify.nvim

local notify = require("notify")
vim.notify = notify

notify.setup({
	stages = "fade_in_slide_out",
	timeout = 5000,
	max_width = 50,
	background_colour = "#000000",
	icons = {
		ERROR = " ",
		WARN = " ",
		INFO = " ",
		DEBUG = " ",
		TRACE = "✎ ",
	},
})

-- Mensaje de bienvenida
local user = vim.uv.os_get_passwd().username
local is_root = vim.uv.getuid() == 0

if is_root then
	notify("💀 Bienvenido de nuevo root", "error", {
		title = "Nvim",
		timeout = 3000,
	})
else
	notify("🚀 Bienvenido de nuevo " .. user, "info", {
		title = "Nvim",
		timeout = 3000,
	})
end

-- Traducción de niveles del LSP a notify
local severity = { "error", "warn", "info", "info" }
vim.lsp.handlers["window/showMessage"] = function(err, result, _)
	if err or not result then
		return
	end
	notify(result.message, severity[result.type] or "info")
end

local function show_lsp_info()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		notify("   No hay un LSP activo!", "warn", {
			title = "LSP Info",
			timeout = 3000,
		})

		return
	end

	local lines = {}
	for _, client in ipairs(clients) do
		local name = client.name
		local id = client.id
		local root_dir = client.config.root_dir or "Desconocido"
		local cmd = type(client.config.cmd) == "table" and table.concat(client.config.cmd, " ")
			or "Función de transporte"
		local encoding = client.offset_encoding or "Desconocido"
		local attached_buffers = vim.tbl_count(client.attached_buffers or {})

		table.insert(lines, string.format("🚀  Cliente:       %s  󰁍  ID: %d", name, id))
		table.insert(lines, string.format("📁  Root Dir:      %s", root_dir))
		table.insert(lines, string.format("💻  Comando:       %s", cmd))
		table.insert(lines, string.format("🎯  Encoding:      %s", encoding))
		table.insert(lines, string.format("📦  B. Attached:   %d", attached_buffers))
	end

	notify(table.concat(lines, "\n"), "info", {
		title = "LSP Info",
		timeout = 5000,
	})
end

-- Mapeo de teclado para <leader>ln (LSP Notification)
vim.keymap.set("n", "<leader>ln", show_lsp_info, { desc = " Mostrar info del LSP actual" })
