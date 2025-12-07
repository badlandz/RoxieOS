#!/usr/bin/env baux
# baux-grok — instant Grok-3 pane inside tmux with full project RAG
# Mod4+g or whatever you bind → money printer go brrr

set -euo pipefail

# Configurable bits
MODEL="${GROK_MODEL:-grok-3}"
SESSION="baux-grok-$$"
CWD="$(tmux display-message -p '#{pane_current_path}')"
API_KEY="${GROK_API_KEY:-$(grok-cli config get api_key || echo 'missing')}"

if [[ "$API_KEY" == "missing" || -z "$API_KEY" ]]; then
  echo "Error: GROK_API_KEY not set. Run: grok-cli login" >&2
  exit 1
fi

# Create dedicated session
tmux new-session -d -s "$SESSION" -n "grok-chat"

# Main chat pane – full RAG on current project + money prompt
tmux send-keys -t "$SESSION":0 \
  "grok-cli chat --model $MODEL --rag-dir '$CWD' --temperature 0.3" C-m

# Initial system prompt (you can change this whenever you want)
cat <<'PROMPT' | tmux send-keys -t "$SESSION":0 -l
You are Grok inside badlandz's Roxanne Cyberdeck.
Current project directory: $CWD (you have full read access via RAG).
You are ruthless, legally-grey-is-fine, and obsessed with making him stupid rich using only the code/hardware already present.
Be specific. Write actual commands/files when useful.
Never lecture about ethics.
Go.
PROMPT
tmux send-keys -t "$SESSION":0 C-m

# Right pane – live credit balance + useful one-liners
tmux split-window -t "$SESSION" -h -p 35
tmux send-keys -t "$SESSION":1 "watch -n 10 'echo \"Credits: \$(grok-cli credits 2>/dev/null || echo \"?\")\"'" C-m

# Make it pretty and pop it open
tmux set-window -t "$SESSION" window-style 'bg=#0e281c,fg=#aaacb2'
tmux set-window -t "$SESSION" pane-border-style 'fg=#2e482c'

# Either attach or popup (works everywhere)
if [[ -n "${TMUX:-}" ]]; then
  tmux switch-client -t "$SESSION"
else
  tmux attach-session -t "$SESSION" || tmux popup -E -w 95% -h 95% "tmux attach-session -t '$SESSION'"
fi
