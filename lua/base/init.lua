-- Configuración base global de Neovim

-- Líder personalizado (espacio)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"

-- Portapapeles del sistema habilitado
vim.opt.clipboard = "unnamedplus"

-- Mostrar números de línea
vim.wo.number = true -- Línea actual absoluta
vim.wo.relativenumber = true -- Resto de líneas relativas

-- NvimTree gestiona los directorios desde el arranque.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Cargar configuración de plugins
require("base.plugins.lazy")

-- Cargar atajos personalizados
require("base.keymaps")

-- Cargar configuración de notificaciones
require("base.notify")
