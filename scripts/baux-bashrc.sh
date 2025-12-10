# BAUX .bashrc - Optimized Shell Environment
# Simple, fast, workflow-focused configuration

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ──────────────────────────────────────────────────────────────
# 1. BASIC SHELL CONFIGURATION
# ──────────────────────────────────────────────────────────────

# Vi mode for efficient editing (matches neovim workflow)
set -o vi

# History configuration
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend  # Append to history file, don't overwrite

# Check window size after each command
shopt -s checkwinsize

# Enable globstar for recursive globbing
shopt -s globstar

# ──────────────────────────────────────────────────────────────
# 2. BAUX PROMPT - Simple hostname indicator
# ──────────────────────────────────────────────────────────────

# Simple prompt: user@hostname $
# tmux shows session/time info, so keep prompt minimal
PS1='\u@\h \$ '

# ──────────────────────────────────────────────────────────────
# 3. DROP-BAUX KEY INTEGRATION
# ──────────────────────────────────────────────────────────────

# Load keys from drop-baux if available
if [[ -d ~/mnt/drop-baux ]]; then
    # Load API keys
    if [[ -f ~/mnt/drop-baux/keys/api_keys.sh ]]; then
        source ~/mnt/drop-baux/keys/api_keys.sh
        export BAUX_KEYS_LOADED=1
    fi

    # Load session keys
    if [[ -f ~/mnt/drop-baux/keys/session_keys.sh ]]; then
        source ~/mnt/drop-baux/keys/session_keys.sh
    fi
fi

# ──────────────────────────────────────────────────────────────
# 4. BAUX ENVIRONMENT VARIABLES
# ──────────────────────────────────────────────────────────────

# BAUX-specific environment
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# BAUX paths
export BAUX_HOME="${BAUX_HOME:-/usr/local/share/baux}"
export RAG_DIR="${RAG_DIR:-~/mnt/drop-baux/rag}"

# Ollama configuration (CPU only for compatibility)
export OLLAMA_GPU_LAYERS=0

# ──────────────────────────────────────────────────────────────
# 5. BAUX ALIASES & SHORTCUTS
# ──────────────────────────────────────────────────────────────

# Session management
alias bs='baux sessions'        # Session TUI
alias bswitch='baux switch'     # Switch sessions
alias bpull='baux pull'         # Pull remote session
alias bpush='baux push'         # Push current session

# AI assistants
alias bb='baux-bot'             # Main AI bot
alias bgrok='baux-bot switch grok'
alias bgemini='baux-bot switch gemini'
alias bollama='baux-bot switch ollama'

# Development shortcuts
alias v='nvim'
alias vim='nvim'
alias vi='nvim'

# BAUX utilities
alias baux-status='baux-bot status'
alias baux-keys='echo "Keys loaded: $BAUX_KEYS_LOADED"'
alias drop-status='ls -la ~/mnt/drop-baux/keys/ 2>/dev/null || echo "No drop-baux found"'

# ──────────────────────────────────────────────────────────────
# 6. COMPLETION SYSTEM
# ──────────────────────────────────────────────────────────────

# Enable bash completion if available
if [[ -f /usr/local/share/bash-completion/bash_completion.sh ]]; then
    source /usr/local/share/bash-completion/bash_completion.sh
elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
fi

# BAUX-specific completions
_baux_complete() {
    local cur prev words cword
    _init_completion || return

    local commands="sessions switch pull push bot drop hosts vpn"

    case $prev in
        switch|pull)
            # Complete with available sessions (simplified)
            COMPREPLY=( $(compgen -W "baux-$(hostname) $(tmux list-sessions 2>/dev/null | awk -F: '{print $1}')" -- "$cur") )
            return
            ;;
        bot)
            COMPREPLY=( $(compgen -W "status" -- "$cur") )
            return
            ;;
    esac

    COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
}

complete -F _baux_complete baux

# ──────────────────────────────────────────────────────────────
# 7. BAUX WORKFLOW OPTIMIZATIONS
# ──────────────────────────────────────────────────────────────

# Auto-cd to src directory if it exists
if [[ -d ~/src ]]; then
    cd ~/src 2>/dev/null || true
fi

# BAUX startup message
if [[ -n "$BAUX_KEYS_LOADED" ]]; then
    echo "🔑 BAUX environment ready - $(tmux list-sessions 2>/dev/null | wc -l) sessions available"
fi

# ──────────────────────────────────────────────────────────────
# 8. DEVELOPMENT ENVIRONMENT
# ──────────────────────────────────────────────────────────────

# Git configuration (if not set globally)
if [[ -z "$(git config --global user.name 2>/dev/null)" ]]; then
    git config --global user.name "BAUX User"
    git config --global user.email "baux@localhost"
fi

# Python virtual environment support
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Node.js version manager (if available)
if [[ -d ~/.nvm ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# ──────────────────────────────────────────────────────────────
# 9. SECURITY & CLEANUP
# ──────────────────────────────────────────────────────────────

# Clear sensitive environment variables on exit
trap 'unset GROK_API_KEY GEMINI_API_KEY CLAUDE_API_KEY REPLICATE_API_TOKEN TOGETHER_API_KEY MESH_LOGIN_KEY 2>/dev/null' EXIT

# ──────────────────────────────────────────────────────────────
# END BAUX .bashrc
# ──────────────────────────────────────────────────────────────</content>
<parameter name="filePath">scripts/baux-bashrc.sh