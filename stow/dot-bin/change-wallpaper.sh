#!/bin/bash

if [[ -z $1 ]]; then 
    echo "Usage: change-wallpaper <absolute path to image>"
    echo ""
    exit 1
fi

osascript -e "tell application \"System Events\" to set picture of current desktop to \"$1\""

