return {
	-- Terminal: Ej. toggleterm
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				shade_filetypes = {},
				shade_terminals = true,
				start_in_insert = true,
				persist_size = true,
				direction = "float",
				shell = "zsh",
				float_opts = {
					border = "rounded",
				},
				size = function(term)
					if term.direction == "horizontal" then
						return 17
					elseif term.direction == "vertical" then
						return 80
					end
					return 20
				end,
			})

			-- Mapeos para abrir terminales en diferentes direcciones
			-- Registro en which-key con íconos
			local wk = require("which-key")

			wk.add({
				-- Grupo principal: Terminal
				{ "<leader>t", group = " Terminal" },
				{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = " Terminal Flotante" },
				{ "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = " Terminal Vertical" },
				{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = " Terminal Horizontal" },
			}, { mode = "n" }) -- modo normal
		end,
	},
}
