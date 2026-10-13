#!/bin/bash 

##### Adding Mission Control Space Indicators #####
# Let's add some mission control spaces:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item
# to indicate active and available mission control spaces.

sketchybar --add event aerospace_workspace_change

RIGHT_SPACES_FROM=4

add_space() {
    local wid=$1
    local position=$2
    space=(
        icon=$wid
        icon.padding_left=10
        icon.padding_right=10
        padding_left=2
        padding_right=2
        label.padding_right=20
        icon.highlight_color=$PINK
        label.color=$GREY
        label.highlight_color=$WHITE
        label.font="sketchybar-app-font:Regular:16.0"
        label.y_offset=-1
        background.color=0xa0${BLACK:4}   # theme black, darker than the bar
        background.border_color=$BACKGROUND_2
        click_script="aerospace workspace $wid"
        script="$PLUGIN_DIR/aerospace.sh $wid"
    )

    sketchybar --add item space.$wid $position \
        --set space.$wid "${space[@]}" \
        --subscribe space.$wid aerospace_workspace_change space_windows_change
}

for wid in $(aerospace list-workspaces --all); do
    if [ "$wid" -lt "$RIGHT_SPACES_FROM" ]; then
        add_space "$wid" left
    fi
done


