#!/usr/bin/env bash

languages=$(echo "typescript javascript rust golang lua" | tr " " "\n")
core_utils=$(ls /bin | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)
 
read -p "Query: " query

if echo "$languages" | grep -qs $selected; then
  cmd="curl -s cht.sh/$selected/$(echo "$query" | tr " " "+") | less -R"
else
  cmd="curl -s cht.sh/$selected~$query | less -R"
fi

tmux split-window -h bash -c "$cmd"

