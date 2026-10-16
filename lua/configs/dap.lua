-- codelldb se instala con :MasonInstall codelldb.
local dap = require("dap")
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
		args = { "--port", "${port}" },
	},
}
for _, language in ipairs({ "c", "cpp", "rust" }) do
	dap.configurations[language] = {
		{
			name = "Ejecutar con CodeLLDB",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Ruta del ejecutable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}
end
