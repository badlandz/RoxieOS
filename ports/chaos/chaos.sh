#!/usr/local/bin/bash
# chaos - BAUXBSD anti-burn-in screensaver
# Prevents screen burn-in with dynamic tmux effects

# Configuration
IDLE_TIMEOUT=900  # 15 minutes in seconds
CHAOS_DURATION=300  # 5 minutes of chaos max

# Colors for effects
colors=("red" "green" "blue" "yellow" "magenta" "cyan")

# Save current tmux state
save_state() {
    tmux display-message "CHAOS: Saving session state..."
    # Save current layout and panes
    tmux list-panes -F "#{pane_id}:#{pane_current_command}" > /tmp/chaos_panes 2>/dev/null || true
    tmux list-windows -F "#{window_id}:#{window_layout}" > /tmp/chaos_layout 2>/dev/null || true
}

# Restore tmux state
restore_state() {
    tmux display-message "CHAOS: Restoring session..."
    # Kill all panes except current
    tmux kill-pane -a 2>/dev/null || true
    # Try to restore basic layout (simplified)
    tmux select-layout main-vertical 2>/dev/null || true
    tmux set -g status on
    tmux set -g status-style ""
    tmux set -g status-left ""
    tmux set -g status-right ""
    rm -f /tmp/chaos_panes /tmp/chaos_layout
}

# Check if system is idle (simplified - checks tmux activity)
is_idle() {
    # Check tmux last activity
    local last_activity=$(tmux display-message -p "#{client_last_activity}")
    local now=$(date +%s)
    local diff=$((now - last_activity))

    [ $diff -gt $IDLE_TIMEOUT ]
}

# Chaos effects
run_chaos() {
    local start_time=$(date +%s)

    while [ $(( $(date +%s) - start_time )) -lt $CHAOS_DURATION ]; do
        # Check for keypress (tmux activity)
        if ! is_idle; then
            restore_state
            return 0
        fi

        # Random pane effects
        case $((RANDOM % 6)) in
            0) tmux split-window -h -p $((RANDOM % 60 + 20)) "btop -p 0" ;;
            1) tmux split-window -v -p $((RANDOM % 70 + 15)) "cmatrix -C ${colors[$((RANDOM % 6))]}" ;;
            2) tmux split-window -v "fastfetch --logo none" ;;
            3) tmux swap-pane -D ;;
            4) tmux rotate-window ;;
            5) tmux select-pane -R ;;
        esac

        # Status bar chaos
        if [ $((RANDOM % 10)) -eq 0 ]; then
            tmux set -g status-style "bg=#${colors[$((RANDOM % 6))]},fg=#000000"
            tmux set -g status-left "CHAOS MODE"
            tmux set -g status-right "PRESS ANY KEY"
        fi

        sleep $((RANDOM % 3 + 1))
    done

    restore_state
}

# Main function
main() {
    # Only run if in tmux
    if [ -z "$TMUX" ]; then
        echo "chaos: Must be run inside tmux session"
        exit 1
    fi

    # Wait for idle
    while true; do
        if is_idle; then
            save_state
            run_chaos
        fi
        sleep 60  # Check every minute
    done
}

# Run main function
main "$@"
