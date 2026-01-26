#!/opt/homebrew/bin/nu

def init_theme [] {
    $env.THEME_PATH 
        | each { |cfg| 
            let current = $cfg | str replace $env.XDG_CONFIG_HOME ($env.XDG_STATE_HOME | path join "jhamill" "current" "theme")

            ln -sfF $current $cfg

            {
                source: $current,
                target: $cfg,
            }
        }
}

def theme_list [] {
    let theme_root = ($env.XDG_CONFIG_HOME | path join "jhamill" "themes")

    ls $theme_root | get name | path basename
}

def theme_switch [
    name: string@theme_list
] {
    let current = ($env.XDG_STATE_HOME | path join "jhamill" "current")
    mkdir $current

    let current_theme = ($current | path join "theme")
    let theme_root = ($env.XDG_CONFIG_HOME | path join "jhamill" "themes")
    let theme_path = ($theme_root | path join $name)

    ln -nsf $theme_path $current_theme
}
