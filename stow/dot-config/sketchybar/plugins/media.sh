#!/bin/bash

update () 
{
    APP=$(echo "$MEDIA_INFO" | jq -r '.app_name')
    PLAYBACK=$(echo "$MEDIA_INFO" | jq -r '.track_info.playback_rate')
    TRACK=$(echo "$MEDIA_INFO" | jq -r '.track_info.title')
    ARTIST=$(echo "$MEDIA_INFO" | jq -r '.track_info.artist')

    args=()

    args+=(
        --set media.anchor icon="")
    if [[ "$PLAYBACK" -eq 1 ]]; then 
        args+=(
            --set media.anchor icon="")
    elif [[ "$PLAYBACK" -gt 1 ]]; then
        args+=(
            --set media.anchor icon="󰈑")
    fi
    
    args+=(
        --set media.anchor label="$state $TRACK - $ARTIST"
        --set media.anchor label.drawing="on")
    sketchybar -m "${args[@]}"
}

case "$SENDER" in 
    "custom_media_change") update 
        ;;
esac
