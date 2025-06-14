local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Caffeine"
obj.version = "0.1"
obj.author = "Joshua Hamill <joshrasmussen34@gmail.com>"
obj.homepage = "https://github.com/jhamill34"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.leader = "ctrl"

function obj:start()
	local caffeine = hs.menubar.new()
	hs.hotkey.bind(self.leader, "c", function()
		local state = hs.caffeinate.toggle("displayIdle")
		if state then
			caffeine:setTitle("󰅶")
		else
			caffeine:setTitle("󰛊")
		end
	end)
end

return obj
