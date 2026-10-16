return {
	-- Muestra indicadores en el margen lateral para cambios de Git (add, delete, change).
	-- Permite ver el estado de línea por línea directamente en el buffer.
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return require("configs.gitsigns")
		end,
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},

	-- Integra la interfaz TUI de LazyGit directamente dentro de Neovim.
	-- Permite hacer staging, commits, branch, merge y más con una UI fluida.
	{
		"kdheepak/lazygit.nvim",
		lazy = false,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		-- Atajo de teclado
		keys = {
			{ "<leader>hg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end,
	},
}
