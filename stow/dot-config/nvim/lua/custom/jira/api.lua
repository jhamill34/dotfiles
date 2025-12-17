local pm = require("custom.common.pass")
local rest = require("custom.common.rest")

local M = {}

--- @class GetIssueFromDirOpts
--- @field prefix string?
--- @field url string?

--- @param buf integer
--- @param opts GetIssueFromDirOpts?
--- @return string?
function M.get_issue_from_buffer_dir(buf, opts)
	opts = opts or {
		prefix = os.getenv("JIRA_PROJECT_KEY"),
	}

	local currentfile = vim.api.nvim_buf_get_name(buf)
	local dir = vim.fs.dirname(currentfile)
	local dirname = vim.fs.basename(dir)

	if dirname:sub(1, #opts.prefix) == opts.prefix then
		return dirname
	end

	return nil
end

--- @param issue string
--- @param callback fun(data: table<string, any>)
function M.get_issue(issue, callback)
	local host = os.getenv("JIRA_URL")

	if host == nil then
		vim.notify("JIRA_URL must be set")
		return
	end

	pm.get_pass({
		password_name = "Jira/AccessToken",
		cache_ttl = 60000,
		on_success = function(pass)
			rest.http_call({
				host = host,
				path = { "rest", "api", "2", "issue", issue },
				auth = function()
					return "Bearer " .. pass
				end,
				on_response = function(data)
					local parsed = vim.json.decode(data)
					callback(parsed)
				end,
			})
		end,
	})
end

return M
