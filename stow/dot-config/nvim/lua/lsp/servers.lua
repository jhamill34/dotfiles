local M = {}

M.mason_servers = {
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = {
					globals = { "vim", "hs", "spoon" },
				},
			},
		},
	},

	arduino_language_server = {
		cmd = {
			"arduino-language-server",
			"-cli-config",
			vim.fn.expand("~/Library/Arduino15/arduino-cli.yaml"),
			"-qbn",
			"arduino:avr:nano:cpu=atmega328old",
		},
	},
}

M.manual_servers = {}

return M
