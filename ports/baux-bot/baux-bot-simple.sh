#!/bin/bash
# Simple BAUX-BOT without complex RAG

MODEL="smollm2:135m"

echo "🤖 BAUX-BOT Simple AI Assistant"
echo "==============================="

query_ai() {
    local question="$1"
    echo "$question" | ollama run "$MODEL" --nowordwrap 2>/dev/null || echo "AI Error: Unable to get response"
}

echo "Commands: 'exit' to quit"
echo

while true; do
    echo -n "you > "
    read -r input
    
    if [[ "$input" == "exit" ]]; then
        echo "Goodbye!"
        break
    fi
    
    if [[ -z "$input" ]]; then
        continue
    fi
    
    echo -n "baux-bot > "
    query_ai "$input"
    echo
done
