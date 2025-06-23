-- Go here for help: https://github.com/nvim-neorg/neorg/wiki
return {
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

			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
		end,
	},
}
