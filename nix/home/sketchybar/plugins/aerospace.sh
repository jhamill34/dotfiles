#!/bin/bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/colors.sh"

apps=$(aerospace list-windows --workspace "$1" --json | jq -r '.[]["app-name"]')

icon_strip=" "
if [ "${apps}" != "" ]; then 
    while read -r app 
    do 
	    icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
    done <<< "${apps}"
else 
    icon_strip=" -"
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate sin 10 --set $NAME \
	    label="$icon_strip" \
	    icon.highlight="true" \
	    label.highlight="true" \
	    background.border_color="$GREY"
else
    sketchybar --animate sin 10 --set $NAME \
	    label="$icon_strip" \
	    icon.highlight="false" \
	    label.highlight="false" \
	    background.border_color="$BACKGROUND_2"
fi
