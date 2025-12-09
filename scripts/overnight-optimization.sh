#!/usr/local/bin/bash
# overnight-optimization.sh — Background Ollama/RAG optimization for 4-5 hours
# Run with: nohup ./overnight-optimization.sh &

set -euo pipefail

LOG_DIR="$HOME/.baux-bot"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/overnight-$(date +%Y%m%d-%H%M%S).log"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }

log "Starting overnight optimization on $(hostname)"

# Detect system type
if [[ "$(hostname)" == *"x300"* ]]; then
    log "X300 detected - using tiny models only"
    MODELS=("smollm2:135m")
else
    log "Standard system - full model suite"
    MODELS=("smollm2:135m" "llama3.2:3b" "deepseek-coder:6.7b" "qwen2.5:7b" "gemma2:2b" "phi3:3.8b")
fi

# Phase 1: Model pulling (2-3 hours)
log "Phase 1: Pulling models..."
for model in "${MODELS[@]}"; do
    log "Pulling $model..."
    if timeout 1800 ollama pull "$model" 2>&1; then
        log "Successfully pulled $model"
    else
        log "Failed to pull $model (timeout or error)"
    fi
done

# Phase 2: Model testing (1-2 hours)
log "Phase 2: Testing models..."
for model in "${MODELS[@]}"; do
    log "Testing $model..."
    start_time=$(date +%s)
    response=$(timeout 300 ollama run "$model" "Explain BAUX-MESH in 50 words" 2>/dev/null || echo "TIMEOUT")
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    length=${#response}
    log "Model: $model | Time: ${duration}s | Response length: $length"
    if [[ $length -gt 10 ]]; then
        log "Response preview: ${response:0:100}..."
    fi
done

# Phase 3: RAG building and memory test
log "Phase 3: RAG and memory test..."
# Start baux-bot in background for RAG
export SRC_ROOT="/src/RoxieOS"  # Adjust path as needed
timeout 3600 bash -c "
    source $HOME/.baux-bot/baux-bot 2>/dev/null || true
    sleep 1800  # Let RAG build
    echo 'test query' | timeout 300 ollama run smollm2:135m 2>/dev/null || true
" 2>&1 | tee -a "$LOG_FILE"

log "Optimization complete. Check $LOG_FILE for results."
log "Total runtime: ~$(($(date +%s) - $(date -d "$(head -1 "$LOG_FILE" | cut -d' ' -f1-2)" +%s))) seconds"