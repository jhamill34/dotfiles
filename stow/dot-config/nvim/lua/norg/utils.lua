local M = {}

local norg_queries = require("norg.queries")
local ts_query = require("common.treesitter")

function M.format_norg()
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_feedkeys("gg=G", "n", true)

	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, cursor)
	end)
end

--- @param path string[]
--- @param lines string[]
function M.insert_at_header_path(path, lines)
	local curbuf = vim.api.nvim_get_current_buf()

	local tsq = ts_query.new_ts_query({
		curbuf = curbuf,
		filetype = "norg",
	})

	local jira_query = norg_queries.build_heading_query(path)

	local _, loc = tsq:find_captures(jira_query)()

	vim.api.nvim_buf_set_text(curbuf, loc.start_row + 1, loc.start_col, loc.end_row, loc.end_col, lines)

	M.format_norg()
end

return M
