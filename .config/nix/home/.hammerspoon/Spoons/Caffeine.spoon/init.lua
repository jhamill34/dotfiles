local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Caffeine"
obj.version = "0.1"
obj.author = "Joshua Hamill <joshrasmussen34@gmail.com>"
obj.homepage = "https://github.com/jhamill34"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.leader = "ctrl"

function obj.setCaffeineDisplay(state)
	if state then
		caffeine:setTitle("󰅶")
	else
		caffeine:setTitle("󰛊")
	end
end

function obj.caffeineClicked()
	obj.setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

function obj:start()
	caffeine = hs.menubar.new()
	hs.hotkey.bind(self.leader, "c", obj.caffeineClicked)
end

return obj
