-- Configuración y sobreescritura de notificaciones de Neovim con notify.nvim

local notify = require("notify")
vim.notify = notify

notify.setup({
	stages = "fade_in_slide_out",
	timeout = 5000,
	max_width = 50,
	background_colour = "#000000",
	icons = {
		ERROR = "",
		WARN = "",
		INFO = "",
		DEBUG = "",
		TRACE = "✎",
	},
})

-- Mensaje de bienvenida
notify("🚀 Bienvenido de nuevo Victor", "info", { title = "Nvim" })

-- Tabla para manejar notificaciones por cliente y token
local client_notifs = {}

local function get_notif_data(client_id, token)
	client_notifs[client_id] = client_notifs[client_id] or {}
	client_notifs[client_id][token] = client_notifs[client_id][token] or {}
	return client_notifs[client_id][token]
end

local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(client_id, token)
	local notif_data = get_notif_data(client_id, token)
	if notif_data.spinner then
		notif_data.spinner = (notif_data.spinner + 1) % #spinner_frames
		notif_data.notification = notify(nil, nil, {
			hide_from_history = true,
			icon = spinner_frames[notif_data.spinner],
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

-- LSP progreso
vim.lsp.handlers["$/progress"] = function(_, result, ctx)
	local client_id = ctx.client_id
	local val = result.value
	if not val.kind then
		return
	end

	local notif_data = get_notif_data(client_id, result.token)

	if val.kind == "begin" then
		notif_data.notification = notify(format_message(val.message, val.percentage), "info", {
			title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
			icon = spinner_frames[1],
			timeout = false,
		})
		notif_data.spinner = 1
		update_spinner(client_id, result.token)
	elseif val.kind == "report" and notif_data then
		notify(format_message(val.message, val.percentage), "info", { replace = notif_data.notification })
	elseif val.kind == "end" and notif_data then
		notify(val.message and format_message(val.message) or "Completado", "info", {
			icon = "",
			replace = notif_data.notification,
			timeout = 3000,
		})
		notif_data.spinner = nil
	end
end

-- Traducción de niveles del LSP a notify
local severity = { "error", "warn", "info", "info" }
vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
	notify(method.message, severity[params.type])
end
