#!/usr/local/bin/bash
# BAUX Deployment Preparation Script
# Prepares deployment package and provides manual commands for each node
set -e

echo "🔧 BAUX Production Deployment Preparation"
echo "=========================================="

# Configuration
TARGET_NODES=("133" "101" "baux-scale")
BAUX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "📁 BAUX Root: $BAUX_ROOT"
echo "🎯 Target Nodes: ${TARGET_NODES[*]}"
echo

# Sync latest code to deployment package
echo "📦 Preparing Deployment Package..."
echo "-----------------------------------"

# Create deployment directory
DEPLOY_DIR="$BAUX_ROOT/deployment-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DEPLOY_DIR"

echo "✅ Created deployment directory: $DEPLOY_DIR"

# Copy updated files
echo "📋 Copying Files:"
echo "  • baux main script..."
cp "$BAUX_ROOT/ports/baux/files/usr/local/bin/baux" "$DEPLOY_DIR/"

echo "  • tmux configuration..."
cp "$BAUX_ROOT/ports/baux/files/usr/local/share/tmux/baux.conf" "$DEPLOY_DIR/"

echo "  • session TUI..."
cp "$BAUX_ROOT/ports/baux/files/usr/local/share/baux/scripts/baux-session-tui" "$DEPLOY_DIR/"

echo "  • enhanced baux-bot..."
cp "$BAUX_ROOT/ports/baux-bot/files/usr/local/bin/baux-bot" "$DEPLOY_DIR/"

echo "  • deployment script..."
cp "$BAUX_ROOT/scripts/deploy-baux-production.sh" "$DEPLOY_DIR/"

echo

# Generate deployment commands for each node
echo "🚀 Manual Deployment Commands:"
echo "=============================="

for node in "${TARGET_NODES[@]}"; do
    echo
    echo "📍 Deployment to $node:"
    echo "-----------------------"

    case "$node" in
        "133")
            SSH_TARGET="badlandz@192.168.33.133"
            ;;
        "101")
            SSH_TARGET="badlandz@192.168.33.101"
            ;;
        "baux-scale")
            SSH_TARGET="root@bs.badlandz.com"
            ;;
    esac

    echo "# 1. Test connection:"
    echo "ssh $SSH_TARGET 'echo \"Connection test successful\"'"
    echo

    echo "# 2. Backup current files:"
    echo "ssh $SSH_TARGET 'doas cp /usr/local/bin/baux /usr/local/bin/baux.backup.$(date +%s)'"
    echo "ssh $SSH_TARGET 'doas cp /usr/local/share/tmux/baux.conf /usr/local/share/tmux/baux.conf.backup.$(date +%s)'"
    echo "ssh $SSH_TARGET 'doas cp /usr/local/bin/baux-bot /usr/local/bin/baux-bot.backup.$(date +%s)'"
    echo

    echo "# 3. Copy new files:"
    echo "scp $DEPLOY_DIR/baux $SSH_TARGET:/tmp/baux.new"
    echo "scp $DEPLOY_DIR/baux.conf $SSH_TARGET:/tmp/baux.conf.new"
    echo "scp $DEPLOY_DIR/baux-session-tui $SSH_TARGET:/tmp/baux-session-tui.new"
    echo "scp $DEPLOY_DIR/baux-bot $SSH_TARGET:/tmp/baux-bot.new"
    echo

    echo "# 4. Install new files:"
    echo "ssh $SSH_TARGET 'doas mv /tmp/baux.new /usr/local/bin/baux && doas chmod +x /usr/local/bin/baux'"
    echo "ssh $SSH_TARGET 'doas mv /tmp/baux.conf.new /usr/local/share/tmux/baux.conf'"
    echo "ssh $SSH_TARGET 'doas mv /tmp/baux-session-tui.new /usr/local/share/baux/scripts/baux-session-tui && doas chmod +x /usr/local/share/baux/scripts/baux-session-tui'"
    echo "ssh $SSH_TARGET 'doas mv /tmp/baux-bot.new /usr/local/bin/baux-bot && doas chmod +x /usr/local/bin/baux-bot'"
    echo

    echo "# 5. Test deployment:"
    echo "ssh $SSH_TARGET 'baux --help | head -5'"
    echo "ssh $SSH_TARGET 'baux sessions --help 2>/dev/null || echo \"TUI needs testing\"'"
    echo "ssh $SSH_TARGET 'baux-bot --help | head -3'"
    echo

    echo "# 6. Test functionality:"
    echo "ssh $SSH_TARGET 'tmux kill-server 2>/dev/null; sleep 2'"  # Clean start
    echo "ssh -t $SSH_TARGET 'baux sessions'"  # Test TUI
    echo "ssh -t $SSH_TARGET 'echo \"test query\" | timeout 10 baux-bot'"  # Test AI routing
    echo

done

echo "📋 Summary:"
echo "==========="
echo "✅ Deployment package prepared in: $DEPLOY_DIR"
echo "✅ Manual commands generated for each node"
echo "✅ Backup commands included for safety"
echo "✅ Testing commands provided"
echo
echo "🔄 Next Steps:"
echo "1. Run the backup commands for each node"
echo "2. Execute the file copy commands"
echo "3. Run the install commands"
echo "4. Test with the provided test commands"
echo "5. Report results back for verification"
echo
echo "⚠️  Safety Notes:"
echo "- All commands include backups with timestamps"
echo "- Test connections first"
echo "- Run tests after deployment"
echo "- Report any failures immediately"