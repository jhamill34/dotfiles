#!/bin/bash

media_anchor=(
    script="$PLUGIN_DIR/media.sh"
    icon.padding_left=10
    icon.padding_right=10
    label.padding_right=10
    icon=""
    icon.font="$FONT:Bold:14.0"
    icon.color="$MAUVE"
    drawing=on
    label.max_chars=22
    label.font="$FONT:Bold:14.0"
    label.drawing=off
    background.color="$BACKGROUND_1"
    background.border_color="$BACKGROUND_1"
)


sketchybar --add event custom_media_change

sketchybar --add item media.anchor right \
    --set media.anchor "${media_anchor[@]}" \
    --subscribe media.anchor custom_media_change
