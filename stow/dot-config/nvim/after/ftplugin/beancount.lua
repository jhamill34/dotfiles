local bc_utils = require("custom.beancount.utils")

vim.lsp.config("beancount", {
	init_options = {
		journal_file = bc_utils.get_journal_root_file(),
		formatting = {
			prefix_width = 30,
			currency_column = 60,
			number_currency_spacing = 1,
		},
	},
})

vim.keymap.set("n", "<leader>bdo", bc_utils.select_and_open_document_nodes, { desc = "[b]eancount [d]ocument [o]open" })
vim.keymap.set("n", "<leader>bt", bc_utils.select_transaction, { desc = "[b]eancount [t]ransaction" })
vim.keymap.set("n", "<leader>ba", bc_utils.list_accounts, { desc = "[b]eancount [a]ccounts" })
