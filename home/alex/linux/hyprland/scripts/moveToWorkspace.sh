#!/usr/bin/env bash

json="$1"

# Fetch all clients once
all_clients=$(hyprctl clients -j)

commands=""

# Loop through rules from your JSON argument
while read -r rule; do
    space=$(jq -r '.space' <<< "$rule")
    class=$(jq -r '.class' <<< "$rule")

    # Filter from preloaded clients JSON
    clients=$(jq -r --arg class "$class" '
        .[] | select(.class == $class) | .address
    ' <<< "$all_clients")

    # Build commands
    while read -r addr; do
        [ -n "$addr" ] || continue
        commands+="dispatch movetoworkspace $space,address:$addr ; "
    done <<< "$clients"

    # Optionally switch to that workspace last
    commands+="dispatch workspace $space ; "

done < <(jq -c '.[]' <<< "$json")

# Execute the whole batch at once
hyprctl --batch "$commands"
