local M = {}

function M.configure_nvim_lsp()
	vim.api.nvim_create_autocmd("LspAttach", require("lsp.attach").on_lsp_attach())

	vim.api.nvim_create_autocmd("LspProgress", require("lsp.progress").on_lsp_progress())

	vim.diagnostic.config(require("lsp.diagnostics").diagnostic_opts())

	require("lsp.mason").configure_mason_servers()
end

return M
