-- Go here for help: https://github.com/nvim-neorg/neorg/wiki
return {
	"tpope/vim-speeddating",
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*",
		dependencies = {
			{ "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
			{ "tamton-aquib/neorg-jupyter" },
		},
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
							journal_folder = "Daily-Notes",
						},
					},
					["core.export"] = {},
					["core.todo-introspector"] = {},
					["core.itero"] = {},
					["core.qol.todo_items"] = {},
					["core.esupports.indent"] = {
						config = {
							dedent_excess = true,
							format_on_enter = true,
							format_on_escape = true,
						},
					},
					["core.esupports.metagen"] = {
						config = {
							type = "none",
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
					["external.templates"] = {
						config = {
							keywords = { -- Add your own keywords.
								TODAY_IN_NORG = function() -- print current date+time of invoke
									local ls = require("luasnip")
									local s = require("neorg.modules.external.templates.default_snippets")
									return ls.text_node(s.parse_date(0, os.time(), [[%A %d %B %Y]]))
								end,
								NOW = function() -- print current date+time of invoke
									local ls = require("luasnip")
									local s = require("neorg.modules.external.templates.default_snippets")
									return ls.text_node(s.parse_date(0, os.time(), [[%H:%M:%S]]))
								end,
								sc,
							},
						},
						-- default_subcommand = "add", -- or "fload", "load"
						-- snippets_overwrite = {},
					},
					["external.jupyter"] = {},
				},
			})

			vim.keymap.set("n", "<leader>rr", "<cmd>Neorg journal today<CR>", { desc = "Open [j]ournal [t]oday" })
			vim.keymap.set("n", "<leader>re", "<cmd>Neorg journal custom<CR>", { desc = "Open [j]ournal yesterday" })
			vim.keymap.set("n", "<leader>rw", "<cmd>Neorg journal yesterday<CR>", { desc = "Open [j]ournal yesterday" })

			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
		end,
	},
}
