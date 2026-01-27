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
