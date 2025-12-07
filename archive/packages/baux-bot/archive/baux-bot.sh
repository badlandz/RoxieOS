#!/usr/bin/env bash
# baux-bot.sh v4.5 — final, idiot-proof, works from /usr/local/bin
# Nov 20 2025

set -u
set -o pipefail

# ── Find the repo no matter where the script lives ─────────────────────
find_baux_root() {
  local dir="$(dirname "$(realpath "$0")")"
  #   while [[ "$dir" != "/" ]]; do
  #     if [[ -d "$dir/packages/baux" ]]; then
  #       echo "$dir/packages/baux"
  #       return
  #     fi
  #     dir="$(dirname "$dir")"
  #   done
  # Fallback for RoxieOS builder
  if [[ -d "/home/coyote/roxieos/" ]]; then
    echo "/home/coyote/roxieos/"
    return
  fi
  echo "ERROR: Cannot find baux repo" >&2
  exit 1
}

BAUX_ROOT="$(find_baux_root)"
LOG_DIR="$BAUX_ROOT/bot/chatlogs"
RAG_DIR="$BAUX_ROOT/bot/rag"

# ── ALWAYS create dirs (this was the missing line) ─────────────────────
mkdir -p "$LOG_DIR" "$RAG_DIR"

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG_DIR/current.log"; }

# Model selection + auto-pull
MODEL_PREF=(deepseek-coder:33b qwen2.5:7b llama3.2:3b gemma2:2b phi3:3.8b smollm2:135m)
select_and_pull_model() {
  for m in "${MODEL_PREF[@]}"; do
    if ollama list | grep -q "^${m%%:*}"; then
      echo "$m"
      return
    fi
  done
  log "No preferred model — pulling smollm2:135m"
  ollama pull smollm2:135m
  echo "smollm2:135m"
}

MODEL=$(select_and_pull_model)
log "BAUX BOT v4.5 online — using $MODEL"

build_smart_rag() {
  local rag_file="$RAG_DIR/current.txt"
  >"$rag_file" # this now always works because dirs exist

  if git -C "$BAUX_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "=== BAUX GIT STATUS ===" >>"$rag_file"
    git -C "$BAUX_ROOT" status -sb >>"$rag_file"
    echo -e "\n=== LAST 10 COMMITS ===" >>"$rag_file"
    git -C "$BAUX_ROOT" log --oneline -10 >>"$rag_file"
  fi

  echo -e "\n=== CORE FILES (latest first) ===" >>"$rag_file"
  find "$BAUX_ROOT" -type f \( -name "*.sh" -o -name "*.conf" -o -name "*.lua" -o -name "*.md" -o -name "README*" \) \
    -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -25 | cut -d' ' -f2- |
    while read -r f; do
      echo -e "\n--- $f ---" >>"$rag_file"
      tail -200 "$f" 2>/dev/null >>"$rag_file"
    done
}

ask_ollama() {
  local prompt="$1"
  local rag_file="$RAG_DIR/current.txt"

  printf "BAUX BOT thinking... "
  {
    cat <<EOF
You are BAUX BOT — elite, sarcastic assistant for the BAUX/RoxieOS project.
Current repo state:

$(cat "$rag_file")

User: $prompt

Answer directly. Use markdown if helpful.
EOF
  } | ollama run "$MODEL" --nowordwrap 2>/dev/null || echo "(model hiccup — retrying...)"
  echo
}

# Startup
build_smart_rag
log "RAG ready (~$(wc -l <"$RAG_DIR/current.txt") lines)"
echo -e "\nBAUX BOT ready (model: $MODEL). Type message — only the word 'exit' quits.\n"

while true; do
  if ! git -C "$BAUX_ROOT" diff --quiet HEAD 2>/dev/null; then
    log "Repo changed — rebuilding RAG"
    build_smart_rag
    summary=$(ask_ollama "Summarize what just changed.")
    echo -e "\nBAUX BOT (auto): $summary\n"
  fi

  printf "you > "
  read -r input || {
    echo
    break
  }
  [[ -z "$input" ]] && continue
  [[ "$input" == "exit" ]] && {
    echo "BAUX BOT offline — see you space cowboy 🤠"
    exit 0
  }

  response=$(ask_ollama "$input")
  echo -e "BAUX BOT: $response\n"
done
