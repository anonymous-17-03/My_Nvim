local M = {}

-- Función para cargar mapeos de teclas
M.load_mappings = function(section, mappings)
	vim.schedule(function()
		if type(mappings) ~= "table" then
			vim.api.nvim_err_writeln("Invalid mappings for section: " .. section)
			return
		end

		for mode, mode_values in pairs(mappings) do
			if type(mode_values) == "table" then
				for keybind, mapping_info in pairs(mode_values) do
					local opts = {
						noremap = true,
						silent = true,
					}

					if type(mapping_info) == "table" then
						opts = vim.tbl_extend("force", opts, mapping_info[2] or {})
						mapping_info = mapping_info[1]
					end

					if opts.buffer then
						local buffer = opts.buffer
						opts.buffer = nil -- Eliminar `buffer` de `opts` para evitar el error
						vim.api.nvim_buf_set_keymap(buffer, mode, keybind, mapping_info, opts)
					else
						vim.api.nvim_set_keymap(mode, keybind, mapping_info, opts)
					end
				end
			else
				vim.api.nvim_err_writeln("Invalid mode values for section: " .. section .. ", mode: " .. mode)
			end
		end
	end)
end

return M
