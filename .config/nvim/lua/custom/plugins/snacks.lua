return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			dashboard = { example = "files" },
			explorer = { enabled = true },
			-- image = { },
			-- git = { enabled = true },
			-- gitbrowse = { enabled = true },
			-- lazygit = { enabled = true },
			-- bigfile = { enabled = true },
			-- indent = { enabled = true },
			-- input = { enabled = true },
			-- picker = { enabled = true },
			-- notify = { enabled = true },
			-- notifier = { enabled = true },
			-- quickfile = { enabled = true },
			-- scope = { enabled = true },
			-- scroll = { enabled = true },
			statuscolumn = { enabled = true },
			-- terminal = { enabled = true },
			-- words = { enabled = true },
		},
		keys = {
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
		},
	},
}
