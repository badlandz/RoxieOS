#!/bin/bash
# grok-chat-rag.sh - GROK chat with RAG (project file context)

set -euo pipefail

# Configuration
RAG_DIR="${RAG_DIR:-./rag}"
mkdir -p "$RAG_DIR"

# Build RAG context from current project
build_rag() {
    local rag_file="$RAG_DIR/current.txt"
    local project_root
    
    # Find project root (look for .git or go up to /src)
    if git rev-parse --git-dir >/dev/null 2>&1; then
        project_root="$(git rev-parse --show-toplevel)"
    else
        project_root="/src/roxanne"
    fi
    
    echo "=== ROXANNE CYBERDECK PROJECT CONTEXT ===" > "$rag_file"
    echo "Project: Roxanne Cyberdeck OS - FreeBSD-based portable development environment" >> "$rag_file"
    echo "Goal: Instant productivity USB boot -> root shell -> tmux + neovim + AI assistance" >> "$rag_file"
    echo "Architecture: bbase (foundation) + baux (session manager) + bwm (window manager)" >> "$rag_file"
    echo "Project root: $project_root" >> "$rag_file"
    echo "Current directory: $(pwd)" >> "$rag_file"
    echo "Date: $(date)" >> "$rag_file"
    echo >> "$rag_file"
    
    # Add key project information
    echo "=== KEY PROJECT INFO ===" >> "$rag_file"
    echo "Three Layers: bbase (foundation) + baux (session manager) + bwm (window manager)" >> "$rag_file"
    echo "Goal: USB boot -> root shell -> instant productivity" >> "$rag_file"
    echo "Key Features: tmux sessions, neovim, AI assistance, no users/sudo" >> "$rag_file"
    echo >> "$rag_file"

    # Add recent files (just key files, not full content)
    echo "=== RECENT KEY FILES ===" >> "$rag_file"
    find "$project_root" -name "README.md" -o -name "*.sh" | head -5 | \
    while read -r file; do
        echo "--- $(basename "$file") ---" >> "$rag_file"
        head -n 10 "$file" >> "$rag_file" 2>/dev/null || true
        echo >> "$rag_file"
    done || true
}

# Main chat interface
main() {
    echo "🤖 Roxanne Cyberdeck AI Assistant (with RAG)"
    echo "=============================================="
    echo "Building project context..."
    
    build_rag
    local rag_content
    rag_content="$(cat "$RAG_DIR/current.txt" 2>/dev/null || echo 'No context available')"
    
    echo "Context loaded ($(wc -l < "$RAG_DIR/current.txt") lines)"
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
        
        # Special commands
        if [[ "$input" == "rebuild" ]]; then
            echo "Rebuilding context..."
            build_rag
            echo "Context updated."
            continue
        fi
        
        echo -n "grok > "
        
        # Create payload with context
        local payload
        payload="$(jq -n --arg question "$input" --arg context "$rag_content" \
            '{question: $question, context: $context}')"
        
        echo "$payload" | ./grok-api.sh
        echo
    done
}

main "$@"
