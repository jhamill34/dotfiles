#!/bin/bash

config_file=$(cat "$XDG_CONFIG_HOME/calcurse/caldav/config.template")

while IFS= read -r line; do
    temp="${line#*<}"
    extracted_value="${temp%>*}"

    secret_value=$(pass "$extracted_value")
    config_file=$(echo "$config_file" | sed "s#${line}#${secret_value}#g")
done < <(echo "$config_file" | grep -E -o '<[^>]+>')


echo "$config_file" > "$XDG_CONFIG_HOME/calcurse/caldav/config"

