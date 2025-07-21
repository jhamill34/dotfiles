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
			image = {
				doc = {
					enabled = true,
					inline = true,
				},
				cache = vim.fn.stdpath("cache") .. "/snacks/image",
				convert = {
					notify = true, -- show a notification on error
					magick = {
						default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
						vector = { "-density", 192, "{src}[0]" }, -- used by vector images like svg
						math = { "-density", 192, "{src}[0]", "-trim" },
						pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
					},
				},
				math = {
					enabled = true, -- enable math expression rendering
					-- in the templates below, `${header}` comes from any section in your document,
					-- between a start/end header comment. Comment syntax is language-specific.
					-- * start comment: `// snacks: header start`
					-- * end comment:   `// snacks: header end`
					typst = {
						tpl = [[
                            #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
                            #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
                            #set text(size: 12pt, fill: rgb("${color}"))
                            ${header}
                            ${content}]],
					},
				},
			},
			statuscolumn = { enabled = true },
			-- git = { enabled = true },
			-- gitbrowse = { enabled = true },
			lazygit = { enabled = true },
			-- bigfile = { enabled = true },
			-- indent = { enabled = true },
			-- input = { enabled = true },
			-- picker = { enabled = true },
			notify = {
				enabled = true,
			},
			notifier = {
				enabled = true,
			},
			-- quickfile = { enabled = true },
			-- scope = { enabled = true },
			-- scroll = { enabled = true },
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
			{
				"<leader>gs",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
		},
	},
}
