#!/bin/bash
    
current_issue=$(cat .jira/current 2>/dev/null || echo "N/A")
printf "Current Issue: \e[36;1m$current_issue\e[0m\n"

if [ -f .jira/issues ]; then
    printf "\n"
    cat .jira/issues | jq -r '.[] | "\u001b[36;1m\(.key)\u001b[0m - \u001b[32;1m\(.fields.status.name)\u001b[0m\n\t\(.fields.summary)"'
fi
