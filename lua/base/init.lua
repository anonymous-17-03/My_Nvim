-- Configuración base global de Neovim

-- Líder personalizado (espacio)
vim.g.mapleader = " "

-- Portapapeles del sistema habilitado
vim.opt.clipboard = "unnamedplus"

-- Mostrar números de línea
vim.wo.number = true -- Línea actual absoluta
vim.wo.relativenumber = true -- Resto de líneas relativas

-- Cargar configuración de plugins
require("base.plugins.lazy")

-- Cargar atajos personalizados
require("base.keymaps")

-- Cargar configuración de notificaciones
require("base.notify")
