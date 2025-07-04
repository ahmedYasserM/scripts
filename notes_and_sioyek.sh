#!/bin/bash

# Start tmux session for Neovim
tmux has-session -t notes 2>/dev/null || tmux new-session -d -s notes -c ~/dev/notes

# Launch Kitty (Neovim) 
kitty --class nvim -e tmux attach -t notes &

# Launch sioyek
sioyek --new-instance &

