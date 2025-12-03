#!/usr/bin/env bash

# Usage: moveToWorkspace <workspace> '<json-array-of-classes>'
# Example: moveToWorkspace 1 '["com.mitchellh.ghostty","Google-chrome"]'

space="$1"
json_classes="$2"

# Fetch all clients once
all_clients=$(hyprctl clients -j)

commands=""

# Loop through classes from the JSON array
while read -r class; do
    # Remove quotes from class string
    class=$(jq -r '.' <<< "$class")

    # --- Find clients of this class ---
    clients=$(jq -r --arg class "$class" '
        .[] | select(.class == $class) | .address
    ' <<< "$all_clients")

    # --- Build commands ---
    while read -r addr; do
        [ -n "$addr" ] || continue
        commands+="dispatch movetoworkspace $space,address:$addr ; "
    done <<< "$clients"
done < <(jq -c '.[]' <<< "$json_classes")

# Switch to the workspace last
commands+="dispatch workspace $space ; "

# --- Execute batch command ---
hyprctl --batch "$commands"
