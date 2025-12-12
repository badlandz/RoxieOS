#!/bin/bash
# baux-grok-direct — instant Grok pane inside tmux using direct API
# Uses grok-api.sh instead of grok-cli

set -euo pipefail

# Configurable bits
SESSION="baux-grok-direct-$$"
CWD="$(tmux display-message -p '#{pane_current_path}' 2>/dev/null || pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if GROK_API_KEY is available
if [[ -z "${GROK_API_KEY:-}" ]]; then
  echo "Error: GROK_API_KEY not set in environment" >&2
  exit 1
fi

# Create dedicated session
tmux new-session -d -s "$SESSION" -n "grok-chat"

# Main chat pane - interactive chat with grok-api.sh
tmux send-keys -t "$SESSION":0 \
  "cd '$SCRIPT_DIR' && echo 'Grok Chat - Type your questions, exit to quit'" C-m
tmux send-keys -t "$SESSION":0 \
  "while true; do echo -n 'you > '; read -r input; [[ \"\$input\" == 'exit' ]] && break; echo \"\$input\" | ./grok-api.sh; echo; done" C-m

# Initial greeting
tmux send-keys -t "$SESSION":0 C-m
tmux send-keys -t "$SESSION":0 \
  "echo 'Welcome to Roxanne Cyberdeck AI Assistant'" C-m
tmux send-keys -t "$SESSION":0 \
  "echo 'Current directory: $CWD'" C-m
tmux send-keys -t "$SESSION":0 \
  "echo 'Type your questions or \"exit\" to quit'" C-m
tmux send-keys -t "$SESSION":0 C-m

# Right pane – project info and useful commands
tmux split-window -t "$SESSION" -h -p 35
tmux send-keys -t "$SESSION":1 "echo '=== ROXANNE CYBERDECK ==='" C-m
tmux send-keys -t "$SESSION":1 "echo 'Project: $(basename "$CWD")'" C-m
tmux send-keys -t "$SESSION":1 "echo 'Directory: $CWD'" C-m
tmux send-keys -t "$SESSION":1 "echo ''" C-m
tmux send-keys -t "$SESSION":1 "echo 'Useful commands:'" C-m
tmux send-keys -t "$SESSION":1 "echo '- ls -la'" C-m
tmux send-keys -t "$SESSION":1 "echo '- find . -name \"*.sh\"'" C-m
tmux send-keys -t "$SESSION":1 "echo '- git status'" C-m
tmux send-keys -t "$SESSION":1 "watch -n 30 'date'" C-m

# Make it pretty
tmux set-window -t "$SESSION" window-style 'bg=#0e281c,fg=#aaacb2'
tmux set-window -t "$SESSION" pane-border-style 'fg=#2e482c'

# Either attach or popup
if [[ -n "${TMUX:-}" ]]; then
  tmux switch-client -t "$SESSION"
else
  tmux attach-session -t "$SESSION" || tmux popup -E -w 95% -h 95% "tmux attach-session -t '$SESSION'"
fi
