#!/opt/homebrew/bin/nu

def wallpaper_list [] {
    let wallpaper_root = ($env.XDG_STATE_HOME | path join "jhamill" "current" "theme" "wallpapers")

    ls $wallpaper_root | where name =~ '\.(png|jpg|jpeg)' | get name
}

def change-wallpaper [
    image: string@wallpaper_list
] {
    osascript -e $"tell application \"System Events\" to set picture of current desktop to \"($image)\""
}

def tint-wallpaper [
    image: string@wallpaper_list # source image in the active theme's wallpapers dir
    color: string                # hex color, e.g. "#d699b6" or "d699b6"
    opacity: int = 15            # tint strength percentage, 0-100
] {
    let wallpaper_root = ($env.XDG_STATE_HOME | path join "jhamill" "current" "theme" "wallpapers")
    # resolve through the theme symlinks so output lands in the tracked dotfiles repo, not live state
    let source = ($wallpaper_root | path join $image | path expand)
    let hex = ($color | str replace "#" "")
    let parsed = ($image | path parse)
    let output = ($source | path dirname | path join $"($parsed.stem)-tint-($hex)-($opacity).($parsed.extension)")

    ^magick $source -fill $"#($hex)" -colorize $"($opacity)%" $output

    $output
}
