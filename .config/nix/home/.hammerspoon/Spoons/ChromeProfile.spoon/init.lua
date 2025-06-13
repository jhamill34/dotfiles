local obj = {}
obj.__index = obj

-- Metadata
obj.name = "ChromeProfile"
obj.version = "0.1"
obj.author = "Joshua Hamill <joshrasmussen34@gmail.com>"
obj.homepage = "https://github.com/jhamill34"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.leader = "ctrl"

--
-- Example:
-- chromeProfile.profiles = {
-- 	<name> = {
-- 		location = "Default",
-- 		menuPath = { "Profiles", "Joshua (Personal)" },
-- 		urls = os.getenv("HOME") .. "/.config/personal_urls.txt",
-- 		key = "7",
-- 	},
-- }

obj.profiles = {}

function obj.chromeProfile(profile)
	return function(url)
		hs.task
			.new("/usr/bin/open", nil, {
				"-n",
				"-a",
				"Google Chrome",
				"--args",
				"--profile-directory=" .. profile,
				url,
			})
			:start()
	end
end

function obj.chromeProfileBlank(profile)
	hs.task
		.new("/usr/bin/open", nil, {
			"-n",
			"-a",
			"Google Chrome",
			"--args",
			"--profile-directory=" .. profile,
			"https://google.com",
		})
		:start()
end

function obj:start()
	for _, value in pairs(self.profiles) do
		hs.hotkey.bind(self.leader, value.key, function()
			self.chromeProfileBlank(value.location)
		end)
	end
end

function obj:patterns()
	local result = {}
	local i = 0
	for _, value in pairs(self.profiles) do
		result[i] = { value.urls, self.chromeProfile(value.location) }
		i = i + 1
	end
	return result
end

return obj
