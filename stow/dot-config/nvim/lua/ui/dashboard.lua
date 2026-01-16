local t = require("ui.title")

return {
	width = 80,
	preset = {
		header = t.get_header(),
	},
	sections = {
		{ section = "header" },
		{ section = "keys", gap = 1, padding = 1 },
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
}
