-- Este módulo gestiona la instalación y configuración del gestor de plugins Lazy.nvim

-- Definir la ruta donde se instalará Lazy.nvim si no existe
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Verifica si Lazy.nvim ya está instalado
if not vim.loop.fs_stat(lazypath) then
	-- Si no está instalado, lo clona desde GitHub usando git
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none", -- Evita clonar blobs innecesarios (más rápido)
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Clona la rama estable
		lazypath,
	})
end

-- Añade la ruta de Lazy.nvim al runtime de Neovim
vim.opt.rtp:prepend(lazypath)

-- Requiere la lista de plugins desde un archivo separado
-- SUGERENCIA: Este archivo debería estar en /lua/configs/lazy.lua
plugins = require("configs.lazy")

-- Llama a la función de configuración de Lazy.nvim y pasa la lista de plugins
require("lazy").setup(plugins)
