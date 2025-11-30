#!/usr/bin/env bash

# --- This script get all clients by their classes and moved then to the specified workspace.
# $1 is the workspace
# $2 is the class

# --- Fetch and filter clients by class ---
clients=$(hyprctl clients -j \
    | jq -r --arg cls "$2" '.[] | select(.class == $cls) | .address')

# --- Build batch commands ---
commands=""
while IFS= read -r addr; do
    commands+="dispatch movetoworkspace $1,address:${addr} ; "
done <<< "$clients"

# Add final workspace switch
commands+="; dispatch workspace $1"

# --- Execute batch command ---
hyprctl --batch "$commands"
