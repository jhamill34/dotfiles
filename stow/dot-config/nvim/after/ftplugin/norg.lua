vim.o.wrap = false

local ts_query = require("custom.treesitter")

local function format_norg()
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_feedkeys("gg=G", "n", true)

	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, cursor)
	end)
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*.norg",
	callback = format_norg,
})

JIRA_HEADING_QUERY = [[
((heading1 
        title: (paragraph_segment) @h1 (#eq? @h1 "Worklog")
        (heading2 
            title: (paragraph_segment) @h2 (#eq? @h2 "Jira")) @norg-capture )) 
]]

local function get_jira_description() end

local function fetch_jira_description()
	local win = vim.api.nvim_get_current_win()
	local curbuf = vim.api.nvim_get_current_buf()

	local tsq = ts_query.new_ts_query({
		curbuf = curbuf,
		filetype = "norg",
	})

	tsq:handle_nodes(JIRA_HEADING_QUERY, function(node)
		local _, _, er, ec = node:range()

		local currentfile = vim.api.nvim_buf_get_name(curbuf)
		local dirname = vim.fs.dirname(currentfile)
		local issuename = vim.fs.basename(dirname)

		local cmd = '/opt/homebrew/bin/jira issue view "' .. issuename .. '" --raw'

		local handle, err = io.popen(cmd, "r")
		local result = ""
		if err ~= nil then
			result = "Error " .. err
		elseif handle ~= nil then
			result = handle:read("*a")
			handle:close()
		end

		vim.api.nvim_buf_set_text(curbuf, er, ec, er, ec, { result, "", "" })
		format_norg()
	end)
end

local function pass_terminal()
	local temp_buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_name(temp_buf, "Password Terminal")

	local height = vim.api.nvim_win_get_height(0)
	local width = vim.api.nvim_win_get_width(0)
	local float_win = vim.api.nvim_open_win(temp_buf, true, {
		win = 0,
		split = "below",
		relative = "win",
		width = math.floor(width / 2),
		height = math.floor(height / 2),
		row = math.floor(height / 4),
		col = math.floor(width / 4),
		border = "rounded",
		focusable = true,
	})

	vim.api.nvim_chan_send(term_chan_id, "echo 'hello world'\\n")
end

vim.keymap.set("n", "<leader>rjd", fetch_jira_description, { desc = "Neo[r]g Fetch [j]ira [d]escription" })
vim.keymap.set("n", "<leader>rpt", pass_terminal, { desc = "Neo[r]g [p]ass [t]erminal" })

-- local function fetch_jira_comments() end
--
-- local function fetch_journal_entries() end
