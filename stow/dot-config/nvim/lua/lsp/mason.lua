local M = {}

local servers = require("lsp.servers").mason_servers

function M.configure_mason_servers()
	local capabilities = require("blink.cmp").get_lsp_capabilities()

	vim.lsp.config("*", { capabilities = capabilities })

	for server_name, server in pairs(servers) do
		vim.lsp.config(server_name, server)
	end

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua",
	})
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	require("mason-lspconfig").setup()
end

return M
