local M = {}

--- @class TSQueryOpts
--- @field curbuf integer
--- @field filetype string

--- @class TSQueryCls: TSQueryOpts
--- @field root TSNode?
local TSQuery = {}
TSQuery.__index = TSQuery

--- @param opts TSQueryOpts
--- @return TSQueryCls
function TSQuery.new(opts)
	--- @type TSQueryCls
	local instance = {
		curbuf = opts.curbuf,
		filetype = opts.filetype,
	}

	setmetatable(instance, TSQuery)

	vim.fn.bufload(opts.curbuf)
	local parser = vim.treesitter.get_parser(opts.curbuf, opts.filetype)
	if parser == nil then
		return instance
	end

	local tree = parser:parse()[1]
	instance.root = tree:root()

	return instance
end

--- @param node TSNode
--- @return BufferLocation
local function extract_location(node)
	local sr, sc, er, ec = node:range()

	--- @type BufferLocation
	local loc = {
		start_row = sr,
		start_col = sc,
		end_row = er,
		end_col = ec,
	}

	return loc
end

--- @param query_str string
--- @return fun(): (TSNode, BufferLocation)
function TSQuery:find_captures(query_str)
	local query = vim.treesitter.query.parse(self.filetype, query_str)
	local capture_id = self.filetype .. "-capture"

	return coroutine.wrap(function()
		for id, node, _ in query:iter_captures(self.root, self.curbuf) do
			if query.captures[id] == capture_id then
				coroutine.yield(node, extract_location(node))
			end
		end
	end)
end

M.new_ts_query = TSQuery.new

return M
