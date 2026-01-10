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

def jjk [] {
    let message = (koji --stdout | str trim)
    jj desc -m $message --edit
}

def jjcc [] {
    let message = (koji --stdout | str trim)
    jj commit -m $message
}

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

source ~/.config/nushell/colors.nu
source $"($nu.home-path)/.cargo/env.nu"
