local hyper = { "ctrl", "alt", "cmd", "shift" }

-- Window management, move windows around
-- using the hyper key
hs.loadSpoon("MiroWindowsManager")
spoon.MiroWindowsManager:bindHotkeys({
	up = { hyper, "up" },
	right = { hyper, "right" },
	down = { hyper, "down" },
	left = { hyper, "left" },
	fullscreen = { hyper, "f" },
	nextscreen = { hyper, "n" },
})

-- Enable caffeine
local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
	if state then
		caffeine:setTitle("☕")
	else
		caffeine:setTitle("😴")
	end
end

function caffeineClicked()
	setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
	caffeine:setClickCallback(caffeineClicked)
	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end
hs.hotkey.bind(hyper, "c", caffeineClicked)

-- App Shortcuts
function openApp(name)
	local app = hs.application.get(name)
	if app then
		if app:isFrontmost() then
			app:hide()
		else
			app:mainWindow():focus()
		end
	else
		hs.application.launchOrFocus(name)
	end
end

function slack()
	openApp("Slack")
end

function calendar()
	openApp("Notion Calendar")
end

function mail()
	openApp("Spark Desktop")
end

function sunsama()
	openApp("Sunsama")
end

function spotify()
	openApp("Spotify")
end

-- Hotkeys for communication apps
hs.hotkey.bind(hyper, "1", mail)
hs.hotkey.bind(hyper, "2", slack)
hs.hotkey.bind(hyper, "3", sunsama)
hs.hotkey.bind(hyper, "4", calendar)
hs.hotkey.bind(hyper, "5", spotify)

function terminal()
	openApp("Ghostty")
end

function editor()
	openApp("IntelliJ IDEA")
end

--- Hotkeys for coding workflow
hs.hotkey.bind(hyper, "9", editor)
hs.hotkey.bind(hyper, "0", terminal)

-- URL Handler for certain app
function appID(app)
	if hs.application.infoForBundlePath(app) then
		return hs.application.infoForBundlePath(app)["CFBundleIdentifier"]
	end
end

function chromeProfile(profile)
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

browsers = {
	default = chromeBrowser,
	work = chromeProfile("Profile 1"),
	personal = chromeProfile("Default"),
}

-- TODO: Look into other apps that can open urs (i.e Notion, Slack, Zoom(?) etc.)
chromeBrowser = appID("/Applications/Google Chrome.app")
safariBrowser = appID("/Applications/Safari.app")

profileMenus = {
	personal = { "Profiles", "Joshua (Personal)" },
	work = { "Profiles", "Joshua (Default Work (Oscilar))" },
}

urlFiles = {
	personal = os.getenv("HOME") .. "/.config/personal_urls.txt",
	work = os.getenv("HOME") .. "/.config/work_urls.txt",
}

hs.hotkey.bind(hyper, "7", function()
	log = hs.logger.new("test", "debug")
	local app = hs.application.get("Google Chrome")
	if app then
		local profile = app:findMenuItem(profileMenus.personal)
		if profile and not profile["ticked"] then
			log.i(profile)
			app:selectMenuItem(profileMenus.personal)
		end
		app:mainWindow():focus()
	else
		browsers.personal("http://google.com")
	end
end)

hs.hotkey.bind(hyper, "8", function()
	log = hs.logger.new("test", "debug")
	local app = hs.application.get("Google Chrome")
	if app then
		local profile = app:findMenuItem(profileMenus.work)
		if profile and not profile["ticked"] then
			log.i(profile)
			app:selectMenuItem(profileMenus.work)
		end
		app:mainWindow():focus()
	else
		browsers.work("http://google.com")
	end
end)

hs.loadSpoon("URLDispatcher")
dispatcher = spoon.URLDispatcher
dispatcher.decode_slack_redir_urls = true
dispatcher.default_handler = chromeBrowser
dispatcher.url_patterns = {
	{ urlFiles.personal, browsers.personal },
	{ urlFiles.work, browsers.work },
}
dispatcher.logger = hs.logger.new("dispatcher", "debug")
dispatcher:start()

-- TODO: react to the thunderbolt dock (i.e. I'm in my office)
-- usbWatcher = nil
-- function usbDeviceCallback(data)
--     if (data["productName"] == "ScanSnap S1300i") then
--         if (data["eventType"] == "added") then
--             hs.application.launchOrFocus("ScanSnap Manager")
--         elseif (data["eventType"] == "removed") then
--             app = hs.appfinder.appFromName("ScanSnap Manager")
--             app:kill()
--         end
--     end
-- end
-- usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
-- usbWatcher:start()

-- TODO: React to "not home network or VPN"
-- wifiWatcher = nil
-- homeSSID = "MyHomeNetwork"
-- lastSSID = hs.wifi.currentNetwork()
-- function ssidChangedCallback()
--     newSSID = hs.wifi.currentNetwork()
--
--     if newSSID == homeSSID and lastSSID ~= homeSSID then
--         -- We just joined our home WiFi network
--         hs.audiodevice.defaultOutputDevice():setVolume(25)
--     elseif newSSID ~= homeSSID and lastSSID == homeSSID then
--         -- We just departed our home WiFi network
--         hs.audiodevice.defaultOutputDevice():setVolume(0)
--     end
--
--     lastSSID = newSSID
-- end
-- wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
-- wifiWatcher:start()

-- TODO: Sending iMessages
-- coffeeShopWifi = "Baristartisan_Guest"
-- lastSSID = hs.wifi.currentNetwork()
-- wifiWatcher = nil
-- function ssidChanged()
--     newSSID = hs.wifi.currentNetwork()
--
--     if newSSID == coffeeShopWifi and lastSSID ~= coffeeShopWifi then
--         -- We have arrived at the coffee shop
--         hs.messages.iMessage("iphonefriend@hipstermail.com", "Hey! I'm at Baristartisan's, come join me!")
--         hs.messages.SMS("+1234567890", "Hey, you don't have an iPhone, but you should still come for a coffee")
--     end
--
--     lastSSID = newSSID
-- end
-- wifiWatcher = hs.wifi.watcher.new(ssidChanged)
-- wifiWatcher:start()
