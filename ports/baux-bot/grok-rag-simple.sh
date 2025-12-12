#!/bin/bash
# Simple RAG-enhanced GROK interface

set -euo pipefail

# Configuration
PROJECT_ROOT="/src/roxanne"
RAG_DIR="./rag"
API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

if [[ -z "$API_KEY" ]]; then
    echo "Error: GROK_API_KEY not found"
    exit 1
fi

mkdir -p "$RAG_DIR"

# Build simple RAG context
build_context() {
    local rag_file="$RAG_DIR/context.txt"
    
    echo "=== ROXANNE PROJECT CONTEXT ===" > "$rag_file"
    echo "This is Roxanne Cyberdeck OS, a FreeBSD-based portable development environment." >> "$rag_file"
    echo "Three layers: bbase (foundation), baux (session manager), bwm (window manager)." >> "$rag_file"
    echo "Goal: USB boot -> root shell -> instant productivity." >> "$rag_file"
    echo >> "$rag_file"
    
    # Add some key files
    if [[ -f "$PROJECT_ROOT/README.md" ]]; then
        echo "=== README ===" >> "$rag_file"
        head -n 10 "$PROJECT_ROOT/README.md" >> "$rag_file" 2>/dev/null || true
    fi
}

# Call GROK with context
ask_grok() {
    local question="$1"
    local context_file="$RAG_DIR/context.txt"
    
    local context=""
    if [[ -f "$context_file" ]]; then
        context=$(cat "$context_file")
    fi
    
    local prompt="Context about Roxanne project:
$context

Question: $question

Answer based on the context above."
    
    local response
    response=$(curl -s https://api.x.ai/v1/chat/completions \
      -H "Authorization: Bearer $API_KEY" \
      -H "Content-Type: application/json" \
      -d "{
        \"model\": \"grok-2-1212\",
        \"messages\": [
          {
            \"role\": \"system\",
            \"content\": \"You are Grok helping build Roxanne Cyberdeck OS.\"
          },
          {
            \"role\": \"user\",
            \"content\": \"$prompt\"
          }
        ],
        \"temperature\": 0.3
      }")
    
    echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null || echo "API Error"
}

# Main
main() {
    echo "🤖 Roxanne AI Assistant (Simple RAG)"
    echo "===================================="
    
    build_context
    echo "Context ready."
    echo "Commands: 'rebuild', 'exit'"
    echo
    
    while true; do
        echo -n "you > "
        read -r input
        
        if [[ "$input" == "exit" ]]; then
            break
        fi
        
        if [[ "$input" == "rebuild" ]]; then
            build_context
            echo "Context rebuilt."
            continue
        fi
        
        if [[ -z "$input" ]]; then
            continue
        fi
        
        echo -n "grok > "
        ask_grok "$input"
        echo
    done
}

main "$@"
