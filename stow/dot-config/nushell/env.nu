use std "path add"

$env.XDG_CACHE_HOME = $"($env.HOME)/.cache" 
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config" 
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share" 
$env.XDG_STATE_HOME = $"($env.HOME)/.local/state" 

$env.PERSONAL_HOME = $"($env.HOME)/Code/Personal"
$env.WORK_HOME = $"($env.HOME)/Code/Work"

$env.COLIMA_HOME = $"($env.XDG_CONFIG_HOME)/colima"
$env.DOCKER_HOST = $"unix://($env.COLIMA_HOME)/default/docker.sock"

$env.EDITOR = "nvim"
$env.GPG_TTY = (tty | str trim)

$env.TRANSIENT_PROMPT_COMMAND = {|| starship module character }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"

$env.LANGS_HOME = ($env.HOME | path join "ansible_langs")
$env.JAVA_HOME = ($env.LANGS_HOME | path join "java" "current" "Contents" "Home")
$env.RUSTUP_HOME = ($env.LANGS_HOME | path join "rust" "rustup")
$env.CARGO_HOME = ($env.LANGS_HOME | path join "rust" "cargo")

path add ($env.HOMEBREW_PREFIX | path join "bin")
path add ($env.HOMEBREW_PREFIX | path join "sbin")

path add ($env.HOME | path join "bin")
path add ($env.HOME | path join "sbin")
path add ($env.HOME | path join ".bin")


path add ($env.HOME | path join ".npm-global" "bin")

path add ($env.LANGS_HOME | path join "golang" "current" "bin")
path add ($env.LANGS_HOME | path join "node" "current" "bin")
path add ($env.LANGS_HOME | path join "python" "current" "build" "bin")
path add ($env.CARGO_HOME | path join "bin")

zoxide init --cmd cd nushell | save -f ~/.zoxide.nu
jj util completion nushell | save -f ~/.completions-jj.nu

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
