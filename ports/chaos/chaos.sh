#!/usr/bin/env bash
# /usr/share/baux/screensaver/chaos.sh — the Rick-Roll screensaver

while :; do
  # Random layout chaos
  for i in {1..8}; do
    tmux split-window -h -p $((RANDOM % 60 + 20)) "echo 'ROXANNE LIVES'; sleep 2; btop" &
    tmux split-window -v -p $((RANDOM % 70 + 15)) "cmatrix -r" &
    tmux split-window -v "fastfetch --logo roxanne" &
    sleep $((RANDOM % 5 + 2))
    tmux swap-pane -D
    tmux rotate-window -U
  done

  # Scramble status bar
  tmux set -g status off
  sleep 3
  tmux set -g status on
  tmux set -g status-style "bg=#ff0000,fg=#00ff00"
  tmux set -g status-left "ROXANNE WAS HERE"
  tmux set -g status-right "NO ESCAPE"
  sleep 4
  tmux set -g status off
done
