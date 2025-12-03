#!/usr/bin/env bash

# Usage: moveToWorkspace <workspace> '<json-array-of-classes>'
# Example: moveToWorkspace 1 '["com.mitchellh.ghostty","Google-chrome"]'

space="$1"

# all_monitors=$(hyprctl monitors -j)

# --- Early exit if workspace not active on any monitor ---
# ws_active=$(jq -r --arg space "$space" '
#     any(.[]; .activeWorkspace.id == ($space|tonumber))
# ' <<< "$all_monitors")
#
# if [ "$ws_active" != "true" ]; then
#     echo "Workspace $space is not active on any monitor — exiting."
#     exit 1
# fi

json_classes="$2"

# Fetch all clients once
all_clients=$(hyprctl clients -j)

commands=""

# Parse each rule from the JSON array without creating a subshell
while read -r class; do
    # Remove quotes from class string
    class=$(jq -r '.' <<< "$class")

    # --- Find clients of this class ---
    clients=$(jq -r --arg class "$class" '
        .[] | select(.class == $class) | .address
    ' <<< "$all_clients")

    # --- Build batch commands for this rule ---
    while IFS= read -r addr; do
        commands+="dispatch movetoworkspace $space,address:${addr} ; "
    done <<< "$clients"

    # Final workspace switch
    commands+="dispatch workspace $space ; "

done < <(jq -c '.[]' <<< "$json_classes")

# --- Execute once ---
hyprctl --batch "$commands"
