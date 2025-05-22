local M = {}

-- Función para cargar mapeos de teclas de manera programada
-- @param section: nombre de la sección para identificar mensajes de error
-- @param mappings: tabla con mapeos estructurados por modo (e.g. 'n', 'i')
M.load_mappings = function(section, mappings)
	-- Ejecuta la función programada para evitar bloqueos en la UI
	vim.schedule(function()
		-- Verifica que mappings sea una tabla válida
		if type(mappings) ~= "table" then
			vim.api.nvim_err_writeln("Invalid mappings for section: " .. section)
			return
		end

		-- Itera sobre cada modo (normal, inserción, etc.)
		for mode, mode_values in pairs(mappings) do
			if type(mode_values) == "table" then
				-- Itera sobre cada combinación tecla -> acción
				for keybind, mapping_info in pairs(mode_values) do
					-- Opciones por defecto para el mapeo
					local opts = {
						noremap = true, -- No permitir remapeos recursivos
						silent = true, -- No mostrar mensajes en la ejecución
					}

					-- Si mapping_info es tabla, puede incluir opciones personalizadas
					if type(mapping_info) == "table" then
						-- Extiende opts con opciones específicas (p.ej. buffer)
						opts = vim.tbl_extend("force", opts, mapping_info[2] or {})
						-- El primer elemento es la acción mapeada
						mapping_info = mapping_info[1]
					end

					-- Si opts contiene 'buffer', hace mapeo local al buffer
					if opts.buffer then
						local buffer = opts.buffer
						opts.buffer = nil -- Elimina para evitar error en la API
						-- Mapeo específico para buffer actual
						vim.api.nvim_buf_set_keymap(buffer, mode, keybind, mapping_info, opts)
					else
						-- Mapeo global en el modo especificado
						vim.api.nvim_set_keymap(mode, keybind, mapping_info, opts)
					end
				end
			else
				-- Si mode_values no es tabla, error de configuración
				vim.api.nvim_err_writeln("Invalid mode values for section: " .. section .. ", mode: " .. mode)
			end
		end
	end)
end

return M
