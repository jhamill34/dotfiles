local bc_queries = require("custom.beancount.queries")
local ts_query = require("custom.common.treesitter")

local M = {}

--- @param item string
--- @return string
local function format_file_path(item)
	local parts = {}
	for m in string.gmatch(item, "([^/]+)") do
		table.insert(parts, m)
	end

	if #parts < 3 then
		return item
	end

	return "../" .. table.concat(parts, "/", #parts - 2, #parts)
end

--- @param buffer integer
--- @param node TSNode
--- @param exclude_quotes boolean
--- @return BufferText
local function extract_text_from_buffer(buffer, node, exclude_quotes)
	local sr, sc, er, ec = node:range()

	if exclude_quotes then
		sc = sc + 1
		ec = ec - 1
	end

	--- @type BufferText
	local result = {}
	result.text = vim.api.nvim_buf_get_text(buffer, sr, sc, er, ec, {})[1]
	result.range = {
		start_row = sr,
		start_col = sc,
		end_row = er,
		end_col = ec,
	}

	return result
end

--- @param buffer integer
--- @param node TSNode
--- @return BeanPosting
local function handle_postings(buffer, node)
	local iter = node:iter_children()

	--- @type BeanPosting
	local posting = {}

	for _ = 1, node:child_count() do
		local child, field = iter()
		if field == "account" then
			posting.account = extract_text_from_buffer(buffer, child, false)
		elseif field == "amount" then
			posting.amount = extract_text_from_buffer(buffer, child, false)
		end
	end

	return posting
end

--- @param buffer integer
--- @param node TSNode
--- @return BeanTransaction
local function handle_txn(buffer, node)
	local iter = node:iter_children()

	--- @type BeanTransaction
	local txn = {}

	--- @type BeanPosting[]
	local postings = {}

	for _ = 1, node:child_count() do
		local child, field = iter()
		if field == "narration" then
			txn.narration = extract_text_from_buffer(buffer, child, true)
		elseif field == "date" then
			txn.date = extract_text_from_buffer(buffer, child, false)
		elseif field == "txn" then
			txn.txn = extract_text_from_buffer(buffer, child, false)
		else
			table.insert(postings, handle_postings(buffer, child))
		end
	end

	local sr, sc, er, ec = node:range()
	txn.range = {
		start_row = sr,
		start_col = sc,
		end_row = er,
		end_col = ec,
	}
	txn.postings = postings

	return txn
end

--- @return string?
function M.get_journal_root_file()
	local result = vim.fs.find(function(name)
		return name:match(".*%.bean")
	end, { path = vim.fn.getcwd(), type = "file" })

	if #result == 0 then
		return nil
	end

	return result[1]
end

function M.select_transaction()
	local win = vim.api.nvim_get_current_win()
	local curbuf = vim.api.nvim_get_current_buf()

	local tsq = ts_query.new_ts_query({
		curbuf = curbuf,
		filetype = "beancount",
	})

	local txns = {}
	for node, _ in tsq:find_captures(bc_queries.TXN_QUERY) do
		local txn = handle_txn(curbuf, node)
		table.insert(txns, txn)
	end

	vim.ui.select(txns, {
		format_item = function(item)
			return item.date.text .. " - " .. item.narration.text
		end,
	}, function(item)
		if item ~= nil then
			vim.api.nvim_win_set_cursor(win, { item.range.start_row + 1, item.range.start_col })

			-- vim.ui.input({ prompt = "Replace with..." }, function(val)
			-- 	local nr = item.narration.range
			-- 	local replacement = { val }
			-- 	vim.api.nvim_buf_set_text(curbuf, nr.start_row, nr.start_col, nr.end_row, nr.end_col, replacement)
			-- end)
		end
	end)
end

function M.select_and_open_document_nodes()
	local curbuf = vim.api.nvim_get_current_buf()
	local dirname = vim.fs.dirname(vim.api.nvim_buf_get_name(curbuf))

	local tsq = ts_query.new_ts_query({
		curbuf = curbuf,
		filetype = "beancount",
	})

	local files = {}
	for node, _ in tsq:find_captures(bc_queries.DOC_QUERY) do
		local lines = extract_text_from_buffer(curbuf, node, true)
		local resolved_file = vim.fs.normalize(dirname .. "/" .. lines.text)
		if string.find(resolved_file, ".pdf") ~= nil then
			table.insert(files, resolved_file)
		end
	end

	if #files > 0 then
		vim.ui.select(files, {
			format_item = format_file_path,
		}, function(f)
			if f ~= nil then
				os.execute('/usr/bin/open "' .. f .. '"')
			end
		end)
	else
		vim.notify("No documents found")
	end
end

function M.list_accounts()
	local lines = {}
	local obj = vim.system(
		{ "bean-query", "/Users/joshuahamill/Code/Personal/beancounting/hamfam.bean", "--format", "text" },
		{
			text = true,
			stdin = "select distinct account order by account\n",
			stdout = function(_, data)
				if data then
					lines = vim.split(data, "\n")
				end
			end,
		}
	)

	obj:wait()
	vim.ui.select(lines, {}, function(item)
		if item then
			vim.notify(item)
		end
	end)
end

return M
