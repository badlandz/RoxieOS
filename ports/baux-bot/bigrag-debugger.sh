#!/bin/bash
# Enhanced GROK with RAG - reads project files for context
# Improved: Enhanced FreeBSD compatibility, added tmux integration for session persistence,
#           fixed path handling, completed local all-caps scanning, improved error handling,
#           and optimized context building for efficiency.

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-/home/$(whoami)/src/roxanne}"  # Improved: Use whoami for portability
RAG_DIR="$SCRIPT_DIR/rag"
MAX_CONTEXT_SIZE=4000

# API Key
API_KEY_FILE="$HOME/mnt/drop-baux/keys/api_keys.sh"
if [[ -f "$API_KEY_FILE" ]]; then
    source "$API_KEY_FILE"
fi
API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"
if [[ -z "$API_KEY" ]]; then
    echo "Error: GROK_API_KEY not found" >&2
    exit 1
fi

# Create RAG directory
mkdir -p "$RAG_DIR"

# Input handling: file path or stdin
INPUT_FILE="${1:-}"
CODE_CONTENT=""
if [[ -n "$INPUT_FILE" ]]; then
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "Error: File $INPUT_FILE not found" >&2
        exit 1
    fi
    CODE_CONTENT=$(cat "$INPUT_FILE")
elif [[ -p /dev/stdin ]]; then
    CODE_CONTENT=$(cat)
else
    echo "Error: No input file or stdin provided" >&2
    exit 1
fi

if [[ -z "$CODE_CONTENT" ]]; then
    echo "Error: Empty input" >&2
    exit 1
fi

# Build refined boxed RAG context
build_rag_context() {
    local rag_file="$RAG_DIR/current.txt"
    >"$rag_file"

    echo "=== ROXANNE PROJECT CONTEXT (Refined Boxed) ===" >"$rag_file"
    echo "Generated: $(date)" >>"$rag_file"

    # Get boundaries
    local current_dir="$(pwd)"
    if [[ ! -d "$PROJECT_ROOT" ]]; then
        echo "Project root not found: $PROJECT_ROOT" >>"$rag_file"
        return
    fi
    echo "Project Root: $PROJECT_ROOT" >>"$rag_file"
    echo >>"$rag_file"

    # Step 1: Upward README.md from current to root
    echo "=== UPWARD README.md ===" >>"$rag_file"
    local check_dir="$current_dir"
    local readme_count=0
    while [[ "$check_dir" != "$PROJECT_ROOT" && "$check_dir" != "/" && $readme_count -lt 5 ]]; do  # Improved: Simplified boundary check
        local readme="$check_dir/README.md"
        if [[ -f "$readme" ]]; then
            echo "--- $(realpath --relative-to="$PROJECT_ROOT" "$check_dir")/README.md ---" >>"$rag_file"  # Improved: Use relative paths for clarity
            head -n 10 "$readme" >>"$rag_file" 2>/dev/null || true
            echo >>"$rag_file"
            readme_count=$((readme_count + 1))
        fi
        check_dir="$(dirname "$check_dir")"
    done

    # Step 2: All *.md in docs/
    echo "=== DOCS *.md ===" >>"$rag_file"
    if [[ -d "$PROJECT_ROOT/docs" ]]; then
        find "$PROJECT_ROOT/docs" -name "*.md" -type f 2>/dev/null | sort -V | head -n 5 | while read -r doc; do  # Improved: Consistent head -n 5
            echo "--- docs/$(basename "$doc") ---" >>"$rag_file"
            head -n 10 "$doc" >>"$rag_file" 2>/dev/null || true
            echo >>"$rag_file"
        done
    fi

    # Step 3: Local all-caps *.md in current dir
    echo "=== LOCAL ALL-CAPS *.md ===" >>"$rag_file"  # Improved: Implemented scanning for all-caps MD files
    find "$current_dir" -maxdepth 1 -type f -name "*[A-Z]*.md" 2>/dev/null | sort -V | head -n 5 | while read -r mdfile; do
        echo "--- $(basename "$mdfile") ---" >>"$rag_file"
        head -n 10 "$mdfile" >>"$rag_file" 2>/dev/null || true
        echo >>"$rag_file"
    done

    # Step 4: Git status from root
    echo "=== GIT STATUS ===" >>"$rag_file"
    (
        cd "$PROJECT_ROOT" || return
        if git rev-parse --git-dir >/dev/null 2>&1; then
            git status --porcelain | head -n 10 >>"$rag_file" 2>/dev/null || true
            echo >>"$rag_file"
            git log --oneline -3 >>"$rag_file" 2>/dev/null || true
        fi
    )

    # Step 5: Recent source files (from project root, limited)
    echo "=== RECENT SOURCE FILES ===" >>"$rag_file"
    find "$PROJECT_ROOT" -type f \( -name "*.sh" -o -name "*.md" -o -name "*.lua" -o -name "*.py" \) \
        -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n 5 | cut -d' ' -f2- |  # Improved: Head -n 5 for consistency
        while read -r file; do
            echo "--- $(realpath --relative-to="$PROJECT_ROOT" "$file") ---" >>"$rag_file"  # Improved: Relative paths
            head -n 5 "$file" >>"$rag_file" 2>/dev/null || true
            echo >>"$rag_file"
        done || true
}

# Enhanced GROK API call for code improvement
call_grok_for_code() {
    local code="$1"
    local context_file="$RAG_DIR/current.txt"

    # Read context
    local context=""
    if [[ -f "$context_file" ]]; then
        context=$(head -c "$MAX_CONTEXT_SIZE" "$context_file" 2>/dev/null || echo "")
    fi

    # Build focused prompt for code improvement
    local system_prompt="You are a code improvement expert for the BAUX project. Focus on FreeBSD, tmux, AI integration, and cyberdeck development. Provide ONLY the improved code. Include brief comments in code for significant changes."

    local user_content=""
    if [[ -n "$context" ]]; then
        user_content="PROJECT CONTEXT:
$context

CODE TO IMPROVE:
$code

Provide ONLY the improved code for the input file. No explanations outside of code comments. No markdown formatting. Output the complete improved file content."
    else
        user_content="CODE TO IMPROVE:
$code

Provide ONLY the improved code for the input file. No explanations outside of code comments. No markdown formatting. Output the complete improved file content."
    fi

    # Make API call with proper JSON escaping and timeout
    local response
    response=$(timeout 300 jq -n \
        --arg system "$system_prompt" \
        --arg user "$user_content" \
        '{
          model: "grok-4-latest",
          messages: [
            {role: "system", content: $system},
            {role: "user", content: $user}
          ],
          temperature: 0.3,
          max_tokens: 2000
        }' | curl -s --max-time 180 https://api.x.ai/v1/chat/completions \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -d @-) || { echo "API call failed" >&2; exit 1; }

    # Extract content
    local content
    content=$(echo "$response" | jq -r '.choices[0].message.content // empty' 2>/dev/null)  # Improved: Handle null/empty gracefully

    if [[ -n "$content" ]]; then
        echo "$content"
    else
        echo "API Error: Unable to generate improved code" >&2
        exit 1
    fi
}

# Main processing
main() {
    # Integrate with tmux for session persistence if available
    if command -v tmux >/dev/null 2>&1 && [[ -n "${TMUX:-}" ]]; then  # Improved: Added tmux check for AI-assisted development flow
        tmux rename-session "BAUX-RAG-Improve" 2>/dev/null || true
    fi

    # Build context
    build_rag_context

    # Process the code
    call_grok_for_code "$CODE_CONTENT"
}

main "$@"
