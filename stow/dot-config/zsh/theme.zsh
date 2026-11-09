theme_path=(
    "$XDG_CONFIG_HOME/aerc/stylesets/theme"
    "$XDG_CONFIG_HOME/borders/bordersrc"
    "$XDG_CONFIG_HOME/btop/themes/current.theme"
    "$XDG_CONFIG_HOME/eza/theme.yml"
    "$XDG_CONFIG_HOME/ghostty/themes/current.conf"
    "$XDG_CONFIG_HOME/k9s/skins/current.yaml"
    "$XDG_CONFIG_HOME/sketchybar/colors.sh"
    "$XDG_CONFIG_HOME/nvim/lua/plugins/theme.lua"
    "$XDG_CONFIG_HOME/nushell/colors.nu"
    "$XDG_CONFIG_HOME/starship.toml"
    "$XDG_CONFIG_HOME/herdr/config.toml"
    "$XDG_CONFIG_HOME/tuicr/config.toml"
)

init_theme() {
    local cfg
    for cfg in $theme_path; do
        ln -sfF "${cfg/#$XDG_CONFIG_HOME/$XDG_STATE_HOME/jhamill/current/theme}" "$cfg"
    done
}

theme_switch() {
    mkdir -p "$XDG_STATE_HOME/jhamill/current"
    ln -nsf "$XDG_CONFIG_HOME/jhamill/themes/$1" "$XDG_STATE_HOME/jhamill/current/theme"
}
compdef "_files -W $XDG_CONFIG_HOME/jhamill/themes -/" theme_switch
