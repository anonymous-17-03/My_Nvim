return {
	-- Muestra indicadores en el margen lateral para cambios de Git (add, delete, change).
	-- Permite ver el estado de línea por línea directamente en el buffer.
	-- Soporta operaciones como staging, reset y preview de cambios desde Neovim.
	-- Carga perezosa inteligente al detectar que el buffer pertenece a un repositorio Git.
	-- Se configura usando `configs.others.gitsigns` para mantener modularidad.
	{
		"lewis6991/gitsigns.nvim",
		ft = { "gitcommit", "diff" },
		init = function()
			vim.api.nvim_create_autocmd({ "BufRead" }, {
				group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
				callback = function()
					vim.fn.jobstart({ "git", "-C", vim.loop.cwd(), "rev-parse" }, {
						on_exit = function(_, return_code)
							if return_code == 0 then
								vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
								vim.schedule(function()
									require("lazy").load({ plugins = { "gitsigns.nvim" } })
								end)
							end
						end,
					})
				end,
			})
		end,
		opts = function()
			return require("configs.others").gitsigns
		end,
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},

	-- Integra la interfaz TUI de LazyGit directamente dentro de Neovim.
	-- Permite hacer staging, commits, branch, merge y más con una UI fluida.
	-- Usa `Telescope` para acceder a funciones como filtros y archivos actuales.
	-- Configura comandos personalizados (`LazyGit*`) y un atajo con `<leader>hg`.
	-- Carga sin demora (lazy = false) para acceso inmediato.
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
