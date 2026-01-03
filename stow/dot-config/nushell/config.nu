alias vim = nvim
alias vi = nvim
alias ls = eza --long --color=always --icons=always
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

