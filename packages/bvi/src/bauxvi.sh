#!/bin/sh
# BAUXVI Prototype Wrapper - v0.1
# Launches the best available editor with BAUXVI configs.
# Detection order: Neovim (nightly/stable) > Vim (Debian standard) > Vi (tiny fallback).
# Usage: bauxvi [options] [files]  (e.g., bauxvi file.txt)

# 1. Source BAUX environment (PostgreSQL, SeaweedFS readiness)
# This preps for immortality hooks (e.g., undodir in SFS) without failing if absent.
. /etc/baux/profile 2>/dev/null || true

# Optional: Basic logging for debugging (comment out for production)
echo "$(date '+%Y-%m-%d %H:%M:%S') - BAUXVI launched with args: $@" >>/tmp/bauxvi.log

# 2. Detect and launch the editor
if command -v nvim >/dev/null 2>&1; then
  # Neovim detected: Use for full NvChad madness mode.
  # Loads init.vim (Lua entrypoint for plugins like persistence.nvim, fzf.vim).
  exec nvim -u /etc/bauxvi/init.vim "$@"
elif command -v vim >/dev/null 2>&1; then
  # Standard Vim: v0.1 base for 70-80% features (undo, sessions, tmux sync).
  # Loads vimrc.tiny (Vimscript-only: obsession, undotree, navigator, etc.).
  exec vim -u /etc/bauxvi/vimrc.tiny "$@"
else
  # Fallback to vi (tiny): Minimal mode, native features only.
  # Still loads vimrc.tiny (with guards for missing +features).
  exec vi -u /etc/bauxvi/vimrc.tiny "$@"
fi

# Fallback error (should never reach here)
echo "Error: No compatible editor found (nvim, vim, or vi required)." >&2
exit 1
