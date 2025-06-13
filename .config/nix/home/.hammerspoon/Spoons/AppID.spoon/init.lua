local obj = {}
obj.__index = obj

-- Metadata
obj.name = "AppID"
obj.version = "0.1"
obj.author = "Joshua Hamill <joshrasmussen34@gmail.com>"
obj.homepage = "https://github.com/jhamill34"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj.appID(app)
	if hs.application.infoForBundlePath(app) then
		return hs.application.infoForBundlePath(app)["CFBundleIdentifier"]
	end
end

return obj
