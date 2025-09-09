#!/bin/bash 

##### Adding Mission Control Space Indicators #####
# Let's add some mission control spaces:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item
# to indicate active and available mission control spaces.

sketchybar --add event aerospace_workspace_change

for wid in $(aerospace list-workspaces --all); do
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
        background.color=$BACKGROUND_1
        background.border_color=$BACKGROUND_2
        click_script="aerospace workspace $wid"
        script="$PLUGIN_DIR/aerospace.sh $wid"
    )

    sketchybar --add item space.$wid left \
        --set space.$wid "${space[@]}" \
        --subscribe space.$wid aerospace_workspace_change space_windows_change
done


