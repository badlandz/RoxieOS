#!/bin/bash
# Simple test of the tmux GROK interface

echo "Testing tmux GROK interface..."
echo "This will create a tmux session. Press Ctrl+C to exit."

# Check if we're in tmux
if [[ -n "${TMUX:-}" ]]; then
    echo "Already in tmux, creating popup..."
    tmux popup -E -w 80% -h 80% "cd $(pwd) && echo 'Test GROK interface' && echo 'Type: Hello' | ./grok-api.sh && echo && echo 'Press Enter to exit' && read"
else
    echo "Not in tmux, creating new session..."
    SESSION="test-grok-$$"
    tmux new-session -d -s "$SESSION" -n "test"
    tmux send-keys -t "$SESSION":0 "cd $(pwd) && echo 'Test GROK interface'" C-m
    tmux send-keys -t "$SESSION":0 "echo 'Hello, test message' | ./grok-api.sh" C-m
    tmux send-keys -t "$SESSION":0 "echo && echo 'Press Enter to exit' && read" C-m
    tmux attach-session -t "$SESSION"
fi
