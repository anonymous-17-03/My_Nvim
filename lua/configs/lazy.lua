return {
	-- Terminal:
	-- Ej. toggleterm
	require("plugins_lazy.terminal"),

	-- Editor:
	-- Ej. autopairs, treesitter, indent, mason, goto-preview,
	-- lspconfig, cmp, conform, rust, nvim-dap
	require("plugins_lazy.editor"),

	-- ui:
	-- Ej. noice, notify, tokyonight, dashboard, lualine, nvim-tree,
	-- incline, typr, mini.icons, which-key, telescope, oil, twilight
	require("plugins_lazy.ui"),

	-- Markdown:
	-- Ej. glow, peek, markdown-preview
	require("plugins_lazy.markdown"),

	-- Git:
	-- Ej. gitsigns, lazygit
	require("plugins_lazy.git"),

	-- Spectre:
	-- Herramienta para sustituir un texto en todo el proyecto
	-- Encuentra al enemigo y los reemplaza con poder oscuro.
	require("plugins_lazy.spectre"),
}
