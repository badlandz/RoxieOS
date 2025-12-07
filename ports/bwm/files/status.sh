#!/usr/local/bin/bash
# BAUXWM status bar — shows session info when BAUXWM=1

get_sessions() {
    # Get tmux sessions if available
    if command -v tmux >/dev/null 2>&1; then
        tmux list-sessions 2>/dev/null | awk -F: '{print $1}' | tr '\n' ' ' | sed 's/ $//'
    else
        echo ""
    fi
}

get_battery() {
    # Try to get battery info (FreeBSD)
    if [ -f /dev/acpi ]; then
        # This is a simplified version - would need acpi or similar
        echo "AC"
    else
        echo ""
    fi
}

while :; do
    sessions=""
    if [ "$BAUXWM" = "1" ]; then
        sessions="$(get_sessions)"
        if [ -n "$sessions" ]; then
            sessions="[$sessions] "
        fi
    fi

    battery="$(get_battery)"
    time_str="$(date '+%a %d %b %H:%M')"

    # Format: [sessions] battery time
    status="${sessions}${battery} ${time_str}"

    xsetroot -name "$status"
    sleep 10
done
