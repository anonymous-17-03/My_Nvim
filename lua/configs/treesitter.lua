-- Los parsers se instalan explícitamente con :TSInstallAll.
-- Así evitamos lanzar instalaciones en cada arranque de Neovim.
local languages = {
	"vim",
	"lua",
	"vimdoc",
	"query",
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"c",
	"cpp",
	"rust",
	"svelte",
	"python",
	"yaml",
	"json",
	"astro",
	"bash",
	"go",
	"gomod",
	"php",
	"markdown",
	"markdown_inline",
}

vim.api.nvim_create_user_command("TSInstallAll", function()
	require("nvim-treesitter").install(languages)
end, {
	desc = "Instalar parsers de los lenguajes configurados",
})

-- Al recargar este módulo, elimina sus autocmds anteriores.
local group = vim.api.nvim_create_augroup("NovaTreesitter", {
	clear = true,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,

	callback = function(ev)
		local buftype = vim.bo[ev.buf].buftype
		local filetype = vim.bo[ev.buf].filetype

		-- No activar Tree-sitter en buffers especiales.
		-- Dashboard se excluye explícitamente porque puede establecer
		-- su filetype antes de terminar de configurar el buftype.
		if buftype ~= "" or filetype == "dashboard" then
			return
		end

		local lang = vim.treesitter.language.get_lang(filetype)

		if not lang then
			return
		end

		-- Son dos resultados distintos:
		-- ok: la llamada no lanzó una excepción.
		-- loaded: el parser realmente pudo cargarse.
		local ok, loaded = pcall(vim.treesitter.language.add, lang)

		if not ok or not loaded then
			return
		end

		-- Activar el resaltado únicamente con un parser disponible.
		vim.treesitter.start(ev.buf, lang)
	end,
})
