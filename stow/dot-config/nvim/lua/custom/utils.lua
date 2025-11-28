local M = {}

--- @param val string
--- @return string?
local function make_hash(val)
	local cmd = 'echo -n "' .. val .. "\" | sha256sum | awk '{ print $1 }'"
	local hash_handle = io.popen(cmd, "r")
	if hash_handle ~= nil then
		local result = hash_handle:read("*a")
		hash_handle:close()

		return result:gsub("\n", "")
	end

	return nil
end

--- @class CacheOpts
--- @field directory string
--- @field ttl integer

--- @class CacheType: CacheOpts
local Cache = {}
Cache.__index = Cache

--- @param opts CacheOpts
--- @return CacheType
function Cache.new(opts)
	--- @type CacheType
	local instance = {
		directory = opts.directory,
		ttl = opts.ttl,
	}
	setmetatable(instance, Cache)
	return instance
end

--- @param key string
--- @param callback fun(filename: string)
function Cache:with_cachable_file(key, callback)
	vim.fn.mkdir(self.directory, "p")

	local hash = make_hash(key)

	if hash then
		local cache_file = self.directory .. "/" .. hash
		callback(cache_file)
	end
end

function Cache:clean_cache()
	local result = vim.fs.find(function(name)
		return name:match(".*")
	end, {
		path = self.directory,
	})

	for _, f in pairs(result) do
		local now = os.time()

		local timeout = now - self.ttl
		local stat = vim.uv.fs_stat(f)
		local last_accessed = stat and stat.ctime and stat.ctime.sec or 0

		if last_accessed < timeout then
			vim.fs.rm(f)
			-- vim.notify("Deleted " .. f)
		end
	end
end

M.new_cache = Cache.new

return M
