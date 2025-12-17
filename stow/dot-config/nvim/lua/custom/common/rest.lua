local M = {}

--- @class HttpCallOpts
--- @field host string
--- @field path string[]
--- @field method string?
--- @field auth fun(): string
--- @field headers table<string, string[]>?
--- @field body table<string, any>?
--- @field on_response fun(body: any)

--- @param opts HttpCallOpts
function M.http_call(opts)
	local method = opts.method or "GET"
	local cmd = { "curl", "-X", method, "-H", '"Content-Type: application/json"' }

	if opts.headers ~= nil then
		for key, vals in pairs(opts.headers) do
			if key ~= "Authorization" or key ~= "authorization" then
				for _, val in ipairs(vals) do
					table.insert(cmd, "-H")
					table.insert(cmd, '"' .. key .. ": " .. val .. '"')
				end
			end
		end
	end

	if opts.auth ~= nil then
		local auth = opts.auth()
		table.insert(cmd, "-H")
		table.insert(cmd, '"Authorization: ' .. auth .. '"')
	end

	if opts.body ~= nil then
		local request_body = vim.json.encode(opts.body)
		table.insert(cmd, "-d")
		table.insert(cmd, "'" .. request_body .. "'")
	end

	local endpoint = opts.host .. "/" .. table.concat(opts.path, "/")
	table.insert(cmd, endpoint)

	local serialized_cmd = table.concat(cmd, " ")
	vim.fn.jobstart(serialized_cmd, {
		on_stdout = function(_, d)
			if d and d[1] ~= "" then
				opts.on_response(d[1])
			end
		end,
		stdout_buffered = true,
	})
end

return M
