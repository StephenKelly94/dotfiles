#!/bin/bash
set -e

# Top pane is already created — split off the bottom 30%
tmux split-window -v -p 30

# Split the bottom into left (claude) and right (shell)
tmux split-window -h

# Bottom right is now active (shell) — nothing to run

# Move to bottom left and launch claude
tmux select-pane -L
tmux send-keys "claude --resume" Enter

# Move to top and launch nvim
tmux select-pane -U
tmux send-keys "nvim" Enter
