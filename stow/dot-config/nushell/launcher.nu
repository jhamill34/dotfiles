#!/opt/homebrew/bin/nu

def launcher_list [] {
    let launcher_root = ($env.XDG_CONFIG_HOME | path join "jhamill" "launchers")

    ls $launcher_root | get name | path basename
}

def launcher_switch [
    profile: string@launcher_list 
] {
    let current = ($env.XDG_STATE_HOME | path join "jhamill" "current")
    mkdir $current

    let current_launcher = ($current | path join "launcher")

    let launcher_root = ($env.XDG_CONFIG_HOME | path join "jhamill" "launchers")
    let launcher_path = ($launcher_root | path join $profile)

    ln -nsf $launcher_path $current_launcher
}

