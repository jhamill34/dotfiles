local M = {}

--- @class PasswordCacheEntry
--- @field value string
--- @field timer uv.uv_timer_t

--- @type table<string, PasswordCacheEntry>
local cache = {}

--- @class GetPassOpts
--- @field on_success fun(pass: string, cached: boolean)
--- @field password_name string
--- @field on_expired fun(pass: string)?
--- @field prompt string?
--- @field force boolean?
--- @field cache_ttl number?

--- @param opts GetPassOpts
function M.get_pass(opts)
	local password_name = opts.password_name
	local force = opts.force

	if cache[password_name] ~= nil then
		if force then
			cache[password_name].timer:stop()
		else
			opts.on_success(cache[password_name].value, true)
			return
		end
	end

	local cache_ttl = opts.cache_ttl
	local on_expired = opts.on_expired
	local job_id = vim.fn.jobstart("pass " .. password_name, {
		env = {
			PASSWORD_STORE_GPG_OPTS = "--pinentry-mode loopback --passphrase-fd 0",
		},
		on_stdout = function(_, d)
			if d and d[1] ~= "" then
				local pass = d[1]
				if cache_ttl then
					local timer = vim.uv.new_timer()
					if timer then
						cache[password_name] = {
							value = pass,
							timer = timer,
						}

						timer:start(cache_ttl, 0, function()
							cache[password_name] = nil

							if on_expired then
								on_expired(password_name)
							end
						end)
					end
				end

				opts.on_success(pass, false)
			end
		end,
		stdout_buffered = true,
	})

	local prompt = opts.prompt or "Password PIN: "
	local pin = vim.fn.inputsecret(prompt)
	vim.api.nvim_echo({ { "", "" } }, false, {})

	vim.fn.chansend(job_id, { pin, "" })
end

return M
