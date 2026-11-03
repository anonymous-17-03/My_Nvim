-- Selector de diseños de Lualine mediante Telescope.
-- Guarda la preferencia del usuario en el directorio de estado de Neovim.

local M = {}

-- Diseño predeterminado cuando todavía no existe una preferencia guardada.
M.default_layout = "NovaHacking"

-- Diseños disponibles.
-- Los nombres deben coincidir con los módulos de lua/lualine_themes/.
M.layouts = {
	{
		name = "NovaHacking",
		label = "NovaHacking · Personalizado",
	},
	{
		name = "bubbles",
		label = "Bubbles · Decorativo",
	},
	{
		name = "slanted",
		label = "Slanted · Separadores inclinados",
	},
	{
		name = "back",
		label = "Back · Minimalista",
	},
	{
		name = "evil",
		label = "Evil · Estilo Eviline",
	},
}

-- Ruta de las preferencias personales.
local state_dir = vim.fn.stdpath("state") .. "/novahacking"
local state_file = state_dir .. "/appearance.json"

-- Comprueba que el nombre corresponda a un diseño permitido.
local function is_valid_layout(name)
	for _, layout in ipairs(M.layouts) do
		if layout.name == name then
			return true
		end
	end

	return false
end

-- Lee la preferencia guardada.
function M.get_saved_layout()
	if vim.fn.filereadable(state_file) ~= 1 then
		return M.default_layout
	end

	local lines = vim.fn.readfile(state_file)
	local content = table.concat(lines, "\n")

	local ok, data = pcall(vim.json.decode, content)

	if not ok or type(data) ~= "table" then
		vim.notify(
			"No se pudieron leer las preferencias de Lualine. Se utilizará NovaHacking.",
			vim.log.levels.WARN,
			{ title = "NovaHacking · Lualine" }
		)

		return M.default_layout
	end

	local name = data.lualine

	if type(name) ~= "string" or not is_valid_layout(name) then
		vim.notify(
			"La preferencia de Lualine no es válida. Se utilizará NovaHacking.",
			vim.log.levels.WARN,
			{ title = "NovaHacking · Lualine" }
		)

		return M.default_layout
	end

	return name
end

-- Guarda la preferencia seleccionada.
local function save_layout(name)
	local ok, err = pcall(function()
		vim.fn.mkdir(state_dir, "p")

		local data = {
			lualine = name,
		}

		local json = vim.json.encode(data)

		vim.fn.writefile({ json }, state_file)
	end)

	if not ok then
		vim.notify(
			"No se pudo guardar el diseño: " .. tostring(err),
			vim.log.levels.ERROR,
			{ title = "NovaHacking · Lualine" }
		)

		return false
	end

	return true
end

-- Aplica un diseño y guarda la preferencia.
function M.set_layout(name)
	if not is_valid_layout(name) then
		vim.notify(
			"Diseño de Lualine desconocido: " .. tostring(name),
			vim.log.levels.ERROR,
			{ title = "NovaHacking · Lualine" }
		)

		return false
	end

	-- Cargar la configuración del diseño sin modificar los archivos.
	local ok, config = pcall(require, "lualine_themes." .. name)

	if not ok then
		vim.notify(
			"No se pudo cargar el diseño " .. name .. ":\n" .. tostring(config),
			vim.log.levels.ERROR,
			{ title = "NovaHacking · Lualine" }
		)

		return false
	end

	-- Aplicar la configuración inmediatamente.
	local setup_ok, setup_err = pcall(function()
		require("lualine").setup(config)
	end)

	if not setup_ok then
		vim.notify(
			"No se pudo aplicar el diseño " .. name .. ":\n" .. tostring(setup_err),
			vim.log.levels.ERROR,
			{ title = "NovaHacking · Lualine" }
		)

		return false
	end

	-- Recordar la selección para futuros inicios.
	local saved = save_layout(name)

	if saved then
		vim.notify(
			"Se ha aplicado y guardado el diseño: " .. name,
			vim.log.levels.INFO,
			{ title = "NovaHacking · Lualine" }
		)
	else
		vim.notify(
			"El diseño " .. name .. " está activo, pero no se pudo guardar la preferencia.",
			vim.log.levels.WARN,
			{ title = "NovaHacking · Lualine" }
		)
	end

	return true
end

-- Registra un layout "center" con una línea de separación entre prompt y resultados.
local function register_separated_layout()
	local layout_strategies = require("telescope.pickers.layout_strategies")

	if layout_strategies.center_separated then
		return
	end

	layout_strategies.center_separated = function(self, max_columns, max_lines, layout_config)
		local layout = layout_strategies.center(self, max_columns, max_lines, layout_config)

		-- Bajar los resultados una línea para dejar un hueco entre las cajas.
		layout.results.line = layout.results.line + 1
		layout.results.height = math.max(layout.results.height - 1, 1)

		return layout
	end
end

-- Abre el selector de diseños mediante Telescope.
function M.open()
	local ok, err = pcall(function()
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		register_separated_layout()

		local current_layout = M.get_saved_layout()

		local entries = {}

		for _, layout in ipairs(M.layouts) do
			local selected = layout.name == current_layout

			table.insert(entries, {
				name = layout.name,
				label = layout.label,
				ordinal = layout.name .. " " .. layout.label,
				display = (selected and "✓ " or "  ") .. layout.label,
			})
		end

		-- Caja completa (arriba, derecha, abajo, izquierda, esquinas).
		local box = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

		pickers
			.new({}, {
				prompt_title = "󰒓 Seleccionar diseño de Lualine",
				results_title = "Diseños disponibles",

				layout_strategy = "center_separated",
				layout_config = {
					width = 0.42,
					height = 0.35,
					prompt_position = "top",
				},

				border = true,
				borderchars = {
					prompt = box,
					results = box,
					preview = box,
				},

				sorting_strategy = "ascending",
				finder = finders.new_table({
					results = entries,

					entry_maker = function(entry)
						return {
							value = entry.name,
							display = entry.display,
							ordinal = entry.ordinal,
						}
					end,
				}),

				sorter = conf.generic_sorter({}),

				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()

						if not selection then
							return
						end

						actions.close(prompt_bufnr)

						M.set_layout(selection.value)
					end)

					return true
				end,
			})
			:find()
	end)

	if not ok then
		vim.notify(
			"No se pudo abrir el selector de Lualine:\n" .. tostring(err),
			vim.log.levels.ERROR,
			{ title = "NovaHacking · Lualine" }
		)
	end
end

return M
