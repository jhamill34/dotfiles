#!/bin/bash

sketchybar --add event clock_tz_changed

calendar=(
  icon=""
  icon.font="$FONT:Bold:14.0"
  icon.padding_right=4
  label.width=154
  label.align=right
  label.font="$FONT:Regular:14.0"
  padding_left=8
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
  click_script="sketchybar --set calendar popup.drawing=toggle"
  popup.height=25
  popup.horizontal=false
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke clock_tz_changed
