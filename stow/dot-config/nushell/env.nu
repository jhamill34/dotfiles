$env.XDG_CACHE_HOME = $"($env.HOME)/.cache" 
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config" 
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share" 
$env.XDG_STATE_HOME = $"($env.HOME)/.local/state" 

$env.PERSONAL_HOME = $"($env.HOME)/Code/Personal"
$env.WORK_HOME = $"($env.HOME)/Code/Work"

$env.PYENV_ROOT = $"($env.HOME)/.pyenv"
$env.RBENV_ROOT = $"($env.HOME)/.rbenv"

$env.COLIMA_HOME = $"($env.XDG_CONFIG_HOME)/.config/colima"
$env.DOCKER_HOST = $"unix://($env.COLIMA_HOME)/default/docker.sock"

$env.EDITOR = "nvim"
$env.RUSTUP_HOME = $"($env.HOME)/.rustup"
$env.GPG_TTY = (tty | str trim)
