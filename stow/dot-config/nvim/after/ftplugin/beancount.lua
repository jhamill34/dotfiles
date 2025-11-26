local DOC_QUERY = [[
    ((document filename: (filename (string) @bean-capture)))
]]

local function create_txn_query()
	return [[
        (
            (transaction 
                date: (date)
                narration: (narration)
                (posting 
                    account: (account)
                    amount: (incomplete_amount))) @bean-capture )
    ]]
end

local function get_root(curbuf)
	vim.fn.bufload(curbuf)
	local parser = vim.treesitter.get_parser(curbuf, "beancount")
	if parser == nil then
		return nil
	end

	local tree = parser:parse()[1]
	return tree:root()
end

local function get_journal_root_file()
	local result = vim.fs.find(function(name)
		return name:match(".*%.bean")
	end, { path = vim.fn.getcwd(), type = "file" })

	if #result == 0 then
		return nil
	end

	return result[1]
end

local function handle_nodes(curbuf, root, query_str, cb)
	local query = vim.treesitter.query.parse("beancount", query_str)
	for id, node, _ in query:iter_captures(root, curbuf) do
		node:iter_children()
		if query.captures[id] == "bean-capture" then
			cb(node)
		end
	end
end

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

local function extract_text_from_buffer(buffer, node, exclude_quotes)
	local sr, sc, er, ec = node:range()

	if exclude_quotes then
		sc = sc + 1
		ec = ec - 1
	end
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

local function handle_postings(buffer, node)
	local iter = node:iter_children()
	local posting = {}

	for _ = 1, node:child_count() do
		local child, field = iter()
		if field == "account" then
			posting.account = extract_text_from_buffer(buffer, child, false)
		elseif field == "amount" then
			posting.account = extract_text_from_buffer(buffer, child, false)
		end
	end

	return posting
end

local function handle_txn(buffer, node)
	local iter = node:iter_children()
	local txn = {}
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

local function select_transaction()
	local win = vim.api.nvim_get_current_win()
	local curbuf = vim.api.nvim_get_current_buf()
	local root = get_root(curbuf)
	if root == nil then
		vim.ui.notify("Unable to find beancount root node")
		return
	end

	local query_str = create_txn_query()
	local txns = {}
	handle_nodes(curbuf, root, query_str, function(node)
		local txn = handle_txn(curbuf, node)
		table.insert(txns, txn)
	end)

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

local function select_and_open_document_nodes()
	local curbuf = vim.api.nvim_get_current_buf()
	local dirname = vim.fs.dirname(vim.api.nvim_buf_get_name(curbuf))

	local root = get_root(curbuf)
	if root == nil then
		vim.ui.notify("Unable to find beancount root node")
		return
	end

	local files = {}
	handle_nodes(curbuf, root, DOC_QUERY, function(node)
		local lines = extract_text_from_buffer(curbuf, node, true)
		local resolved_file = vim.fs.normalize(dirname .. "/" .. lines.text)
		if string.find(resolved_file, ".pdf") ~= nil then
			table.insert(files, resolved_file)
		end
	end)

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

local function makeHash(val)
	local cmd = 'echo -n "' .. val .. "\" | sha256sum | awk '{ print $1 }'"
	local hash_handle = io.popen(cmd, "r")
	if hash_handle ~= nil then
		local result = hash_handle:read("*a")
		hash_handle:close()

		return result:gsub("\n", "")
	end

	return nil
end

local function list_accounts()
	local query = "select account, sum(cost(position)) group by account order by account"
	local query_hash = makeHash(query)

	local exe = "bean-query"
	local journal_bean_file = "/Users/joshuahamill/Code/Personal/beancounting/hamfam.bean"

	local output_dir = vim.env.XDG_DATA_HOME .. "/bean"
	vim.fn.mkdir(output_dir, "p")

	-- TODO: We need a way to expire this call? Or purge old values?
	--  I think we can get away with not having a TTL (i.e. re generate the result every time)
	--  but we should purge old files we don't want
	local output_file = query_hash .. "_" .. vim.fs.basename(journal_bean_file)
	local flags = '--format text --output "' .. output_dir .. "/" .. output_file .. '"'
	local cmd = exe .. " " .. journal_bean_file .. " " .. flags

	local handler = io.popen(cmd, "w")
	if handler ~= nil then
		handler:write(query)
		handler:close()
	end

	local fp = io.open(output_dir .. "/" .. output_file, "r")
	if fp ~= nil then
		for l in fp:lines("*l") do
			vim.notify(l)
		end
	end
end

vim.lsp.config("beancount", {
	init_options = {
		journal_file = get_journal_root_file(),
		formatting = {
			prefix_width = 30,
			currency_column = 60,
			number_currency_spacing = 1,
		},
	},
})

vim.keymap.set("n", "<leader>bdo", select_and_open_document_nodes, { desc = "[b]eancount [d]ocument [o]open" })
vim.keymap.set("n", "<leader>bt", select_transaction, { desc = "[b]eancount [t]ransaction" })
