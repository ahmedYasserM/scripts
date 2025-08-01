#!/usr/bin/env bash

test -n "$TMUX" && tmux rename-window "$EDITOR"

fd -H -E .git -E node_modules -t f -x file --mime {} \; |
  rg 'text|empty' |
  cut -d : -f1 |
  fzf --preview 'bat --style=plain --color=always --line-range=1:100 {}' |
  xargs -r "$EDITOR"
