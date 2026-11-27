#!/bin/sh
# Git clean filter for settings.ini, registered as filter.renux-settings in
# programs/git.nix and bound to the file by .gitattributes here.
#
# Renux owns settings.ini: it rewrites the whole file on every change, and one
# of the groups it writes, [paths], is a 30-entry list of folders your panes
# have visited. That list changes on every cd, which would mean a diff in this
# repo for every cd. It is a cache Renux refills on its own, so git doesn't
# need it. Nothing here touches the file on disk — only what git stores.
#
# Reads the file on stdin, writes it to stdout without the [paths] group,
# leaving every other group, comment and unknown key exactly as it was.

exec awk '
  # A group header decides whether the lines that follow are kept.
  /^\[/ { skip = ($0 == "[paths]") }
  skip  { next }
  # Blank lines are held back so dropping a group leaves no gap behind.
  /^[[:space:]]*$/ { blank++; next }
  { while (blank-- > 0) print ""; blank = 0; print }
'
