-- Mapeos locales: solo se activan en el buffer al que se adjunta Gitsigns.
local function gitsigns_attach_mappings(bufnr)
	local gs = require("gitsigns")
	for _, entry in ipairs({
		{ "hs", gs.stage_hunk, " Stage hunk" },
		{ "hu", gs.undo_stage_hunk, "󰑐 Undo stage hunk" },
		{ "hr", gs.reset_hunk, " Reset hunk" },
		{ "hp", gs.preview_hunk, " Preview hunk" },
		{ "hb", gs.blame_line, "󰊛 Blame line" },
	}) do
		vim.keymap.set("n", "<leader>" .. entry[1], entry[2], { buffer = bufnr, desc = entry[3] })
	end
end

return {
	signs = {
		add = { text = "│" }, -- Línea para líneas añadidas
		change = { text = "│" }, -- Línea para líneas modificadas
		delete = { text = "󰍵" }, -- Símbolo para líneas borradas
		topdelete = { text = "‾" }, -- Símbolo para borrado al inicio
		changedelete = { text = "~" }, -- Línea para cambios + borrado
		untracked = { text = "│" }, -- Línea para archivos nuevos sin seguimiento
	},
	preview_config = {
		border = "rounded", -- Bordes redondeados
		style = "minimal",
		relative = "cursor",
		row = 1,
		col = 1,
	},
	on_attach = function(bufnr)
		gitsigns_attach_mappings(bufnr)
	end,
}
