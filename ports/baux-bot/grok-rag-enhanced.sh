#!/bin/bash
# Enhanced GROK with RAG - reads project files for context

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-/src/roxanne}"
RAG_DIR="$SCRIPT_DIR/rag"
MAX_CONTEXT_SIZE=4000

# API Key
API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"
if [[ -z "$API_KEY" ]]; then
    echo "Error: GROK_API_KEY not found"
    exit 1
fi

# Create RAG directory
mkdir -p "$RAG_DIR"

# Build comprehensive RAG context
build_rag_context() {
    local rag_file="$RAG_DIR/current.txt"
    
    echo "=== ROXANNE CYBERDECK PROJECT CONTEXT ===" > "$rag_file"
    echo "Generated: $(date)" >> "$rag_file"
    echo "Project Root: $PROJECT_ROOT" >> "$rag_file"
    echo >> "$rag_file"
    
    # Project overview
    echo "=== PROJECT OVERVIEW ===" >> "$rag_file"
    if [[ -f "$PROJECT_ROOT/README.md" ]]; then
        head -n 20 "$PROJECT_ROOT/README.md" >> "$rag_file" 2>/dev/null || true
    fi
    echo >> "$rag_file"
    
    # Key directories and files
    echo "=== KEY DIRECTORIES ===" >> "$rag_file"
    find "$PROJECT_ROOT" -maxdepth 2 -type d -name "packages" -o -name "scripts" -o -name "docs" | head -10 >> "$rag_file" 2>/dev/null || true
    echo >> "$rag_file"
    
    # Recent source files
    echo "=== RECENT SOURCE FILES ===" >> "$rag_file"
    find "$PROJECT_ROOT" -type f \( -name "*.sh" -o -name "*.md" -o -name "*.lua" -o -name "*.py" \) \
        -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -15 | cut -d' ' -f2- | \
    while read -r file; do
        echo "--- $(basename "$file") ---" >> "$rag_file"
        head -n 15 "$file" >> "$rag_file" 2>/dev/null || true
        echo >> "$rag_file"
    done || true
    
    # Current git status
    echo "=== GIT STATUS ===" >> "$rag_file"
    if cd "$PROJECT_ROOT" 2>/dev/null && git rev-parse --git-dir >/dev/null 2>&1; then
        git status --porcelain >> "$rag_file" 2>/dev/null || true
        echo >> "$rag_file"
        git log --oneline -5 >> "$rag_file" 2>/dev/null || true
    fi
}

# Enhanced GROK API call with context
call_grok_with_context() {
    local question="$1"
    local context_file="$RAG_DIR/current.txt"
    
    # Read context
    local context=""
    if [[ -f "$context_file" ]]; then
        context=$(head -c $MAX_CONTEXT_SIZE "$context_file" 2>/dev/null || echo "")
    fi
    
    # Build prompt
    local system_prompt="You are Grok, an AI assistant helping build Roxanne Cyberdeck OS. You have access to the current project context and can read/modify code files. Be direct, technical, and ruthlessly helpful. Focus on FreeBSD, tmux, AI integration, and cyberdeck development."
    
    local user_content=""
    if [[ -n "$context" ]]; then
        user_content="PROJECT CONTEXT:
$context

QUESTION: $question

Please use the project context above to provide specific, actionable advice. Reference specific files and code when relevant."
    else
        user_content="$question"
    fi
    
    # Make API call
    local response
    response=$(curl -s https://api.x.ai/v1/chat/completions \
      -H "Authorization: Bearer $API_KEY" \
      -H "Content-Type: application/json" \
      -d "{
        \"model\": \"grok-2-1212\",
        \"messages\": [
          {
            \"role\": \"system\",
            \"content\": \"$system_prompt\"
          },
          {
            \"role\": \"user\",
            \"content\": \"$user_content\"
          }
        ],
        \"temperature\": 0.3,
        \"max_tokens\": 1500
      }")
    
    # Extract content
    local content
    content=$(echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null)
    
    if [[ -n "$content" && "$content" != "null" ]]; then
        echo "$content"
    else
        echo "API Error: $(echo "$response" | jq -r '.error.message // "Unknown error"' 2>/dev/null || echo "$response")"
    fi
}

# Main interface
main() {
    echo "🤖 Roxanne Cyberdeck AI Assistant (Enhanced RAG)"
    echo "=================================================="
    
    # Build initial context
    echo "Building project context..."
    build_rag_context
    local context_lines
    context_lines=$(wc -l < "$RAG_DIR/current.txt" 2>/dev/null || echo "0")
    echo "Context loaded: $context_lines lines"
    echo "Type your questions. Special commands:"
    echo "  'rebuild' - Rebuild project context"
    echo "  'exit' - Quit"
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
            build_rag_context
            local new_lines
            new_lines=$(wc -l < "$RAG_DIR/current.txt" 2>/dev/null || echo "0")
            echo "Context updated: $new_lines lines"
            continue
        fi
        
        echo -n "grok > "
        call_grok_with_context "$input"
        echo
    done
}

main "$@"
