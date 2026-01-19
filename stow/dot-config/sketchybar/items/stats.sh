#!/bin/bash

cpu_percent=(
  icon.font="$FONT:Regular:12"
  label=CPU%
  icon="$CPU"
  icon.color="$BLUE"
  update_freq=2
  mach_helper="$HELPER"
  script="$PLUGIN_DIR/cpu.sh"
  width=84
)

sketchybar --add item cpu.percent right \
    --set cpu.percent "${cpu_percent[@]}"


memory=(
  icon="$MEMORY"
  icon.font="$FONT:Regular:12"
  icon.color="$GREEN"
  update_freq=15
  script="$PLUGIN_DIR/ram.sh"
  width=60
)

sketchybar --add item memory right \
    --set memory "${memory[@]}"

disk=(
  icon.font="$FONT:Regular:12"
  icon="$DISK"
  icon.color="$MAROON"
  update_freq=60
  script="$PLUGIN_DIR/disk.sh"
  width=60
)

sketchybar --add item disk right \
    --set disk "${disk[@]}"

network_down=(
  y_offset=-7
  label.font="$FONT:Regular:10"
  icon.font="$FONT:Regular:12"
  icon="$NETWORK_DOWN"
  icon.color="$GREEN"
  icon.highlight_color="$BLUE"
  update_freq=1
)

network_up=(
  background.padding_right=-70
  y_offset=7
  label.font="$FONT:Regular:10"
  icon="$NETWORK_UP"
  icon.font="$FONT:Regular:12"
  icon.color="$GREEN"
  icon.highlight_color="$BLUE"
  update_freq=1
  script="$PLUGIN_DIR/network.sh"
)

sketchybar --add item network.down right \
    --set network.down "${network_down[@]}" \
    --add item network.up right \
    --set network.up "${network_up[@]}"


