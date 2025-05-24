return {
	{
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		config = function()
			require("glow").setup({
				border = "rounded",
				width = 100,
				height = 80,
				style = "dark",
				pager = false,
			})
		end,
	},
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end, -- <- más confiable que el cd && npm
		config = function()
			vim.g.mkdp_auto_start = 1
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_open_to_the_world = 1
			vim.g.mkdp_port = "8888"
			vim.g.mkdp_browser = "firefox" -- asegúrate que este sea el nombre exacto del navegador
			vim.g.mkdp_echo_preview_url = 1
		end,
	},
}
