#!/bin/bash

# Only populate items once (check if already added)
POPUP_POPULATED=$(sketchybar --query calendar | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('popup', {}).get('items', []) != [])
" 2>/dev/null)

TIMEZONES=(
    "UTC|UTC"
    "US/Eastern|US/Eastern"
    "US/Central|US/Central"
    "US/Pacific|US/Pacific"
    "Europe/London|London"
    "Europe/Warsaw|Poland"
)

for TZ_ENTRY in "${TIMEZONES[@]}"; do
    TZ_KEY="${TZ_ENTRY%%|*}"
    TZ_LABEL="${TZ_ENTRY##*|}"

    sketchybar --add item "tz.$TZ_KEY" popup.calendar \
        --set "tz.$TZ_KEY" \
        label="$TZ_LABEL" \
        icon="" \
        click_script="echo '$TZ_KEY' > ~/.cache/sketchybar_tz; sketchybar --set calendar popup.drawing=off; sketchybar --trigger clock_tz_changed"
done

# Read saved timezone, fall back to system default
TZ_FILE="$HOME/.cache/sketchybar_tz"
if [ -f "$TZ_FILE" ]; then
  SELECTED_TZ=$(cat "$TZ_FILE")
else
  SELECTED_TZ=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')
fi

CAL_TIME=$(TZ="$SELECTED_TZ" date "+%a %d. %b %H:%M %Z")

sketchybar --set calendar label="$CAL_TIME"

