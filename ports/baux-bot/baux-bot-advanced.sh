#!/bin/bash
# Advanced BAUX-BOT with RAG and self-improvement

set -euo pipefail

# Configuration
PROJECT_ROOT="/src/roxanne"
RAG_DIR="./rag"
MODEL="smollm2:135m"

mkdir -p "$RAG_DIR"

# Build basic RAG context
build_context() {
    local rag_file="$RAG_DIR/context.txt"
    
    echo "=== ROXANNE CYBERDECK PROJECT ===" > "$rag_file"
    echo "FreeBSD-based portable development environment" >> "$rag_file"
    echo "Three layers: bbase + baux + bwm" >> "$rag_file"
    echo "Goal: USB boot -> root shell -> instant productivity" >> "$rag_file"
    echo >> "$rag_file"
    
    # Add key project info
    if [[ -f "$PROJECT_ROOT/README.md" ]]; then
        echo "=== PROJECT README ===" >> "$rag_file"
        head -n 15 "$PROJECT_ROOT/README.md" >> "$rag_file" 2>/dev/null || true
    fi
}

# Query AI with context
query_ai() {
    local question="$1"
    local context_file="$RAG_DIR/context.txt"
    
    local context=""
    if [[ -f "$context_file" ]]; then
        context=$(cat "$context_file")
    fi
    
    local prompt="You are BAUX-BOT, an AI assistant for Roxanne Cyberdeck OS development.

PROJECT CONTEXT:
$context

QUESTION: $question

Provide helpful, technical answers focused on FreeBSD, tmux, AI integration, and cyberdeck development."

    echo "$prompt" | ollama run "$MODEL" --nowordwrap 2>/dev/null || echo "AI Error"
}

# Self-improvement analysis
analyze_improvement() {
    local suggestion="$1"
    
    echo "🤖 BAUX-BOT Self-Analysis Mode"
    echo "=============================="
    
    local analysis
    analysis=$(query_ai "Analyze this improvement suggestion for BAUX-BOT: $suggestion. What specific changes would help?")
    
    echo "Analysis:"
    echo "$analysis"
    echo
    echo "This is a foundation for self-improvement. The AI can now analyze its own capabilities!"
}

# Main interface
main() {
    echo "🤖 BAUX-BOT Advanced AI Assistant"
    echo "================================="
    
    build_context
    echo "Context loaded. Model: $MODEL"
    echo
    echo "Commands:"
    echo "  'rebuild' - Rebuild project context"
    echo "  'analyze <suggestion>' - Self-improvement analysis"
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
            build_context
            echo "Context rebuilt."
            continue
        fi
        
        if [[ "$input" =~ ^analyze ]]; then
            local suggestion
            suggestion=$(echo "$input" | cut -d' ' -f2-)
            analyze_improvement "$suggestion"
            continue
        fi
        
        echo -n "baux-bot > "
        query_ai "$input"
        echo
    done
}

main "$@"
