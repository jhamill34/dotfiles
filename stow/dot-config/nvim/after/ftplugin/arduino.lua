vim.lsp.config("arduino_language_server", {
	cmd = {
		"arduino-language-server",
		"-cli-config",
		vim.fn.expand("~/Library/Arduino15/arduino-cli.yaml"),
		"-fqbn",
		"arduino:avr:nano:cpu=atmega328old",
		-- "-log",
	},
})
