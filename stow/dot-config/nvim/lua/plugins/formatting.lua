return {
	"NMAC427/guess-indent.nvim",
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fb",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				if os.getenv("NVIM_DISABLE_FORMAT") or disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "eslint_d", "prettier" },
				javascriptreact = { "eslint_d", "prettier" },
				typescript = { "eslint_d", "prettier" },
				typescriptreact = { "eslint_d", "prettier" },
				go = { "gofmt", "goimports", "golines", "gofumpt" },
			},
		},
	},
}
