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

	beancount = {
		init_options = {
			journal_file = vim.fn.getcwd() .. "/main.beancount",
			formatting = {
				prefix_width = 30,
				currency_column = 60,
				number_currency_spacing = 1,
			},
			completion = {
				fuzzy_match_accounts = true,
			},
			diagnostic_flags = { "!", "P" },
		},
	},
}

M.manual_servers = {}

return M
