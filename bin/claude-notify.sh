#!/usr/bin/env bash
# Claude Code notification hook helper.
# Reads the hook JSON on stdin and posts a macOS notification via
# terminal-notifier. When run inside tmux, clicking the banner brings the
# terminal forward and jumps to the originating session/pane.
set -euo pipefail

TERMINAL_APP="Ghostty" # terminal to focus on click

payload="$(cat)"
event="$(jq -r '.hook_event_name // "Notification"' <<<"$payload")"

case "$event" in
    Stop) message="$(jq -r '.message // "Response ready"' <<<"$payload")" ;;
    *)    message="$(jq -r '.message // "Ready for input"' <<<"$payload")" ;;
esac

# Inside tmux: name the session in the title, add click-to-focus, and group by
# session so repeated notifications replace each other instead of stacking.
title="Claude Code"
session=""
if [[ -n "${TMUX:-}" ]]; then
    session="$(tmux display -p '#S' 2>/dev/null || true)"
    pane="${TMUX_PANE:-}"
fi

args=(-message "$message" -sound Glass)
if [[ -n "$session" ]]; then
    args+=(-title "Claude · $session" -group "claude-$session")
    [[ -n "${pane:-}" ]] && args+=(-execute "open -a '$TERMINAL_APP'; tmux switch-client -t '$session'; tmux select-pane -t '$pane'")
else
    args+=(-title "$title")
fi

exec terminal-notifier "${args[@]}"
