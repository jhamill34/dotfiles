use std "path add"

$env.XDG_CACHE_HOME = $"($env.HOME)/.cache" 
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config" 
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share" 
$env.XDG_STATE_HOME = $"($env.HOME)/.local/state" 

$env.PERSONAL_HOME = $"($env.HOME)/Code/Personal"
$env.WORK_HOME = $"($env.HOME)/Code/Work"

$env.COLIMA_HOME = $"($env.XDG_CONFIG_HOME)/.config/colima"
$env.DOCKER_HOST = $"unix://($env.COLIMA_HOME)/default/docker.sock"

$env.EDITOR = "nvim"
$env.RUSTUP_HOME = $"($env.HOME)/.rustup"
$env.GPG_TTY = (tty | str trim)

$env.TRANSIENT_PROMPT_COMMAND = {|| starship module character }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"

path add ($env.HOME | path join "bin")
path add ($env.HOME | path join "sbin")
path add ($env.HOMEBREW_PREFIX | path join "bin")
path add ($env.HOMEBREW_PREFIX | path join "sbin")
path add ($env.HOME | path join ".npm-global" "bin")
path add ($env.HOME | path join ".bin")
path add ($env.HOME | path join "go" "bin")
path add ($env.HOME | path join ".cargo" "bin")
path add ($env.RUSTUP_HOME| path join "bin")

zoxide init --cmd cd nushell | save -f ~/.zoxide.nu
jj util completion nushell | save -f ~/.completions-jj.nu

