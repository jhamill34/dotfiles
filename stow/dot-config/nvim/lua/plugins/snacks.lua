--- @module "snacks"

local t = require("ui.title")

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			dashboard = require("ui.dashboard"),
			image = require("ui.image"),
			explorer = { enabled = true },
			statuscolumn = { enabled = true },
			lazygit = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			notify = { enabled = true },
			notifier = { enabled = true },
			scratch = { enabled = true },
		},
		keys = require("ui.keys"),
		styles = {
			snacks_image = {
				relative = "editor",
				border = "rounded",
				focusable = true,
				backdrop = true,
				row = 1,
				col = 1,
			},
		},
	},
}
