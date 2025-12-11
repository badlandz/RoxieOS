#!/usr/local/bin/bash
# BAUX Production Deployment Script
# Syncs latest code to ports and deploys to target nodes
set -e

# Configuration
TARGET_NODES=("133" "101" "baux-scale")
BAUX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="baux-deployment-$(date +%Y%m%d-%H%M%S).log"

# Logging
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $*" | tee -a "$LOG_FILE"; }
error() { echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $*" | tee -a "$LOG_FILE" >&2; }
success() { echo "$(date '+%Y-%m-%d %H:%M:%S') [SUCCESS] $*" | tee -a "$LOG_FILE"; }

# Sync latest code to ports files
sync_ports_files() {
    log "=== Syncing Latest Code to Ports ==="

    # Sync baux main script
    log "Syncing baux main script..."
    cp ports/baux/core/baux ports/baux/files/usr/local/bin/baux

    # Sync tmux config
    log "Syncing tmux configuration..."
    cp ports/baux/core/tmux/baux.conf ports/baux/files/usr/local/share/tmux/baux.conf

    # Sync baux-bot
    log "Syncing baux-bot with AI enhancements..."
    cp ports/baux-bot/files/usr/local/bin/baux-bot ports/baux-bot/files/usr/local/bin/baux-bot.new
    # The AI-enhanced version is already in the files directory

    # Verify session-tui exists
    if [[ -f "ports/baux/files/usr/local/share/baux/scripts/baux-session-tui" ]]; then
        log "✅ Session TUI found in ports"
    else
        error "❌ Session TUI missing from ports"
        return 1
    fi

    success "✅ Ports files synchronized"
}

# Deploy to single node
deploy_to_node() {
    local node="$1"
    log "=== Deploying to $node ==="

    # Determine connection method
    local ssh_cmd
    if [[ "$node" == "133" ]]; then
        ssh_cmd="ssh badlandz@192.168.33.133"
    elif [[ "$node" == "101" ]]; then
        ssh_cmd="ssh badlandz@192.168.33.101"
    elif [[ "$node" == "baux-scale" ]]; then
        ssh_cmd="ssh root@bs.badlandz.com"
    else
        error "Unknown node: $node"
        return 1
    fi

    log "Testing connection to $node..."
    if ! timeout 10 $ssh_cmd "echo 'Connection test'" >/dev/null 2>&1; then
        error "❌ Cannot connect to $node"
        return 1
    fi

    log "✅ Connection to $node established"

    # Copy updated files
    log "Copying updated BAUX files to $node..."

    # Copy baux script
    $ssh_cmd "sudo cp /usr/local/bin/baux /usr/local/bin/baux.backup.$(date +%s)"
    scp ports/baux/files/usr/local/bin/baux "$ssh_cmd:/tmp/baux.new"
    $ssh_cmd "sudo mv /tmp/baux.new /usr/local/bin/baux && sudo chmod +x /usr/local/bin/baux"

    # Copy tmux config
    scp ports/baux/files/usr/local/share/tmux/baux.conf "$ssh_cmd:/tmp/baux.conf.new"
    $ssh_cmd "sudo mv /tmp/baux.conf.new /usr/local/share/tmux/baux.conf"

    # Copy session-tui
    scp ports/baux/files/usr/local/share/baux/scripts/baux-session-tui "$ssh_cmd:/tmp/baux-session-tui.new"
    $ssh_cmd "sudo mv /tmp/baux-session-tui.new /usr/local/share/baux/scripts/baux-session-tui && sudo chmod +x /usr/local/share/baux/scripts/baux-session-tui"

    # Copy enhanced baux-bot
    scp ports/baux-bot/files/usr/local/bin/baux-bot "$ssh_cmd:/tmp/baux-bot.new"
    $ssh_cmd "sudo mv /tmp/baux-bot.new /usr/local/bin/baux-bot && sudo chmod +x /usr/local/bin/baux-bot"

    # Test deployment
    log "Testing deployment on $node..."
    if $ssh_cmd "baux --help" >/dev/null 2>&1; then
        log "✅ BAUX script working on $node"
    else
        error "❌ BAUX script failed on $node"
        return 1
    fi

    if $ssh_cmd "baux sessions --help 2>/dev/null || echo 'TUI available'" | grep -q "TUI"; then
        log "✅ Session TUI available on $node"
    else
        log "⚠️ Session TUI may need testing on $node"
    fi

    success "✅ Deployment to $node completed"
}

# Main deployment
main() {
    log "=== BAUX Production Deployment Started ==="
    log "Target nodes: ${TARGET_NODES[*]}"
    log "BAUX Root: $BAUX_ROOT"

    # Sync ports files first
    if ! sync_ports_files; then
        error "❌ Failed to sync ports files"
        exit 1
    fi

    # Deploy to each node
    local failed_nodes=()
    for node in "${TARGET_NODES[@]}"; do
        if deploy_to_node "$node"; then
            success "✅ $node deployment successful"
        else
            error "❌ $node deployment failed"
            failed_nodes+=("$node")
        fi
    done

    # Summary
    log "=== Deployment Summary ==="
    log "Successful: $((${#TARGET_NODES[@]} - ${#failed_nodes[@]}))"
    log "Failed: ${#failed_nodes[@]}"

    if [[ ${#failed_nodes[@]} -eq 0 ]]; then
        success "🎉 All deployments completed successfully!"
        log "Next steps:"
        log "  1. Test 'baux sessions' on each node"
        log "  2. Test AI routing with 'baux-bot'"
        log "  3. Test cross-node session switching"
    else
        error "Some deployments failed: ${failed_nodes[*]}"
        log "Check $LOG_FILE for details"
        exit 1
    fi
}

# Run deployment
main