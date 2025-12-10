#!/usr/local/bin/bash
# BAUX Live ISO User Creation Script
# Creates first user via drop-baux key integration
set -e

# Configuration
REQUIRED_KEYS=("MESH_LOGIN_KEY")  # At minimum, mesh access key
DROP_BAUX_MOUNT="/mnt/drop-baux"
PERSISTENCE_CHECK="/usr/local/etc/baux/.persistence_created"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') [BAUX-USER] $*" | tee -a /var/log/baux-user-creation.log; }

# Check if we're on a live system that needs persistence
is_live_system() {
    # Check for live media indicators
    [[ -f /etc/live/config.conf ]] || [[ -d /live ]] || [[ "$0" == *"live"* ]]
}

# Create persistence on boot media
create_persistence() {
    local boot_device
    boot_device=$(mount | grep "on / " | awk '{print $1}' | sed 's/[0-9]*$//')

    if [[ -z "$boot_device" ]]; then
        log "ERROR: Cannot determine boot device for persistence"
        return 1
    fi

    local persist_partition="${boot_device}3"  # Assume partition 3 for persistence
    local persist_mount="/mnt/persistence"

    # Check if persistence partition exists
    if [[ ! -b "$persist_partition" ]]; then
        log "Creating persistence partition on $boot_device"
        # Create partition (simplified - would need proper partitioning)
        echo "WARNING: Persistence partition creation not implemented yet"
        return 1
    fi

    # Mount/create persistence
    mkdir -p "$persist_mount"
    if ! mount "$persist_partition" "$persist_mount" 2>/dev/null; then
        log "Formatting persistence partition"
        # Format and mount (simplified)
        echo "WARNING: Persistence formatting not implemented yet"
        return 1
    fi

    # Create persistence structure
    mkdir -p "$persist_mount/drop-baux"
    mkdir -p "$persist_mount/home"
    mkdir -p "$persist_mount/var/lib"

    # Mark persistence as created
    touch "$PERSISTENCE_CHECK"

    log "✅ Persistence created on $persist_partition"
}

# Detect and load dropped keys
load_dropped_keys() {
    if [[ ! -d "$DROP_BAUX_MOUNT/keys" ]]; then
        log "No drop-baux keys found at $DROP_BAUX_MOUNT/keys"
        return 1
    fi

    local key_files=("$DROP_BAUX_MOUNT/keys"/*.sh)
    if [[ ! -f "${key_files[0]}" ]]; then
        log "No key files found in drop-baux"
        return 1
    fi

    log "Found key files: ${key_files[*]}"

    # Load keys into environment
    for key_file in "${key_files[@]}"; do
        if [[ -f "$key_file" ]]; then
            log "Loading keys from $key_file"
            # shellcheck source=/dev/null
            source "$key_file"
        fi
    done

    # Verify minimum required keys
    if [[ -z "${MESH_LOGIN_KEY:-}" ]]; then
        log "ERROR: MESH_LOGIN_KEY required for user creation"
        return 1
    fi

    log "✅ Keys loaded successfully"
    return 0
}

# Create user account
create_user() {
    local username="${BAUX_USERNAME:-bauxuser}"
    local user_home="/home/$username"

    log "Creating user: $username"

    # Create user
    pw useradd -n "$username" -m -s /usr/local/bin/bash -G wheel

    # Create user directories
    mkdir -p "$user_home/src"
    mkdir -p "$user_home/mnt/drop-baux"

    # Clone RoxieOS for user
    if [[ -d "/usr/local/share/RoxieOS" ]]; then
        log "Cloning RoxieOS to user home"
        cp -r "/usr/local/share/RoxieOS" "$user_home/src/"
        chown -R "$username:$username" "$user_home/src"
    fi

    # Set up drop-baux mount
    cat >> "$user_home/.bashrc" << 'EOF'

# BAUX Drop-Baux Integration
if [[ -d /mnt/drop-baux ]]; then
    ln -sf /mnt/drop-baux ~/mnt/drop-baux 2>/dev/null || true
    if [[ -f ~/mnt/drop-baux/keys/api_keys.sh ]]; then
        source ~/mnt/drop-baux/keys/api_keys.sh
        echo "🔑 BAUX keys loaded from drop-baux"
    fi
fi
EOF

    # Set proper permissions
    chown -R "$username:$username" "$user_home"
    chmod 700 "$user_home"

    log "✅ User $username created with home at $user_home"
    echo "$username"
}

# Connect to BAUX mesh
connect_to_mesh() {
    local username="$1"

    log "Connecting $username to BAUX mesh"

    if ! command -v tailscale >/dev/null 2>&1; then
        log "Tailscale not available, skipping mesh connection"
        return 0
    fi

    # Use the mesh login key
    if [[ -n "${MESH_LOGIN_KEY:-}" ]]; then
        log "Authenticating with BAUX mesh"
        # tailscale up with auth key
        su - "$username" -c "tailscale up --auth-key='$MESH_LOGIN_KEY'" 2>/dev/null || log "Mesh connection may require manual setup"
    fi

    log "✅ Mesh connection initiated"
}

# Main user creation process
main() {
    log "=== BAUX Live ISO User Creation Started ==="

    # Check if we're on live system
    if ! is_live_system; then
        log "Not on live system, user creation not needed"
        exit 0
    fi

    # Check if persistence already exists
    if [[ -f "$PERSISTENCE_CHECK" ]]; then
        log "Persistence already created, skipping"
        exit 0
    fi

    # Create persistence if needed
    if ! create_persistence; then
        log "ERROR: Failed to create persistence"
        exit 1
    fi

    # Load dropped keys
    if ! load_dropped_keys; then
        log "ERROR: No valid keys found. Place api_keys.sh in drop-baux and retry."
        exit 1
    fi

    # Create user
    local username
    username=$(create_user)

    # Connect to mesh
    connect_to_mesh "$username"

    log "=== BAUX User Creation Complete ==="
    log "User: $username"
    log "Home: /home/$username"
    log "RoxieOS: /home/$username/src/RoxieOS"
    log ""
    log "Next steps:"
    log "1. Reboot to load new user"
    log "2. Login as $username"
    log "3. Run 'baux' to start your immortal session"
    log "4. Your AI assistants will be ready with dropped keys"
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi</content>
<parameter name="filePath">scripts/baux-user-creation.sh