#!/usr/local/bin/bash
# BAUX .bashrc Installation Script
# Safely installs optimized .bashrc while preserving existing keys

set -e

echo "🔧 BAUX .bashrc Installation"
echo "============================"

# Check if we have a backup
if [[ ! -f ~/.bashrc.backup.* ]]; then
    echo "❌ No backup found! Please run backup first:"
    echo "cp ~/.bashrc ~/.bashrc.backup.\$(date +%Y%m%d-%H%M%S)"
    exit 1
fi

echo "✅ Backup found: $(ls ~/.bashrc.backup.* | tail -1)"

# Extract existing key exports from current .bashrc
echo "🔑 Extracting existing API keys..."
EXISTING_KEYS=""
if [[ -f ~/.bashrc ]]; then
    # Extract export statements for API keys
    EXISTING_KEYS=$(grep -E "export (GROK|GEMINI|CLAUDE|REPLICATE|TOGETHER|MESH)_.*=" ~/.bashrc 2>/dev/null || true)
fi

if [[ -n "$EXISTING_KEYS" ]]; then
    echo "Found existing keys:"
    echo "$EXISTING_KEYS" | sed 's/export /  /g'
else
    echo "No existing API keys found in .bashrc"
fi

# Install the optimized .bashrc
echo "📝 Installing optimized BAUX .bashrc..."
cp /src/RoxieOS/scripts/baux-bashrc.sh ~/.bashrc.new

# Append existing keys to the new .bashrc
if [[ -n "$EXISTING_KEYS" ]]; then
    echo "" >> ~/.bashrc.new
    echo "# ──────────────────────────────────────────────────────────────" >> ~/.bashrc.new
    echo "# PRESERVED EXISTING API KEYS" >> ~/.bashrc.new
    echo "# ──────────────────────────────────────────────────────────────" >> ~/.bashrc.new
    echo "$EXISTING_KEYS" >> ~/.bashrc.new
    echo "" >> ~/.bashrc.new
    echo "# Override BAUX_KEYS_LOADED since we have preserved keys" >> ~/.bashrc.new
    echo "export BAUX_KEYS_LOADED=1" >> ~/.bashrc.new
fi

# Backup current and install new
mv ~/.bashrc ~/.bashrc.old
mv ~/.bashrc.new ~/.bashrc

echo "✅ Installed optimized BAUX .bashrc"
echo ""
echo "🔄 Key Integration Status:"
if [[ -n "$EXISTING_KEYS" ]]; then
    echo "✅ Existing API keys preserved and integrated"
else
    echo "ℹ️  No existing keys found - use drop-baux for key management"
fi

echo ""
echo "🧪 Test the new setup:"
echo "  source ~/.bashrc"
echo "  echo \$PS1  # Should show: user@hostname \$"
echo "  set -o      # Should show: vi on"
echo "  baux-keys   # Should show: Keys loaded: 1"
echo ""
echo "🔙 Rollback if needed:"
echo "  mv ~/.bashrc.old ~/.bashrc"
echo ""
echo "🎉 BAUX .bashrc optimization complete!"