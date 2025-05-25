return {
	{
		-- Plugin principal para búsqueda y reemplazo interactivo
		"nvim-pack/nvim-spectre",

		-- Dependencia necesaria para que Spectre funcione correctamente
		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		config = function()
			require("spectre").setup({
				open_cmd = "new", -- Aquí lo cambiamos de 'vnew' (vertical) a 'new' (horizontal)

				-- Activar íconos de devicons (si tienes configurado Nerd Font)
				color_devicons = true,

				-- Actualizaciones en vivo mientras editas archivos
				live_update = false,

				-- Muestra los números de línea en los resultados
				lnum_for_results = true,

				-- Separador superior entre bloques de resultados
				line_sep_start = "╭──────────────────────────────────────────────────────────────────────────────────────────",

				-- Separador inferior entre bloques de resultados
				line_sep = "╰──────────────────────────────────────────────────────────────────────────────────────────",

				-- Padding a la izquierda del resultado
				result_padding = "│  ",

				-- Colores personalizados para elementos de la UI
				highlight = {
					ui = "String", -- Color para la interfaz general
					search = "DiffChange", -- Color del texto buscado
					replace = "DiffDelete", -- Color del texto a reemplazar
				},

				-- Mapeos de teclas para controlar la interfaz y acciones de búsqueda/reemplazo
				mapping = {
					["tab"] = {
						map = "<Tab>",
						cmd = "<cmd>lua require('spectre').tab()<cr>",
						desc = "Ir a la siguiente consulta",
					},
					["shift-tab"] = {
						map = "<S-Tab>",
						cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
						desc = "Ir a la consulta anterior",
					},
					["toggle_line"] = {
						map = "dd",
						cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
						desc = "Activar/desactivar línea seleccionada",
					},
					["show_option_menu"] = {
						map = "<leader>o",
						cmd = "<cmd>lua require('spectre').show_options()<CR>",
						desc = "Mostrar menú de opciones",
					},
					["run_current_replace"] = {
						map = "<leader>rc",
						cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
						desc = "Reemplazar línea actual",
					},
					["run_replace"] = {
						map = "<leader>rt",
						cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
						desc = "Reemplazar todos los resultados",
					},
					["change_replace_sed"] = {
						map = "trs",
						cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
						desc = "Usar sed para reemplazar",
					},
					["change_replace_oxi"] = {
						map = "tro",
						cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
						desc = "Usar oxi (nvim-oxi) para reemplazar",
					},
					["toggle_live_update"] = {
						map = "tu",
						cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
						desc = "Activar/desactivar actualización en vivo",
					},
					["toggle_ignore_case"] = {
						map = "ti",
						cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
						desc = "Alternar ignorar mayúsculas/minúsculas",
					},
					["toggle_ignore_hidden"] = {
						map = "th",
						cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
						desc = "Incluir archivos ocultos en búsqueda",
					},
					["resume_last_search"] = {
						map = "<leader>ru",
						cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
						desc = "Repetir última búsqueda",
					},
					["select_template"] = {
						map = "<leader>rp",
						cmd = "<cmd>lua require('spectre.actions').select_template()<CR>",
						desc = "Elegir plantilla de búsqueda",
					},
					["delete_line"] = {
						map = "<leader>rd",
						cmd = "<cmd>lua require('spectre.actions').run_delete_line()<CR>",
						desc = "Eliminar línea de resultado",
					},
				},

				-- Motores de búsqueda disponibles
				find_engine = {
					["rg"] = {
						cmd = "rg",
						args = {
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
						},
						options = {
							["ignore-case"] = {
								value = "--ignore-case",
								icon = "[I]",
								desc = "Ignorar mayúsculas/minúsculas",
							},
							["hidden"] = {
								value = "--hidden",
								desc = "Incluir archivos ocultos",
								icon = "[H]",
							},
						},
					},
					["ag"] = {
						cmd = "ag",
						args = {
							"--vimgrep",
							"-s",
						},
						options = {
							["ignore-case"] = {
								value = "-i",
								icon = "[I]",
								desc = "Ignorar mayúsculas/minúsculas",
							},
							["hidden"] = {
								value = "--hidden",
								desc = "Incluir archivos ocultos",
								icon = "[H]",
							},
						},
					},
				},

				-- Motores de reemplazo disponibles
				replace_engine = {
					["sed"] = {
						cmd = "sed",
						args = nil,
						options = {
							["ignore-case"] = {
								value = "--ignore-case",
								icon = "[I]",
								desc = "Ignorar mayúsculas/minúsculas",
							},
						},
					},
					["oxi"] = {
						cmd = "oxi",
						args = {},
						options = {
							["ignore-case"] = {
								value = "i",
								icon = "[I]",
								desc = "Ignorar mayúsculas/minúsculas",
							},
						},
					},
					["sd"] = {
						cmd = "sd",
						options = {},
					},
				},

				-- Configuración por defecto del motor usado
				default = {
					find = {
						cmd = "rg",
						options = { "ignore-case" },
					},
					replace = {
						cmd = "sed",
					},
				},

				-- Configuración avanzada y final
				replace_vim_cmd = "cdo",
				use_trouble_qf = false,
				is_open_target_win = true,
				is_insert_mode = false,
				is_block_ui_break = false,
				open_template = {},
			})
		end,

		-- Mapeos globales para abrir Spectre rápidamente
		keys = {
			{
				"<leader>s",
				function()
					require("spectre").toggle()
				end,
				desc = "Abrir Spectre",
			},
			{
				"<leader>rw",
				function()
					require("spectre").open_visual({ select_word = true })
				end,
				mode = "n",
				desc = "Buscar palabra bajo el cursor",
			},
			{
				"<leader>ra",
				function()
					require("spectre").open_file_search({ select_word = true })
				end,
				desc = "Buscar en archivo actual",
			},
		},
	},
}
