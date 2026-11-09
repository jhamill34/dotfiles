_wallpaper_root() { echo "$XDG_STATE_HOME/jhamill/current/theme/wallpapers" }

change-wallpaper() {
    local image="$1"
    [[ $image == /* ]] || image="$(_wallpaper_root)/$image"
    osascript -e "tell application \"System Events\" to set picture of current desktop to \"$image\""
}

# tint-wallpaper <image> <hex color, e.g. "#d699b6"> [opacity 0-100, default 15]
tint-wallpaper() {
    local image="$1" hex="${2#\#}" opacity="${3:-15}"
    [[ $image == /* ]] || image="$(_wallpaper_root)/$image"
    # resolve through the theme symlinks so output lands in the tracked dotfiles repo, not live state
    local source="${image:A}"
    local output="${source:h}/${source:t:r}-tint-$hex-$opacity.${source:e}"
    magick "$source" -fill "#$hex" -colorize "$opacity%" "$output"
    echo "$output"
}
compdef "_files -W $XDG_STATE_HOME/jhamill/current/theme/wallpapers -g '*.(png|jpg|jpeg)'" change-wallpaper tint-wallpaper
