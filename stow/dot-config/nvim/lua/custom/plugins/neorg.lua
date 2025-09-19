-- Go here for help: https://github.com/nvim-neorg/neorg/wiki
return {
	"tpope/vim-speeddating",
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*",
		config = function()
			require("neorg").setup({
				load = {
					["core.autocommands"] = {},
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.keybinds"] = {},
					["core.ui"] = {},
					["core.ui.calendar"] = {},
					["core.journal"] = {
						config = {
							journal_folder = "Daily Notes",
						},
					},
					["core.export"] = {},
					["core.todo-introspector"] = {},
					["core.itero"] = {},
					["core.qol.todo_items"] = {},
					["core.esupports.indent"] = {},
					["core.esupports.metagen"] = {
						config = {
							type = "auto",
						},
					},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/Notes",
							},
							default_workspace = "notes",
						},
					},
				},
			})

			vim.keymap.set("n", "<leader>rr", "<cmd>Neorg journal today<CR>", { desc = "Open [j]ournal [t]oday" })
			vim.keymap.set("n", "<leader>re", "<cmd>Neorg journal yesterday<CR>", { desc = "Open [j]ournal yesterday" })

			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
		end,
	},
}
