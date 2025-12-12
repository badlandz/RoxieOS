#!/bin/bash
# BAUX-BOT Local - Ollama-powered AI assistant with RAG

set -euo pipefail

# Configuration
PROJECT_ROOT="/src/roxanne"
RAG_DIR="./rag"
MODEL="${BAUX_MODEL:-smollm2:135m}"
MAX_CONTEXT=8000

mkdir -p "$RAG_DIR"

# Build comprehensive RAG context
build_rag() {
    local rag_file="$RAG_DIR/current.txt"

    # Ensure directory exists
    mkdir -p "$RAG_DIR"

    echo "=== ROXANNE CYBERDECK PROJECT CONTEXT ===" > "$rag_file"
    echo "Generated: $(date)" >> "$rag_file"
    echo "Project: Roxanne Cyberdeck OS - FreeBSD-based portable development environment" >> "$rag_file"
    echo "Architecture: bbase (foundation) + baux (session manager) + bwm (window manager)" >> "$rag_file"
    echo "Goal: USB boot -> root shell -> instant productivity with tmux + neovim + AI" >> "$rag_file"
    echo >> "$rag_file"

    # Key project files
    echo "=== KEY FILES ===" >> "$rag_file"
    for file in "$PROJECT_ROOT/README.md" "$PROJECT_ROOT/PROJECT.md" "$PROJECT_ROOT/ROADMAP.md"; do
        if [[ -f "$file" ]]; then
            echo "--- $(basename "$file") ---" >> "$rag_file"
            head -n 10 "$file" >> "$rag_file" 2>/dev/null || true
            echo >> "$rag_file"
        fi
    done

    # Simple file listing
    echo "=== PROJECT STRUCTURE ===" >> "$rag_file"
    ls -la "$PROJECT_ROOT" >> "$rag_file" 2>/dev/null || true
}

# Query Ollama with RAG context
query_ollama() {
    local question="$1"
    local context_file="$RAG_DIR/current.txt"
    
    # Read context
    local context=""
    if [[ -f "$context_file" ]]; then
        context=$(head -c $MAX_CONTEXT "$context_file" 2>/dev/null || echo "")
    fi
    
    # Build prompt
    local prompt="You are BAUX-BOT, an AI assistant for Roxanne Cyberdeck OS development.

PROJECT CONTEXT:
$context

USER QUESTION: $question

Provide direct, technical, and helpful answers. Reference specific files and code when relevant. Focus on FreeBSD, tmux, AI integration, and cyberdeck development. Be concise but thorough."

    # Query Ollama
    echo "$prompt" | ollama run "$MODEL" --nowordwrap 2>/dev/null || echo "Ollama error: Model $MODEL not available"
}

# Self-improvement capabilities
improve_self() {
    local suggestion="$1"
    
    echo "🤖 BAUX-BOT Self-Improvement Mode"
    echo "=================================="
    echo "Analyzing suggestion: $suggestion"
    echo
    
    local analysis
    analysis=$(query_ollama "Analyze this improvement suggestion for BAUX-BOT: $suggestion. Provide specific code changes if applicable.")
    
    echo "Analysis:"
    echo "$analysis"
    echo
    
    echo "Apply changes? (y/n): "
    read -r apply
    if [[ "$apply" == "y" ]]; then
        echo "What file should be modified?"
        read -r file
        echo "What changes should be made?"
        read -r changes
        
        if [[ -f "$file" ]]; then
            echo "Current content of $file:"
            cat "$file"
            echo
            echo "Apply these changes? (y/n): "
            read -r confirm
            if [[ "$confirm" == "y" ]]; then
                # This would need more sophisticated editing
                echo "Self-improvement applied (placeholder)"
            fi
        fi
    fi
}

# Main interface
main() {
    echo "🤖 BAUX-BOT Local AI Assistant"
    echo "================================"
    
    # Build initial context
    echo "Building project context..."
    build_rag
    local lines
    if [[ -f "$RAG_DIR/current.txt" ]]; then
        lines=$(wc -l < "$RAG_DIR/current.txt")
    else
        lines="0"
    fi
    echo "Context loaded: $lines lines using $MODEL"
    echo
    echo "Commands:"
    echo "  'rebuild' - Rebuild project context"
    echo "  'improve <suggestion>' - Self-improvement mode"
    echo "  'model <name>' - Switch models"
    echo "  'exit' - Quit"
    echo
    
    while true; do
        echo -n "you > "
        read -r input
        
        if [[ "$input" == "exit" || "$input" == "quit" ]]; then
            echo "BAUX-BOT offline."
            break
        fi
        
        if [[ -z "$input" ]]; then
            continue
        fi
        
        # Special commands
        if [[ "$input" == "rebuild" ]]; then
            echo "Rebuilding context..."
            build_rag
            local new_lines
            new_lines=$(wc -l < "$RAG_DIR/current.txt" 2>/dev/null || echo "0")
            echo "Context updated: $new_lines lines"
            continue
        fi
        
        if [[ "$input" =~ ^model ]]; then
            local new_model
            new_model=$(echo "$input" | cut -d' ' -f2)
            if ollama list | grep -q "$new_model"; then
                MODEL="$new_model"
                echo "Switched to model: $MODEL"
            else
                echo "Model $new_model not available. Available:"
                ollama list
            fi
            continue
        fi
        
        if [[ "$input" =~ ^improve ]]; then
            local suggestion
            suggestion=$(echo "$input" | cut -d' ' -f2-)
            improve_self "$suggestion"
            continue
        fi
        
        echo -n "baux-bot > "
        query_ollama "$input"
        echo
    done
}

main "$@"
