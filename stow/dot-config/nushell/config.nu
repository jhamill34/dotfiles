use std "dirs"

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = 'vi'

alias nu-open = open
alias open = ^open

alias vim = nvim
alias vi = nvim
alias gai = git add -i
alias lld = lazydocker
alias nb = newsboat
alias ccal = calcurse
alias ccals = calcurse-caldav
alias note = jrnl

alias jjn = jj new
alias jjgp = jj git push 
alias jjgf = jj git fetch
alias jjbm = jj bookmark move

alias python = python3
alias pip = pip3 

$env.config.keybindings ++= [{
    name: accept_history_hint
    modifier: control
    keycode: space
    mode: vi_insert
    event: {
        send: historyhintcomplete
    }
}]

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.zoxide.nu
source ~/.completions-jj.nu

source $"($nu.home-path)/.local/ansible_langs/rust/cargo/env.nu"

source $"($nu.default-config-dir)/langs.nu"
source $"($nu.default-config-dir)/theme.nu"
init_theme

source $"($nu.default-config-dir)/wallpaper.nu"
source $"($nu.default-config-dir)/launcher.nu"
source ~/.config/nushell/colors.nu

source $"($nu.cache-dir)/carapace.nu"

