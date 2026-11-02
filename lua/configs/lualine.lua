-- Carga el diseño guardado por el usuario.
-- Todos los diseños utilizan una única barra de estado global.

local selector = require("configs.lualine_selector")

local theme_name = selector.get_saved_layout()

local ok, config = pcall(require, "lualine_themes." .. theme_name)

if not ok then
	vim.notify(
		"No se pudo cargar el diseño guardado " .. theme_name .. ". Se utilizará NovaHacking.\n" .. tostring(config),
		vim.log.levels.WARN,
		{ title = "NovaHacking · Lualine" }
	)

	config = require("lualine_themes.NovaHacking")
end

-- Una única barra de estado para toda la instancia de Neovim.
config.options = config.options or {}
config.options.globalstatus = true

return config
