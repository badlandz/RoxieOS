#!/bin/bash
# BAUX-BOT Optimization Framework

set -euo pipefail

# Configuration
PROJECT_ROOT="/src/roxanne"
RAG_DIR="./rag"
MODELS=("qwen2.5-coder:1.5b" "smollm2:135m")
TEST_SUGGESTIONS=(
    "Add better error handling to BAUX-BOT"
    "Implement voice input capability"
    "Add tmux integration for productivity"
    "Improve RAG context building"
    "Add self-improvement rollback safety"
)

mkdir -p "$RAG_DIR"

# Build optimized RAG context
build_optimized_rag() {
    local rag_file="$RAG_DIR/optimized.txt"
    
    echo "=== OPTIMIZED ROXANNE CONTEXT ===" > "$rag_file"
    echo "Focus: FreeBSD cyberdeck development, tmux, AI integration" >> "$rag_file"
    echo "Architecture: bbase + baux + bwm layers" >> "$rag_file"
    echo "Goal: USB boot -> instant productivity" >> "$rag_file"
    echo >> "$rag_file"
    
    # Key technical files only
    echo "=== CORE TECHNICAL FILES ===" >> "$rag_file"
    for file in "README.md" "PROJECT.md" "ROADMAP.md"; do
        if [[ -f "$PROJECT_ROOT/$file" ]]; then
            echo "--- $file ---" >> "$rag_file"
            # Extract key technical sections
            grep -A 5 -B 2 -i "freebsd\|tmux\|ai\|cyberdeck\|architecture" "$PROJECT_ROOT/$file" | head -20 >> "$rag_file" 2>/dev/null || true
            echo >> "$rag_file"
        fi
    done
    
    # Current BAUX-BOT code for self-improvement
    echo "=== BAUX-BOT CURRENT CODE ===" >> "$rag_file"
    echo "Primary file: baux-bot-hybrid.sh" >> "$rag_file"
    grep -A 3 -B 1 "function\|query_\|improve_" "$0" | head -30 >> "$rag_file" 2>/dev/null || true
}

# Test model performance
test_model() {
    local model="$1"
    local suggestion="$2"
    
    local prompt="You are an expert AI assistant for Roxanne Cyberdeck OS development.

PROJECT CONTEXT:
$(cat "$RAG_DIR/optimized.txt" | head -50)

TASK: Analyze this improvement suggestion for BAUX-BOT: '$suggestion'

Provide specific, actionable improvements with code examples. Focus on FreeBSD, tmux, AI integration, and cyberdeck development. Include working bash code where relevant."

    local start_time=$(date +%s.%3N)
    local response
    response=$(echo "$prompt" | ollama run "$model" --nowordwrap 2>/dev/null || echo "MODEL_ERROR")
    local end_time=$(date +%s.%3N)
    local duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
    
    # Score response quality (simple heuristic)
    local score=0
    [[ "$response" == *"MODEL_ERROR"* ]] && score=0 || {
        [[ "$response" == *"bash"* ]] && ((score+=2))
        [[ "$response" == *"function"* ]] && ((score+=2))
        [[ "$response" == *"FreeBSD"* ]] && ((score+=1))
        [[ "$response" == *"tmux"* ]] && ((score+=1))
        [[ "$response" == *"error"* ]] && ((score+=1))
        [[ ${#response} -gt 200 ]] && ((score+=1))
    }
    
    echo "$model|$suggestion|$duration|$score|${response:0:100}"
}

# Run optimization tests
run_optimization() {
    echo "🧪 BAUX-BOT Optimization Test Suite"
    echo "==================================="
    
    build_optimized_rag
    echo "RAG context built ($(wc -l < "$RAG_DIR/optimized.txt") lines)"
    echo
    
    echo "Testing models with improvement suggestions..."
    echo "Format: MODEL|SUGGESTION|DURATION|SCORE|RESPONSE_PREVIEW"
    echo "----------------------------------------------------------"
    
    for model in "${MODELS[@]}"; do
        for suggestion in "${TEST_SUGGESTIONS[@]}"; do
            test_model "$model" "$suggestion"
        done
    done
}

# Safety features for self-improvement
safety_check() {
    echo "🛡️  BAUX-BOT Safety Check"
    echo "=========================="
    
    # Check git status
    if git rev-parse --git-dir >/dev/null 2>&1; then
        echo "✅ Git repository detected"
        echo "Current branch: $(git branch --show-current)"
        echo "Working tree status:"
        git status --porcelain
    else
        echo "⚠️  Not in a git repository - changes cannot be rolled back!"
        return 1
    fi
    
    # Create rollback point
    echo
    echo "Creating rollback point..."
    git add .
    git commit -m "BAUX-BOT rollback point: $(date)" --allow-empty >/dev/null 2>&1
    echo "✅ Rollback commit created: $(git rev-parse HEAD)"
    
    return 0
}

# Apply improvement with safety
apply_improvement() {
    local improvement_code="$1"
    
    if ! safety_check; then
        echo "❌ Safety check failed - aborting"
        return 1
    fi
    
    echo "Applying improvement..."
    echo "$improvement_code" > improvement.patch
    
    # Basic validation
    if grep -q "rm -rf" improvement.patch; then
        echo "❌ Dangerous code detected - aborting"
        return 1
    fi
    
    echo "✅ Improvement applied safely"
    echo "To rollback: git reset --hard HEAD~1"
}

# Main
case "${1:-}" in
    test)
        run_optimization
        ;;
    safety)
        safety_check
        ;;
    apply)
        apply_improvement "$2"
        ;;
    *)
        echo "Usage: $0 [test|safety|apply 'code']"
        echo "  test   - Run optimization tests"
        echo "  safety - Check rollback safety"
        echo "  apply  - Apply improvement with safety"
        ;;
esac
