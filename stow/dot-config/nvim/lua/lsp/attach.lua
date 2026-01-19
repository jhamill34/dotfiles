local M = {}

--- @class SupprtedMethodGuard
--- @field client vim.lsp.Client
--- @field method vim.lsp.protocol.Method
--- @field event vim.api.keyset.create_autocmd.callback_args
--- @field callback fun(event: vim.api.keyset.create_autocmd.callback_args)

-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
--- @param opts SupprtedMethodGuard
local function client_supports_method(opts)
	local client = opts.client
	if client:supports_method(opts.method, opts.event.buf) then
		opts.callback(opts.event)
	end
end

--- @param buf number
local function lsp_keybinds(buf)
	vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = buf, desc = "LSP: [R]e[n]ame" })
	vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { buffer = buf, desc = "LSP: [G]oto Code [A]ction" })
end

--- @param event vim.api.keyset.create_autocmd.callback_args
local function register_hightlight_refs(event)
	local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = event.buf,
		group = highlight_augroup,
		callback = vim.lsp.buf.document_highlight,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		buffer = event.buf,
		group = highlight_augroup,
		callback = vim.lsp.buf.clear_references,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
		callback = function(event2)
			vim.lsp.buf.clear_references()
			vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
		end,
	})
end

--- @return vim.api.keyset.create_autocmd
function M.on_lsp_attach()
	--- @type vim.api.keyset.create_autocmd
	local opts = {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = function(event)
			lsp_keybinds(event.buf)

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client then
				client_supports_method({
					client = client,
					method = vim.lsp.protocol.Methods.textDocument_documentHighlight,
					event = event,
					callback = register_hightlight_refs,
				})

				client_supports_method({
					client = client,
					method = vim.lsp.protocol.Methods.textDocument_inlayHint,
					event = event,
					callback = function()
						vim.keymap.set("n", "<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, { desc = "LSP: [T]oggle Inlay [H]ints" })
					end,
				})
			end
		end,
	}

	return opts
end

return M
