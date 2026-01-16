return {
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
							require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })
						end,
					},
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"theprimeagen/harpoon",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>a", mark.add_file)
			vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

			vim.keymap.set("n", "<leader>j", function()
				ui.nav_file(1)
			end)
			vim.keymap.set("n", "<leader>k", function()
				ui.nav_file(2)
			end)
			vim.keymap.set("n", "<leader>l", function()
				ui.nav_file(3)
			end)
			vim.keymap.set("n", "<leader>;", function()
				ui.nav_file(4)
			end)
		end,
	},
	{ "simrat39/symbols-outline.nvim" },
	{
		"ravsii/tree-sitter-d2",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		build = "make nvim-install",
	},
	{
		"junegunn/goyo.vim",
		config = function()
			vim.g.goyo_width = 120

			vim.keymap.set("n", "<leader>z", ":Goyo<CR>")
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
					view_options = {
						show_hidden = true,
					},
				},
			})
			vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory" })
			vim.keymap.set("n", "<leader>-", require("oil").toggle_float)
		end,
	},
}
