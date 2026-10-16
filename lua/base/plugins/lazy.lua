-- Lazy se instala dentro de stdpath: también funciona con NVIM_APPNAME.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local output = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("No se pudo instalar lazy.nvim:\n" .. output)
	end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(require("configs.lazy"), {
	ui = { border = "rounded" },
	change_detection = { notify = false },
})
