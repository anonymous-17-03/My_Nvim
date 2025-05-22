return {
	filters = {
		dotfiles = true, -- Mostrar archivos ocultos (dotfiles)
		exclude = {
			vim.fn.stdpath("config") .. "/lua/custom", -- Excluir config personalizada
			".gitignore", -- Excluir archivo .gitignore
			".env", -- Excluir archivo .env
		},
	},
	disable_netrw = true, -- Desactiva el explorador nativo de archivos de Neovim
	hijack_netrw = true, -- Reemplaza netrw al abrir carpetas
	hijack_cursor = true, -- Cursor se mantiene en el árbol al abrir archivos
	hijack_unnamed_buffer_when_opening = false, -- No reemplaza buffers sin nombre
	sync_root_with_cwd = true, -- Sincroniza la raíz del árbol con el directorio actual
	update_focused_file = {
		enable = true, -- Actualiza archivo enfocado en el árbol
		update_root = false, -- No cambia raíz del árbol automáticamente
	},
	view = {
		adaptive_size = false, -- No cambia el tamaño automáticamente
		side = "right", -- Muestra el árbol a la derecha
		width = 30, -- Ancho del panel
		preserve_window_proportions = true, -- Mantiene proporción de ventanas
	},
	git = {
		enable = false, -- Desactiva iconos y estado Git
		ignore = true, -- Ignora archivos listados en .gitignore
	},
	filesystem_watchers = {
		enable = true, -- Actualiza el árbol automáticamente al detectar cambios
	},
	actions = {
		open_file = {
			resize_window = true, -- Redimensiona ventana al abrir archivo
		},
	},
	renderer = {
		root_folder_label = false, -- No muestra nombre de la carpeta raíz
		highlight_git = false, -- No resalta archivos Git
		highlight_opened_files = "none", -- No resalta archivos abiertos

		indent_markers = {
			enable = false, -- No muestra guías de indentación
		},

		icons = {
			show = {
				file = true, -- Mostrar íconos para archivos
				folder = true, -- Mostrar íconos para carpetas
				folder_arrow = true, -- Mostrar flechas para expandir carpetas
				git = false, -- No mostrar iconos Git
			},

			glyphs = {
				default = "󰈚", -- Ícono por defecto
				symlink = "", -- Ícono para enlaces simbólicos
				folder = {
					default = "", -- Carpeta por defecto
					empty = "", -- Carpeta vacía
					empty_open = "", -- Carpeta vacía abierta
					open = "", -- Carpeta abierta
					symlink = "", -- Carpeta symlink
					symlink_open = "", -- Carpeta symlink abierta
					arrow_open = "", -- Flecha de carpeta abierta
					arrow_closed = "", -- Flecha de carpeta cerrada
				},
				git = {
					unstaged = "✗", -- Cambios no guardados
					staged = "✓", -- Cambios listos para commit
					unmerged = "", -- Conflicto de merge
					renamed = "➜", -- Archivo renombrado
					untracked = "★", -- Archivo nuevo
					deleted = "", -- Archivo eliminado
					ignored = "◌", -- Archivo ignorado
				},
			},
		},
	},
}
