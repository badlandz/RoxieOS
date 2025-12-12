#!/bin/bash
# Simple GROK chat interface

echo "🤖 Roxanne Cyberdeck AI Assistant"
echo "=================================="
echo "Type your questions. Type 'exit' to quit."
echo

while true; do
    echo -n "you > "
    read -r input
    
    if [[ "$input" == "exit" || "$input" == "quit" ]]; then
        echo "Goodbye!"
        break
    fi
    
    if [[ -z "$input" ]]; then
        continue
    fi
    
    echo -n "grok > "
    echo "$input" | ./grok-simple.sh
    echo
done
