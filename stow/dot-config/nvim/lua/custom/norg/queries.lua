local M = {}

local MAIN_CAPTURE = "@norg-capture"

local HEADING_TEMPLATE = '(heading$n title: (paragraph_segment) @h$n (#eq? @h$n "$val") $children) $capture'

--- @param path string[]
--- @param level integer
--- @return string?
local function build_heading_query_helper(path, level)
	if level > #path then
		return nil
	end

	local children = build_heading_query_helper(path, level + 1)
	local capture = nil
	if children == nil then
		capture = MAIN_CAPTURE
	end

	local vars = {
		n = level,
		val = path[level],
		children = children,
		capture = capture,
	}
	local query = string.gsub(HEADING_TEMPLATE, "$(%w+)", function(key)
		local val = vars[key]
		if val ~= nil then
			return val
		else
			return ""
		end
	end)

	return query
end

--- @param path string[]
--- @return string
function M.build_heading_query(path)
	local query = "(" .. build_heading_query_helper(path, 1) .. ")"

	return query
end

return M
