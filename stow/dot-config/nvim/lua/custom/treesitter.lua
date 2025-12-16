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

--- @param query_str string
--- @param cb fun(node: TSNode)
function TSQuery:handle_nodes(query_str, cb)
	local query = vim.treesitter.query.parse(self.filetype, query_str)
	local capture_id = self.filetype .. "-capture"
	for id, node, _ in query:iter_captures(self.root, self.curbuf) do
		if query.captures[id] == capture_id then
			cb(node)
		end
	end
end

--- @param query_str string
--- @param cb fun(node: TSNode, capture: string)
function TSQuery:find_nodes(query_str, cb)
	local query = vim.treesitter.query.parse(self.filetype, query_str)

	for id, node, _ in query:iter_captures(self.root, self.curbuf) do
		local capture = query.captures[id]
		cb(node, capture)
	end
end

M.new_ts_query = TSQuery.new

return M
