local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Launcher"
obj.version = "0.1"
obj.author = "Joshua Hamill <joshrasmussen34@gmail.com>"
obj.homepage = "https://github.com/jhamill34"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.leader = "ctrl"
obj.bundleFn = function(app)
	return app
end
obj.mappings = {}

-- App Shortcuts
function obj.openApp(bundleId)
	return function()
		hs.application.launchOrFocusByBundleID(bundleId)
	end
end

function obj:start()
	for _, mapping in ipairs(self.mappings) do
		local bundle = self.bundleFn(mapping.app)
		hs.hotkey.bind(self.leader, mapping.key, obj.openApp(bundle))
	end
end

return obj
