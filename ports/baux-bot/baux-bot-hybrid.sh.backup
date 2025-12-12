#!/usr/local/bin/bash
# BAUX-BOT Hybrid - Ollama + GROK API for advanced reasoning

set -euo pipefail

# Configuration
PROJECT_ROOT="/src/RoxieOS"
RAG_DIR="./rag"
MODEL="qwen2.5-coder:1.5b"
GROK_API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

# Directory access control configuration
# Format: directory_path:access_level:description
DIRECTORY_CONFIG=(
    "/src/RoxieOS:readonly:RoxieOS project (reference)"
    "/src/RoxieOS/ports/baux-bot:build:BAUX-BOT FreeBSD port (current)"
    "/tmp/baux-bot-build:build:Temporary build directory for testing"
)

mkdir -p "$RAG_DIR"

# Directory access control functions
get_directory_access() {
    local dir_path="$1"
    for config in "${DIRECTORY_CONFIG[@]}"; do
        local config_dir config_access config_desc
        IFS=':' read -r config_dir config_access config_desc <<< "$config"
        if [[ "$dir_path" == "$config_dir" ]]; then
            echo "$config_access"
            return
        fi
    done
    echo "unknown"
}

is_readonly() {
    local dir_path="$1"
    # Check if the directory or any parent directory is readonly
    while [[ "$dir_path" != "/" ]]; do
        if [[ "$(get_directory_access "$dir_path")" == "readonly" ]]; then
            return 0
        fi
        dir_path=$(dirname "$dir_path")
    done
    return 1
}

is_build_dir() {
    local dir_path="$1"
    # Check if the directory or any parent directory is build
    while [[ "$dir_path" != "/" ]]; do
        if [[ "$(get_directory_access "$dir_path")" == "build" ]]; then
            return 0
        fi
        dir_path=$(dirname "$dir_path")
    done
    return 1
}

list_directories() {
    echo "Configured directories:"
    echo "Access Level | Path | Description"
    echo "-------------|------|------------"
    for config in "${DIRECTORY_CONFIG[@]}"; do
        local config_dir config_access config_desc
        IFS=':' read -r config_dir config_access config_desc <<< "$config"
        printf "%-12s | %-30s | %s\n" "$config_access" "$config_dir" "$config_desc"
    done
}

# Scan directory for relevant context files with smart diff compression
scan_directory_for_context() {
    local scan_dir="$1"
    local access_level="$2"
    local rag_file="$3"

    # Define file patterns to scan based on access level
    local file_patterns
    if [[ "$access_level" == "readonly" ]]; then
        # For read-only directories, scan more files for reference
        file_patterns=("*.sh" "*.c" "*.lua" "*.py" "*.conf" "*.md" "*.vim" "*.mk" "*.json" "*.toml")
    else
        # For build directories, focus on key implementation files
        file_patterns=("*.sh" "*.py" "*.md" "*.conf")
    fi

    # Scan for key directories and files
    for pattern in "${file_patterns[@]}"; do
        # Find files matching pattern, sort by modification time, take most recent
        while IFS= read -r -d '' file; do
            if [[ -f "$file" && -r "$file" ]]; then
                local rel_path="${file#$scan_dir/}"

                # Check if this file has a similar counterpart in other directories for diff analysis
                local similar_files
                similar_files=$(find_similar_files "$file" "$rel_path")

                if [[ -n "$similar_files" ]]; then
                    # Create compressed diff summary
                    echo "--- $rel_path ($access_level) - COMPRESSED DIFF ---" >> "$rag_file"
                    create_diff_summary "$file" "$similar_files" "$rag_file"
                else
                    # Include full content for unique files
                    echo "--- $rel_path ($access_level) ---" >> "$rag_file"

                    # Limit content based on access level and file type
                    if [[ "$access_level" == "readonly" ]]; then
                        # For readonly, include more content for reference
                        head -n 30 "$file" >> "$rag_file" 2>/dev/null || true
                    else
                        # For build directories, include less to keep context focused
                        head -n 15 "$file" >> "$rag_file" 2>/dev/null || true
                    fi
                fi

                # Add separator
                echo "---" >> "$rag_file"
            fi
        done < <(find "$scan_dir" -name "$pattern" -type f -print0 2>/dev/null | head -20)
    done
}

# Find similar files across configured directories
find_similar_files() {
    local source_file="$1"
    local rel_path="$2"
    local similar_found=""

    # Check all other configured directories for similar files
    for config in "${DIRECTORY_CONFIG[@]}"; do
        local config_dir config_access
        IFS=':' read -r config_dir config_access <<< "$config"

        local potential_match="$config_dir/$rel_path"
        if [[ -f "$potential_match" && "$potential_match" != "$source_file" ]]; then
            similar_found="$similar_found $potential_match"
        fi
    done

    echo "$similar_found" | sed 's/^ *//'
}

# Create compressed diff summary between similar files
create_diff_summary() {
    local source_file="$1"
    local similar_files="$2"
    local rag_file="$3"

    echo "SOURCE: $source_file" >> "$rag_file"

    # Compare with each similar file
    for similar_file in $similar_files; do
        echo "COMPARING WITH: $similar_file" >> "$rag_file"

        # Check if file exists
        if [[ ! -f "$similar_file" ]]; then
            echo "FILE NOT FOUND: $similar_file" >> "$rag_file"
            continue
        fi

        # Create compressed diff summary
        if diff -u "$source_file" "$similar_file" >> "$rag_file" 2>/dev/null; then
            echo "FILES ARE IDENTICAL" >> "$rag_file"
        else
            echo "FILES DIFFER - unified diff above" >> "$rag_file"
        fi

        echo "" >> "$rag_file"
    done
}

# Safe code modification function
safe_modify_file() {
    local target_file="$1"
    local modification_request="$2"

    # Check if target file is in a build directory
    local file_dir
    file_dir=$(dirname "$target_file")

    if ! is_build_dir "$file_dir"; then
        echo "ERROR: Cannot modify file in read-only directory: $file_dir"
        echo "File: $target_file"
        echo "Only build directories can be modified for safety."
        return 1
    fi

    # Check git status before modification (only if target is in a git repo)
    if git -C "$(dirname "$target_file")" rev-parse --git-dir > /dev/null 2>&1; then
        # Target file is in a git repository, check if the specific target file has uncommitted changes
        if git -C "$(dirname "$target_file")" diff --quiet "$target_file" && git -C "$(dirname "$target_file")" diff --cached --quiet "$target_file"; then
            echo "Note: Target file is in a git repository and clean, proceeding with modification."
        else
            echo "ERROR: Target file has uncommitted changes. Please commit or stash changes to the target file before proceeding."
            echo "Target file: $target_file"
            return 1
        fi
    else
        echo "Note: Target file is not in a git repository, proceeding without git safety check."
    fi

    echo "✅ File is in build directory and git is clean"
    echo "Target file: $target_file"
    echo "Modification request: $modification_request"

    # Use GROK to generate the modification, fallback to Claude, then Ollama
    local modify_prompt="Modify Debian BAUX script: add session numbering like FreeBSD version. Change SESSION assignment and add switch case."
    # Keep it very short to avoid JSON issues

    # Debug: check for control characters
    echo "DEBUG: Prompt preview: ${modify_prompt:0:100}..." >&2
    if [[ "$modify_prompt" =~ [[:cntrl:]] ]]; then
        echo "ERROR: Prompt contains control characters" >&2
        return 1
    fi

    local new_content
    new_content=$(query_grok "$modify_prompt")

    if [[ $? -ne 0 || -z "$new_content" ]]; then
        echo "GROK failed, trying Claude fallback..."
        new_content=$(query_claude "$modify_prompt")

        if [[ $? -ne 0 || -z "$new_content" ]]; then
            echo "Claude failed, trying Ollama fallback..."
            local ollama_prompt="Modify this bash script: $modification_request

Current script:
$(cat "$target_file")

Return only the complete modified script."
            new_content=$(query_ollama "$ollama_prompt")

            if [[ -z "$new_content" || "$new_content" == "Ollama Error" ]]; then
                echo "ERROR: All AI services failed to generate modification"
                return 1
            fi
        fi
    fi

    # Create backup
    cp "$target_file" "${target_file}.backup"

    # Apply modification
    echo "$new_content" > "$target_file"

    # Test syntax if it's a shell script
    if [[ "$target_file" == *.sh ]]; then
        if ! bash -n "$target_file" 2>/dev/null; then
            echo "ERROR: Syntax error in modified file. Rolling back..."
            mv "${target_file}.backup" "$target_file"
            return 1
        fi
    fi

    echo "✅ Modification applied successfully"
    echo "Backup created: ${target_file}.backup"

    # Optional: commit the change
    echo "Consider running: git add '$target_file' && git commit -m 'BAUX-BOT modification: $modification_request'"

    return 0
}

# Build comprehensive RAG context from multiple directories
build_context() {
    local rag_file="$RAG_DIR/context.txt"

    echo "=== ROXANNE CYBERDECK PROJECT CONTEXT ===" > "$rag_file"
    echo "Generated: $(date)" >> "$rag_file"
    echo "Project: FreeBSD-based portable development environment" >> "$rag_file"
    echo "Architecture: bbase (foundation) + baux (session manager) + bwm (window manager)" >> "$rag_file"
    echo "Goal: USB boot -> root shell -> instant productivity with tmux + neovim + AI" >> "$rag_file"
    echo >> "$rag_file"

    # Add directory access configuration
    echo "=== DIRECTORY ACCESS CONFIGURATION ===" >> "$rag_file"
    for config in "${DIRECTORY_CONFIG[@]}"; do
        local config_dir config_access config_desc
        IFS=':' read -r config_dir config_access config_desc <<< "$config"
        echo "Directory: $config_dir" >> "$rag_file"
        echo "Access: $config_access" >> "$rag_file"
        echo "Description: $config_desc" >> "$rag_file"
        echo >> "$rag_file"
    done

    # Add current BAUX-BOT code for self-improvement
    echo "=== BAUX-BOT CURRENT CODE ===" >> "$rag_file"
    echo "File: baux-bot-hybrid.sh (build directory)" >> "$rag_file"
    head -n 50 "$0" >> "$rag_file" 2>/dev/null || true
    echo >> "$rag_file"

    # Scan all configured directories for context
    for config in "${DIRECTORY_CONFIG[@]}"; do
        local config_dir config_access config_desc
        IFS=':' read -r config_dir config_access config_desc <<< "$config"

        if [[ -d "$config_dir" ]]; then
            echo "=== DIRECTORY CONTEXT: $(basename "$config_dir") ===" >> "$rag_file"
            echo "Path: $config_dir" >> "$rag_file"
            echo "Access Level: $config_access" >> "$rag_file"
            echo "Description: $config_desc" >> "$rag_file"
            echo >> "$rag_file"

            # Scan for key files in this directory
            scan_directory_for_context "$config_dir" "$config_access" "$rag_file"
            echo >> "$rag_file"
        else
            echo "=== DIRECTORY NOT FOUND ===" >> "$rag_file"
            echo "Path: $config_dir ($config_access)" >> "$rag_file"
            echo "Status: Directory does not exist" >> "$rag_file"
            echo >> "$rag_file"
        fi
    done

    # Add project files
    if [[ -f "$PROJECT_ROOT/README.md" ]]; then
        echo "=== PROJECT README ===" >> "$rag_file"
        head -n 20 "$PROJECT_ROOT/README.md" >> "$rag_file" 2>/dev/null || true
    fi
}

# Query local Ollama (fast)
query_ollama() {
    local question="$1"
    echo "$question" | ollama run "$MODEL" --nowordwrap 2>/dev/null || echo "Ollama Error"
}

# Query GROK API (smart, expensive)
query_grok() {
    local question="$1"
    local context_file="$RAG_DIR/context.txt"
    
    if [[ -z "$GROK_API_KEY" ]]; then
        echo "GROK API key not available. Use 'grok <question>' to set it up."
        return
    fi
    
    # Simplified prompt for better reliability
    local prompt="You are an expert software engineer. $question"

    local response
    response=$(curl -s --max-time 30 https://api.x.ai/v1/chat/completions \
      -H "Authorization: Bearer $GROK_API_KEY" \
      -H "Content-Type: application/json" \
      -d "{
        \"model\": \"grok-2-1212\",
        \"messages\": [
          {
            \"role\": \"user\",
            \"content\": \"$prompt\"
          }
        ],
        \"temperature\": 0.3,
        \"max_tokens\": 1000
      }")

    # Debug: show raw response if parsing fails
    local result
    result=$(echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null)
    if [[ -z "$result" || "$result" == "null" ]]; then
        echo "GROK API Error: $response" >&2
        return 1
    fi
    echo "$result"
}

# Query Claude API (fallback for complex tasks)
query_claude() {
    local question="$1"
    local CLAUDE_API_KEY="${CLAUDE_API_KEY:-${ANTHROPIC_API_KEY:-}}"

    if [[ -z "$CLAUDE_API_KEY" ]]; then
        echo "Claude API key not available."
        return 1
    fi

    local prompt="You are an expert software engineer specializing in FreeBSD, Debian, tmux, and AI systems. $question"

    local response
    response=$(curl -s --max-time 30 https://api.anthropic.com/v1/messages \
      -H "x-api-key: $CLAUDE_API_KEY" \
      -H "anthropic-version: 2023-06-01" \
      -H "content-type: application/json" \
      -d "{
        \"model\": \"claude-3-5-sonnet-20241022\",
        \"max_tokens\": 1000,
        \"temperature\": 0.3,
        \"messages\": [
          {
            \"role\": \"user\",
            \"content\": \"$prompt\"
          }
        ]
      }")

    local result
    result=$(echo "$response" | jq -r '.content[0].text' 2>/dev/null)
    if [[ -z "$result" || "$result" == "null" ]]; then
        echo "Claude API Error: $response" >&2
        return 1
    fi
    echo "$result"
}

# Smart routing - decide which AI to use
smart_query() {
    local question="$1"
    
    # Complex questions go to GROK
    if [[ "$question" =~ (improve|debug|fix|optimize|architecture|design|complex|advanced) ]] || \
       [[ "$question" =~ (self.*improve|code.*review|security|performance) ]] || \
       [[ ${#question} -gt 100 ]]; then
        
        echo "🤖 Using GROK for advanced reasoning..."
        query_grok "$question"
    else
        # Simple questions use local Ollama
        echo "🤖 Using local Ollama for fast response..."
        query_ollama "$question"
    fi
}

# Git safety check function (implemented from BAUX-BOT suggestion)
check_git_status() {
    if ! git diff --quiet; then
        echo "Error: Uncommitted changes detected. Please commit or stash changes before proceeding."
        return 1
    fi
    if ! git diff --cached --quiet; then
        echo "Error: Staged changes detected. Please commit or unstage changes before proceeding."
        return 1
    fi
    return 0
}

# Self-improvement with GROK
improve_self() {
    local suggestion="$1"

    echo "🔧 BAUX-BOT Self-Improvement Mode (using GROK)"
    echo "=============================================="

    # Clean the code context
    local code_context
    code_context=$(head -n 50 "$0" 2>/dev/null | tr '\n' ' ' | sed 's/"/\\"/g' | head -c 1000)

    local improvement_prompt="Analyze this improvement suggestion for BAUX-BOT: $suggestion. Current code context: $code_context. Provide specific code changes, new features, or architectural improvements with bash examples. Focus on Roxanne cyberdeck development."

    echo "Analyzing with GROK..."
    local analysis
    analysis=$(query_grok "$improvement_prompt")

    echo "GROK Analysis:"
    echo "$analysis"
    echo

    # Ask if user wants to apply changes
    echo "Apply any suggestions? (y/n): "
    read -r apply
    if [[ "$apply" == "y" ]]; then
        echo "Checking git safety before applying changes..."
        if ! check_git_status; then
            echo "❌ Git safety check failed - cannot apply changes"
            return 1
        fi

        echo "✅ Git safety check passed"
        echo "What specific change would you like to implement?"
        echo "(This is a foundation - manual implementation needed)"
        echo "To rollback any changes: git reset --hard HEAD~1"
    fi
}

# Main interface
main() {
    echo "🤖 BAUX-BOT Hybrid AI Assistant (Ollama + GROK)"
    echo "================================================"
    
    build_context
    echo "Context loaded. Local: $MODEL, GROK: ${GROK_API_KEY:+Available}"
    echo
    echo "Commands:"
    echo "  'rebuild' - Rebuild project context"
    echo "  'dirs' - List configured directories and access levels"
    echo "  'modify <file> <change>' - Safely modify file in build directory"
    echo "  'improve <suggestion>' - Self-improvement with GROK"
    echo "  'grok <question>' - Force GROK query"
    echo "  'ollama <question>' - Force local query"
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

        if [[ "$input" == "dirs" ]]; then
            list_directories
            continue
        fi

        if [[ "$input" =~ ^modify ]]; then
            local args
            args=$(echo "$input" | cut -d' ' -f2-)
            local target_file modification
            target_file=$(echo "$args" | awk '{print $1}')
            modification=$(echo "$args" | cut -d' ' -f2-)

            if [[ -z "$target_file" || -z "$modification" ]]; then
                echo "Usage: modify <file> <change description>"
                echo "Example: modify /tmp/test.sh add error handling"
                continue
            fi

            safe_modify_file "$target_file" "$modification"
            continue
        fi
        
        if [[ "$input" =~ ^improve ]]; then
            local suggestion
            suggestion=$(echo "$input" | cut -d' ' -f2-)
            improve_self "$suggestion"
            continue
        fi
        
        if [[ "$input" =~ ^grok ]]; then
            local question
            question=$(echo "$input" | cut -d' ' -f2-)
            echo -n "grok > "
            query_grok "$question"
            echo
            continue
        fi
        
        if [[ "$input" =~ ^ollama ]]; then
            local question
            question=$(echo "$input" | cut -d' ' -f2-)
            echo -n "ollama > "
            query_ollama "$question"
            echo
            continue
        fi
        
        # Smart routing for regular questions
        echo -n "baux-bot > "
        smart_query "$input"
        echo
    done
}

main "$@"
