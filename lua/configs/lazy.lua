return {
	-- Rip Substitute
	{
		"chrisgrieser/nvim-rip-substitute",
		cmd = "RipSubstitute",
		opts = {},
		keys = {
			{
				"<leader>rs",
				function()
					require("rip-substitute").sub()
				end,
				mode = { "n", "x" },
				desc = " rip substitute",
			},
		},
		config = function()
			-- Función auxiliar por si no tienes `getBorder()` definido
			local function getBorder()
				if vim.fn.has("nvim-0.11") == 1 then
					return vim.o.winborder
				else
					return "rounded"
				end
			end

			require("rip-substitute").setup({
				popupWin = {
					title = " rip-substitute",
					border = getBorder(),
					matchCountHlGroup = "Keyword",
					noMatchHlGroup = "ErrorMsg",
					position = "bottom",
					hideSearchReplaceLabels = false,
					hideKeymapHints = false,
					disableCompletions = true,
				},
				prefill = {
					normal = "cursorWord",
					visual = "selection",
					startInReplaceLineIfPrefill = false,
					alsoPrefillReplaceLine = false,
				},
				keymaps = {
					abort = "q",
					confirm = "<CR>",
					insertModeConfirm = "<C-CR>",
					prevSubstitutionInHistory = "<Up>",
					nextSubstitutionInHistory = "<Down>",
					toggleFixedStrings = "<C-f>",
					toggleIgnoreCase = "<C-c>",
					openAtRegex101 = "R",
					showHelp = "?",
				},
				incrementalPreview = {
					matchHlGroup = "IncSearch",
					rangeBackdrop = {
						enabled = true,
						blend = 50,
					},
				},
				regexOptions = {
					startWithFixedStringsOn = false,
					startWithIgnoreCase = false,
					pcre2 = false, -- Temporal | false
					autoBraceSimpleCaptureGroups = true,
				},
				editingBehavior = {
					autoCaptureGroups = false,
				},
				notification = {
					onSuccess = true,
					icon = "",
				},
				debug = true,
			})
		end,
	},

	-- Terminal: Ej. toggleterm
	require("plugins_lazy.terminal"),

	-- Editor: Ej. autopairs, treesitter, indent, mason
	require("plugins_lazy.editor"),

	-- ui: Ej. noice, notify, tokyonight, dashboard, lualine, nvim-tree
	require("plugins_lazy.ui"),

	-- Markdown: Ej. markdown-preview
	require("plugins_lazy.markdown"),

	-- Git: Ej. gitsigns
	require("plugins_lazy.git"),
}
