-- Bubbles config for lualine with icons and features from Eviline

vim.cmd([[
  highlight LualineBuffersCurrent guifg=#d183e8 guibg=#202328 gui=bold
  highlight LualineBuffers guifg=#808080 guibg=#202328
]])

local lualine = require("lualine")

-- Define colors
local colors = {
	blue = "#80a0ff",
	cyan = "#79dac8",
	black = "#080808",
	white = "#c6c6c6",
	red = "#ff5189",
	violet = "#d183e8",
	grey = "#303030",
	bg = "#202328",
	fg = "#bbc2cf",
	yellow = "#ECBE7B",
	green = "#98be65",
	orange = "#FF8800",
	magenta = "#c678dd",
}

-- Define conditions for displaying components
local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Bubbles theme with additional colors from Eviline
local bubbles_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.violet },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.white, bg = colors.bg },
	},
	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },
	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white, bg = colors.bg },
	},
}

-- Lualine configuration
local config = {
	options = {
		theme = bubbles_theme,
		component_separators = { left = "│", right = "│" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			{
				function()
					return ""
				end,
				separator = { left = "" },
				color = { fg = "#000000" }, -- Color verde pastel
				padding = { left = 1, right = 1 },
			},
			{ "mode", separator = { left = "", right = "" }, right_padding = 2 },
		},
		lualine_b = {
			{
				"filename",
				path = 1,
				symbols = { modified = "⦿", readonly = "", unnamed = "[No Name]" },
				color = { gui = "bold" },
				cond = conditions.buffer_not_empty,
			},
		},
		lualine_c = {
			{ "filesize", cond = conditions.buffer_not_empty },
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					error = { fg = colors.red },
					warn = { fg = colors.yellow },
					info = { fg = colors.cyan },
				},
			},
			{
				function()
					local buffers = vim.fn.getbufinfo({ buflisted = true })
					local result = {}
					for i, buffer in ipairs(buffers) do
						local name = vim.fn.fnamemodify(buffer.name, ":t")
						if buffer.bufnr == vim.fn.bufnr("%") then
							table.insert(result, "%#LualineBuffersCurrent#" .. name .. "%#LualineBuffers#")
						else
							table.insert(result, "%#LualineBuffers#" .. name)
						end
						if i < #buffers then
							table.insert(result, " │ ")
						end
					end
					return table.concat(result)
				end,
				color = { fg = colors.grey }, -- Color gris para todos los buffers
			},
		},
		lualine_x = {
			{
				function()
					local msg = "No Active Lsp"
					local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
					local clients = vim.lsp.get_active_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
					return msg
				end,
				icon = "│   LSP:",
				color = { fg = colors.blue, gui = "bold" },
			},
			{
				"o:encoding",
				fmt = string.upper,
				cond = conditions.hide_in_width,
				color = { fg = colors.green, gui = "bold" },
			},
			{ "fileformat", fmt = string.upper, icons_enabled = true, color = { fg = colors.green, gui = "bold" } },
			{ "branch", icon = "", color = { fg = colors.violet, gui = "bold" } },
			{
				"diff",
				symbols = { added = " ", modified = "󰝤 ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			},
		},
		lualine_y = { "filetype", "progress" },
		lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {},
}

-- Initialize lualine with the combined config
lualine.setup(config)
