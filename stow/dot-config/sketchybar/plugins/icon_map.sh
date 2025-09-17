#!/bin/bash

function icon_map() {
  case "$1" in
  "Brave" | "Brave Browser")
    icon_result=":brave_browser:"
    ;;
  "Cursor") 
    icon_result=":cursor:"
    ;;
  "Notion Calendar" | "Fantastical" | "Cron" | "Calendar")
    icon_result=":calendar:"
    ;;
  "Figma")
    icon_result=":figma:"
    ;;
  "Spotlight")
    icon_result=":spotlight:"
    ;;
  "Rider" | "JetBrains Rider")
    icon_result=":rider:"
    ;;
  "Docker" | "Docker Desktop")
    icon_result=":docker:"
    ;;
  "Pages")
    icon_result=":pages:"
    ;;
  "Bear")
    icon_result=":bear:"
    ;;
  "zoom.us")
    icon_result=":zoom:"
    ;;
  "Keynote")
    icon_result=":keynote:"
    ;;
  "iTerm")
    icon_result=":iterm:"
    ;;
  "IntelliJ IDEA")
    icon_result=":idea:"
    ;;
  "Finder" | "访达")
    icon_result=":finder:"
    ;;
  "Xcode")
    icon_result=":xcode:"
    ;;
  "GoLand")
    icon_result=":goland:"
    ;;
  "Android Studio")
    icon_result=":android_studio:"
    ;;
  "Spotify")
    icon_result=":spotify:"
    ;;
  "Microsoft Word")
    icon_result=":microsoft_word:"
    ;;
  "Microsoft PowerPoint")
    icon_result=":microsoft_power_point:"
    ;;
  "Notes")
    icon_result=":notes:"
    ;;
  "WebStorm")
    icon_result=":web_storm:"
    ;;
  "Skype")
    icon_result=":skype:"
    ;;
  "PyCharm")
    icon_result=":pycharm:"
    ;;
  "Mail" )
    icon_result=":mail:"
    ;;
  "Default")
    icon_result=":default:"
    ;;
  "App Store")
    icon_result=":app_store:"
    ;;
  "Todoist")
    icon_result=":todoist:"
    ;;
  "Messenger")
    icon_result=":messenger:"
    ;;
  "Drafts")
    icon_result=":drafts:"
    ;;
  "GitHub Desktop")
    icon_result=":git_hub:"
    ;;
  "Firefox Developer Edition" | "Firefox Nightly")
    icon_result=":firefox_developer_edition:"
    ;;
  "Sketch")
    icon_result=":sketch:"
    ;;
  "System Preferences" | "System Settings" | "系统设置")
    icon_result=":gear:"
    ;;
  "Arc")
    icon_result=":arc:"
    ;;
  "Chromium" | "Google Chrome" | "Google Chrome Canary")
    icon_result=":google_chrome:"
    ;;
  "1Password")
    icon_result=":one_password:"
    ;;
  "FaceTime")
    icon_result=":face_time:"
    ;;
  "Code" | "Code - Insiders")
    icon_result=":code:"
    ;;
  "Notion")
    icon_result=":notion:"
    ;;
  "Safari" | "Safari Technology Preview")
    icon_result=":safari:"
    ;;
  "Blender")
    icon_result=":blender:"
    ;;
  "Spark Desktop")
    icon_result=":spark:"
    ;;
  "Podcasts")
    icon_result=":podcasts:"
    ;;
  "NordVPN")
    icon_result=":nord_vpn:"
    ;;
  "Notability")
    icon_result=":notability:"
    ;;
  "Numbers")
    icon_result=":numbers:"
    ;;
  "Microsoft Excel")
    icon_result=":microsoft_excel:"
    ;;
  "Trello" | "Sunsama")
    icon_result=":trello:"
    ;;
  "Pi-hole Remote")
    icon_result=":pihole:"
    ;;
  "Linear")
    icon_result=":linear:"
    ;;
  "CleanMyMac X")
    icon_result=":desktop:"
    ;;
  "GrandTotal" | "Receipts")
    icon_result=":dollar:"
    ;;
  "Terminal")
    icon_result=":terminal:"
    ;;
  "Reminders")
    icon_result=":reminders:"
    ;;
  "VMware Fusion")
    icon_result=":vmware_fusion:"
    ;;
  "Microsoft Teams")
    icon_result=":microsoft_teams:"
    ;;
  "Slack")
    icon_result=":slack:"
    ;;
  "Miro")
    icon_result=":miro:"
    ;;
  "Messages")
    icon_result=":messages:"
    ;;
  "Preview")
    icon_result=":pdf:"
    ;;
  "Obsidian")
    icon_result=":obsidian:"
    ;;
  "Thunderbird")
    icon_result=":thunderbird:"
    ;;
  "Firefox")
    icon_result=":firefox:"
    ;;
  "Ghostty")
    icon_result=":ghostty:"
    ;;
  "Kitty" | "kitty")
    icon_result=":kitty:"
    ;;
  *)
    icon_result=":default:"
    ;;
  esac
}

icon_map "$1"
echo "$icon_result"
