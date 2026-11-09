launcher_switch() {
    mkdir -p "$XDG_STATE_HOME/jhamill/current"
    ln -nsf "$XDG_CONFIG_HOME/jhamill/launchers/$1" "$XDG_STATE_HOME/jhamill/current/launcher"
}
compdef "_files -W $XDG_CONFIG_HOME/jhamill/launchers" launcher_switch
