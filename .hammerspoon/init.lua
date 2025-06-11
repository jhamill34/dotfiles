local hyper = { "ctrl", "alt", "cmd", "shift" }
hs.application.enableSpotlightForNameSearches(true)

-- Enable caffeine
function caffeineClicked()
	setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
	caffeine:setClickCallback(caffeineClicked)
	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end
hs.hotkey.bind(hyper, "c", caffeineClicked)

function appID(app)
	if hs.application.infoForBundlePath(app) then
		return hs.application.infoForBundlePath(app)["CFBundleIdentifier"]
	end
end

mail = appID("/Applications/Spark Desktop.app")
slack = appID("/Applications/Slack.app")
calendar = appID("/Applications/Notion Calendar.app")
sunsama = appID("/Applications/Sunsama.app")
spotify = appID("/Applications/Spotify.app")
terminal = appID("/Applications/Ghostty.app")
intellij = appID(os.getenv("HOME") .. "/Applications/IntelliJ IDEA Ultimate.app")

-- App Shortcuts
function openApp(bundleId)
	return function()
		hs.application.launchOrFocusByBundleID(bundleId)
	end
end

-- Hotkeys for communication apps
hs.hotkey.bind(hyper, "1", openApp(mail))
hs.hotkey.bind(hyper, "2", openApp(slack))
hs.hotkey.bind(hyper, "3", openApp(sunsama))
hs.hotkey.bind(hyper, "4", openApp(calendar))
hs.hotkey.bind(hyper, "5", openApp(spotify))

--- Hotkeys for coding workflow
hs.hotkey.bind(hyper, "9", openApp(intellij))
hs.hotkey.bind(hyper, "0", openApp(terminal))

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

function chromeProfileBlank(profile)
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
	chromeProfileBlank("Default")
end)

hs.hotkey.bind(hyper, "8", function()
	chromeProfileBlank("Profile 1")
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
