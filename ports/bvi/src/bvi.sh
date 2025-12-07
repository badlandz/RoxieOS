#!/usr/local/bin/bash
# BVI Wrapper - v0.1: Isolated, fallback-safe launch

. /etc/baux/profile 2>/dev/null || true # BAUX env stubs
export NVIM_APPNAME=bvi                 # Isolate Neovim paths

NVIM_BIN=$(command -v nvim)
VIM_BIN=$(command -v vim)
VI_BIN=$(command -v vi)

if [ -n "$NVIM_BIN" ]; then
  exec "$NVIM_BIN" -u /usr/local/etc/bvi/init.vim "$@"
elif [ -n "$VIM_BIN" ]; then
  exec "$VIM_BIN" -u /usr/local/etc/bvi/vimrc.tiny "$@"
else
  exec "$VI_BIN" -u /usr/local/etc/bvi/vimrc.tiny "$@"
fi
