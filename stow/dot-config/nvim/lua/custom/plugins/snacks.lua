-- Generate ASCII Art here -> https://patorjk.com/software/taag/
local dclm_dev = [[
██████╗  ██████╗██╗     ███╗   ███╗
██╔══██╗██╔════╝██║     ████╗ ████║
██║  ██║██║     ██║     ██╔████╔██║
██║  ██║██║     ██║     ██║╚██╔╝██║
██████╔╝╚██████╗███████╗██║ ╚═╝ ██║
╚═════╝  ╚═════╝╚══════╝╚═╝     ╚═╝]]

local mickey = [[
 █████╗   █████╗ 
███████╗ ███████╗
███████║ ███████║
 █████╔╝  █████╔╝
 ╚═██████████══╝ 
  ████████████╗  
  ████████████║  
  ████████████║  
    ████████╔═╝  
    ╚═══════╝    ]]

local jhamill = [[
     ██╗██╗  ██╗ █████╗ ███╗   ███╗██╗██╗     ██╗     
     ██║██║  ██║██╔══██╗████╗ ████║██║██║     ██║     
     ██║███████║███████║██╔████╔██║██║██║     ██║     
██   ██║██╔══██║██╔══██║██║╚██╔╝██║██║██║     ██║     
╚█████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║██║███████╗███████╗
 ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝ ]]

local function get_header()
	local user = vim.fn.expand("$USER")
	if user == "josh.hamill.-nd" then
		return mickey .. "\n\n" .. dclm_dev
	end

	return jhamill
end

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
			dashboard = {
				width = 80,
				preset = {
					header = get_header(),
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{
						pane = 2,
						icon = "󰌃 ",
						desc = "Browse Issues",
						padding = 1,
						key = "i",
						action = function()
							vim.fn.jobstart("jira_open.sh", { detach = true })
						end,
					},
					function()
						local cmds = {
							{
								icon = " ",
								title = "Jira Issues",
								cmd = "jira_summary.sh || true",
								height = 7,
							},
						}

						return vim.tbl_map(function(cmd)
							return vim.tbl_extend("force", {
								pane = 2,
								section = "terminal",
								padding = 1,
								indent = 3,
								ttl = 0,
							}, cmd)
						end, cmds)
					end,
					{
						pane = 2,
						icon = " ",
						desc = "Browse Repo",
						padding = 1,
						key = "b",
						action = function()
							Snacks.gitbrowse()
						end,
					},
					function()
						local in_git = Snacks.git.get_root() ~= nil
						local cmds = {
							{
								icon = " ",
								title = "Open PRs",
								cmd = "gh pr list -L 3 || true",
								key = "P",
								action = function()
									vim.fn.jobstart("gh pr list --web", { detach = true })
								end,
								height = 7,
							},
							{
								icon = " ",
								title = "Git Status",
								cmd = "jj st --no-pager || true",
								height = 10,
							},
						}
						return vim.tbl_map(function(cmd)
							return vim.tbl_extend("force", {
								pane = 2,
								section = "terminal",
								enabled = in_git,
								padding = 1,
								ttl = 5 * 60,
								indent = 3,
							}, cmd)
						end, cmds)
					end,
					{ section = "startup" },
				},
			},
			explorer = { enabled = true },
			image = {
				enabled = true,
				doc = {
					inline = false,
					float = true,
					max_width = 80,
					max_height = 40,
				},
				cache = vim.fn.stdpath("cache") .. "/snacks/images",
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
			indent = { enabled = true },
			-- input = { enabled = true },
			picker = { enabled = true },
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
				"<leader><space>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
			{
				"<leader>,",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>/",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>n",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notification History",
			},
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
			-- find
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fc",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent",
			},
			-- Grep
			{
				"<leader>sf",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sB",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "Grep Open Buffers",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			-- search
			{
				'<leader>s"',
				function()
					Snacks.picker.registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>s/",
				function()
					Snacks.picker.search_history()
				end,
				desc = "Search History",
			},
			{
				"<leader>sa",
				function()
					Snacks.picker.autocmds()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>sD",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>sH",
				function()
					Snacks.picker.highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>si",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons",
			},
			{
				"<leader>sj",
				function()
					Snacks.picker.jumps()
				end,
				desc = "Jumps",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sl",
				function()
					Snacks.picker.loclist()
				end,
				desc = "Location List",
			},
			{
				"<leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>sM",
				function()
					Snacks.picker.man()
				end,
				desc = "Man Pages",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
			{
				"<leader>su",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo History",
			},
			{
				"<leader>uC",
				function()
					Snacks.picker.colorschemes()
				end,
				desc = "Colorschemes",
			},
			-- -- LSP
			{
				"grd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"grD",
				function()
					Snacks.picker.lsp_declarations()
				end,
				desc = "Goto Declaration",
			},
			{
				"grr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gri",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"grt",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Symbols",
			},
			{
				"<leader>sS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},
			{
				"<leader>gs",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gg",
				function()
					Snacks.dashboard()
				end,
				desc = "Goto Dashboard",
			},
		},
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
