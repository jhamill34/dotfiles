-- Go here for help: https://github.com/nvim-neorg/neorg/wiki
return {
	"tpope/vim-speeddating",
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*",
		dependencies = {
			{ "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
			{ "pritchett/neorg-capture" },
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
					["core.esupports.indent"] = {},
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
							},
						},
						-- default_subcommand = "add", -- or "fload", "load"
						-- snippets_overwrite = {},
					},
					["external.capture"] = {
						config = {
							templates = {
								{
									-- TODO: Create a mechanism to use Snacks.input to prompt for the project to add a quick note to
									description = "Quick Note", -- What will be shown when invoked
									name = "note", -- Name of the neorg-templates template.
									file = function()
										local dirman = require("neorg").modules.get_module("core.dirman")
										local default = "~/Notes/captures.norg"

										if dirman ~= nil then
											local notes = dirman.get_workspace("notes")

											if notes ~= nil then
												return notes .. "/captures.norg"
											else
												return default
											end
										end

										return default
									end,

									enabled = function() -- Either a function or boolean value. Default is true.
										return true -- If false, it will not be shown in the list when invoked.
									end,

									datetree = true, -- Save the capture into a datetree. Default is false
									headline = "Quick Notes", -- If set, will save the caputure under this headline
								},
							},
						},
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
