local norg_utils = require("custom.norg.utils")
local jira = require("custom.jira.api")

vim.o.wrap = false

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*.norg",
	callback = norg_utils.format_norg,
})

local fetch_jira_comments = function()
	local buf = vim.api.nvim_get_current_buf()
	local issue_key = jira.get_issue_from_buffer_dir(buf)
	if issue_key ~= nil then
		jira.get_issue(issue_key, function(data)
			local comments = data["fields"]["comment"]["comments"]

			local lines = {}
			for i, comment in ipairs(comments) do
				table.insert(lines, "*" .. i .. ". " .. comment["author"]["name"] .. " @" .. comment["updated"] .. "*")
				for l in string.gmatch(comment["body"], "([^\n]+)") do
					local clean = string.gsub(l, "\r", "")
					table.insert(lines, clean)
				end
				table.insert(lines, "")
			end

			table.insert(lines, "")
			table.insert(lines, "")

			norg_utils.insert_at_header_path({ "Worklog", "Jira Comments" }, lines)
		end)
	else
		vim.notify("Can't figure jira issue from path")
	end
end

vim.keymap.set("n", "<leader>rjc", fetch_jira_comments, { desc = "Neo[r]g Fetch [j]ira [c]omments" })
-- local function fetch_jira_comments() end
-- local function fetch_journal_entries() end
