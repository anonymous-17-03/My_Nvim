local telescope = require("telescope")
local builtin = require("telescope.builtin")

-- Configuración principal de Telescope
telescope.setup({
	defaults = {
		-- Configuración de los bordes de la ventana (estética)
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

		-- Prefijo en el prompt de búsqueda con un icono visual
		prompt_prefix = "   ",
		-- Símbolo que indica la selección actual
		selection_caret = "> ",
		entry_prefix = "  ",

		-- Modo inicial de Telescope cuando se abre, usualmente 'insert' para escribir de inmediato
		initial_mode = "insert",

		-- Estrategia para manejar la selección al actualizar resultados (resetea la selección)
		selection_strategy = "reset",

		-- Estrategia para ordenar los resultados (descendente para mostrar los más relevantes arriba)
		sorting_strategy = "descending",

		-- Tipo de layout que usa la ventana de Telescope, horizontal con opciones de espejo
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = { mirror = false },
			vertical = { mirror = false },
		},

		-- Funciones para sorter fuzzy (búsqueda difusa) para archivos y otros
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

		-- Patrones para ignorar archivos en la búsqueda (vacío para no ignorar nada)
		file_ignore_patterns = {},

		-- Cómo se muestra el path de archivos (vacío para mostrar completo)
		path_display = {},

		-- Transparencia de la ventana (0 es sin transparencia)
		winblend = 0,

		-- Configuración de bordes (vacío, por defecto)
		border = {},

		-- Colorear íconos basados en el tipo de archivo
		color_devicons = true,

		-- Usa el comando 'less' para vista previa paginada (en grep, etc.)
		use_less = true,

		-- Variables de entorno personalizadas para el terminal interno
		set_env = { ["COLORTERM"] = "truecolor" }, -- Permite colores verdaderos en terminal

		-- Previewers para diferentes tipos de búsqueda
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

		-- Configuración para previewers internos, más avanzada (usada internamente)
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
	},
})

-- Configuración de atajos de teclado usando which-key para facilitar la navegación
local wk = require("which-key")

wk.register({
	f = {
		name = "Telescope", -- Ícono general de búsqueda
		f = { builtin.find_files, "󰱼 Buscar Archivo" }, -- Buscar archivos en el proyecto
		g = { builtin.live_grep, "󰱽 Buscar Texto" }, -- Buscar texto dentro de archivos
		b = { builtin.buffers, "󰓩 Ver Buffers" }, -- Listar buffers abiertos
		h = { builtin.help_tags, "󰘥 Buscar Ayuda" }, -- Buscar en la ayuda de Vim/Neovim
		r = { builtin.oldfiles, "󰋚 Archivos Recientes" }, -- Archivos recientemente abiertos
		n = { "<cmd>enew<cr>", " Nuevo Archivo" }, -- Crear un nuevo buffer sin nombre (nuevo archivo)
	},
}, { prefix = "<leader>" })
