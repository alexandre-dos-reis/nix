#!/bin/sh
# Report Claude Code's status to Rex via OSC 7501, for Renux's agent board.
#
# Renux sorts a pane into Idle, Running, Attention or Done from the status the
# program inside reports. Claude Code does not speak OSC 7501, so these hooks
# do it for it. Wired up in ~/.claude/settings.json.
#
#   ESC ] 7501 ; state=<state>:app=claude-code ESC \
#   state: idle | working | done | blocked | error   (done = finished unseen)

set -eu

state="${1:-idle}"
kind="${2:-}"

# Only inside a Rex terminal, which is what sets REX_BLOCK.
[ -n "${REX_BLOCK:-}" ] || exit 0

input="$(cat 2>/dev/null || true)"

# Sub-agents report nothing: their Stop would clear the main session's status.
case "$input" in
  *'"agent_id"'*) exit 0 ;;
esac

# Which kind of blocked it is comes from the caller, which knows it from the
# Notification hook's matcher. Reading the message is only a fallback.
if [ "$state" = "blocked" ] && [ -z "$kind" ]; then
  case "$input" in
    *permission*|*approve*|*"needs your"*) kind="permission" ;;
    *) kind="question" ;;
  esac
fi

# Hooks get no controlling tty, so write to the first ancestor holding the pty.
tty_path=""
pid="$$"
while [ "$pid" -gt 1 ]; do
  target="$(readlink "/proc/$pid/fd/1" 2>/dev/null || true)"
  case "$target" in
    /dev/pts/*) tty_path="$target"; break ;;
  esac
  pid="$(awk '{print $4}' "/proc/$pid/stat" 2>/dev/null || echo 1)"
  [ -n "$pid" ] || break
done
[ -n "$tty_path" ] && [ -w "$tty_path" ] || exit 0

payload="state=$state:app=claude-code"
[ -n "$kind" ] && payload="$payload:kind=$kind"

printf '\033]7501;%s\033\\' "$payload" >"$tty_path" 2>/dev/null || true
exit 0
