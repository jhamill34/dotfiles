local M = {}

local servers = require("lsp.servers").mason_servers

function M.configure_mason_servers()
	local capabilities = require("blink.cmp").get_lsp_capabilities()

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua", -- Used to format Lua code
	})
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	require("mason-lspconfig").setup({
		-- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
		ensure_installed = {},
		automatic_installation = false,
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end

return M
