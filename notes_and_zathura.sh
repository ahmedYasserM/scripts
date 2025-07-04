#!/bin/bash

# Start tmux session for Neovim
tmux new-session -d -s notes -c ~/dev/notes 2>/dev/null && tmux new-session -d -s notes
kitty --class nvim -e tmux attach -t notes &

# Launch Zathura in workspace 9
hyprctl dispatch workspace 8
zathura &
