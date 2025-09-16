#!/bin/bash

calendar=(
  icon=cal
  icon.font="$FONT:Bold:14.0"
  icon.padding_right=6
  label.width=48
  label.align=right
  label.font="$FONT:Regular:14.0"
  padding_left=8
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke
