local hyper = { "ctrl", "alt", "cmd", "shift" }
hs.application.enableSpotlightForNameSearches(true)

hs.loadSpoon("Caffeine")
hs.loadSpoon("AppID")
hs.loadSpoon("URLDispatcher")
hs.loadSpoon("Launcher")
hs.loadSpoon("ChromeProfile")

local coffee = spoon.Caffeine
coffee.leader = hyper
coffee:start()

local appID = spoon.AppID.appID

local launcher = spoon.Launcher
launcher.leader = hyper
launcher.bundleFn = appID
launcher.mappings = {
	{
		app = "/Applications/Spark Desktop.app",
		key = "1",
	},
	{
		app = os.getenv("HOME") .. "/Applications/Home Manager Trampolines/Slack.app",
		key = "2",
	},
	{
		app = "/Applications/Notion Calendar.app",
		key = "3",
	},
	{
		app = "/Applications/Sunsama.app",
		key = "4",
	},
	{
		app = os.getenv("HOME") .. "/Applications/Home Manager Trampolines/Spotify.app",
		key = "5",
	},
	{
		app = "/Applications/Docker.app",
		key = "6",
	},
	{
		app = os.getenv("HOME") .. "/Applications/Home Manager Trampolines/IntelliJ IDEA.app",
		key = "9",
	},
	{
		app = os.getenv("HOME") .. "/Applications/Home Manager Trampolines/kitty.app",
		key = "0",
	},
}
launcher:start()

local chromeProfile = spoon.ChromeProfile
chromeProfile.leader = hyper
chromeProfile.profiles = {
	personal = {
		location = "Default",
		urls = os.getenv("HOME") .. "/.config/personal_urls.txt",
		key = "7",
	},
	work = {
		location = "Profile 1",
		urls = os.getenv("HOME") .. "/.config/work_urls.txt",
		key = "8",
	},
}
chromeProfile:start()

local dispatcher = spoon.URLDispatcher
dispatcher.decode_slack_redir_urls = true
dispatcher.default_handler = appID(os.getenv("HOME") .. "/Applications/Home Manager Trampolines/Google Chrome.app")
dispatcher.url_patterns = chromeProfile:patterns()
dispatcher:start()
