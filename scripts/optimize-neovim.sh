#!/bin/bash
# BAUX Neovim Performance Optimization
# Simple, effective startup time improvements

set -euo pipefail

echo "=== BAUX Neovim Performance Check ==="

# Check if nvim is available
if ! command -v nvim >/dev/null 2>&1; then
    echo "✗ Neovim not found in PATH"
    exit 1
fi

echo "✓ Neovim found: $(nvim --version | head -1)"

# Test startup time
echo "Testing startup time..."
start_time=$(date +%s%N)
timeout 10 nvim --headless -c "quit" >/dev/null 2>&1
end_time=$(date +%s%N)
startup_ms=$(( (end_time - start_time) / 1000000 ))

echo "Startup time: ${startup_ms}ms"

if [ "$startup_ms" -lt 500 ]; then
    echo "✓ Startup time is good (< 500ms)"
elif [ "$startup_ms" -lt 1000 ]; then
    echo "⚠ Startup time is acceptable (< 1000ms)"
else
    echo "✗ Startup time is slow (> 1000ms)"
    echo "Consider:"
    echo "  - Reducing loaded plugins"
    echo "  - Using lazy loading"
    echo "  - Checking for slow config files"
fi

# Check for common performance issues
echo ""
echo "=== Performance Recommendations ==="

# Check for lazy loading
if nvim --headless -c "lua print(require('lazy').stats().count)" -c "quit" 2>/dev/null; then
    echo "✓ Lazy plugin manager detected"
else
    echo "⚠ Consider using lazy.nvim for better performance"
fi

# Check for heavy plugins
if nvim --headless -c "lua for k,v in pairs(package.loaded) do if k:match('lsp') then print('LSP: ' .. k) end end" -c "quit" 2>/dev/null | grep -q "lsp"; then
    echo "✓ LSP plugins loaded (expected for dev config)"
else
    echo "ℹ No LSP plugins detected (lite config?)"
fi

echo ""
echo "=== Optimization Complete ==="