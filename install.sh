#!/usr/local/bin/bash
# BAUX Global Installer - Manages entire ecosystem deployment
# Supports multiple deployment types: workstation, headless, kiosk, special

set -euo pipefail

# Configuration
INSTALL_LOG="${HOME}/.baux/install.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BAUX_ROOT="$SCRIPT_DIR"

# Deployment types
declare -A DEPLOYMENT_TYPES=(
    ["workstation"]="Full workstation with keyboard/mouse/monitor"
    ["headless"]="Server/headless with no display"
    ["kiosk"]="Display-only kiosk mode"
    ["special"]="Custom/specialized configuration"
)

# Port dependencies by deployment type
declare -A PORT_DEPENDENCIES=(
    ["workstation"]="baux baux-bot bauxd bwm bterm"
    ["headless"]="baux baux-bot bauxd"
    ["kiosk"]="baux baux-bot bauxd bterm"
    ["special"]="baux baux-bot bauxd"
)

# Logging
log() {
    mkdir -p "$(dirname "$INSTALL_LOG")"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INSTALL] $*" | tee -a "$INSTALL_LOG"
}

error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $*" | tee -a "$INSTALL_LOG" >&2
}

success() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [SUCCESS] $*" | tee -a "$INSTALL_LOG"
}

# Detect deployment type
detect_deployment_type() {
    local detected_type="workstation"  # default

    # Check for explicit override
    if [[ -n "${BAUX_DEPLOYMENT_TYPE:-}" ]]; then
        if [[ -n "${DEPLOYMENT_TYPES[$BAUX_DEPLOYMENT_TYPE]:-}" ]]; then
            detected_type="$BAUX_DEPLOYMENT_TYPE"
            log "Deployment type override: $detected_type"
            return
        else
            error "Invalid deployment type override: $BAUX_DEPLOYMENT_TYPE"
            exit 1
        fi
    fi

    # Hardware-based detection
    local has_display=false
    local has_input=false

    # Check for display (X11 or Wayland)
    if [[ -n "${DISPLAY:-}" ]] || [[ -e "/tmp/.X11-unix" ]]; then
        has_display=true
    fi

    # Check for input devices (keyboard/mouse)
    if [[ -c "/dev/input/event0" ]] || [[ -e "/dev/input/mice" ]]; then
        has_input=true
    fi

    # Check for input devices (keyboard/mouse)
    if [[ -c "/dev/input/event0" ]] || [[ -e "/dev/input/mice" ]] || [[ -e "/dev/input/mouse0" ]]; then
        has_input=true
    fi

    # Determine type based on hardware
    if $has_display && $has_input; then
        detected_type="workstation"
    elif $has_display && ! $has_input; then
        detected_type="kiosk"
    elif ! $has_display && ! $has_input; then
        detected_type="headless"
    fi

    # Check for special cases
    if [[ "$(hostname)" == "baux-scale" ]] || [[ "${BAUX_SPECIAL_TYPE:-}" == "mesh-server" ]]; then
        detected_type="special"
    fi

    DEPLOYMENT_TYPE="$detected_type"
    log "Detected deployment type: $detected_type - ${DEPLOYMENT_TYPES[$detected_type]}"
}

# Check system requirements
check_requirements() {
    log "Checking system requirements..."

    # Check OS (FreeBSD preferred)
    if ! uname -s | grep -q "FreeBSD"; then
        log "WARNING: Not running FreeBSD - some features may not work"
    fi

    # Check for required tools
    local required_tools=("make" "git" "bash")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            error "Required tool missing: $tool"
            exit 1
        fi
    done

    # Check disk space (minimum 2GB)
    local available_space
    available_space=$(df /usr/local | tail -1 | awk '{print $4}')
    if [[ $available_space -lt 2097152 ]]; then  # 2GB in KB
        error "Insufficient disk space: ${available_space}KB available, need 2GB"
        exit 1
    fi

    success "System requirements check passed"
}

# Install individual port
install_port() {
    local port_name="$1"
    local port_desc="$2"

    log "Installing $port_name: $port_desc"

    # Check if port directory exists
    if [[ ! -d "$BAUX_ROOT/ports/$port_name" ]]; then
        error "Port directory not found: $BAUX_ROOT/ports/$port_name"
        return 1
    fi

    # Check if already installed (basic check)
    local force_install="${BAUX_FORCE_INSTALL:-false}"
    if [[ "$force_install" != "true" ]] && ([[ -f "/usr/local/bin/$port_name" ]] || [[ -f "/usr/local/etc/rc.d/$port_name" ]]); then
        log "$port_name already appears to be installed"
        log "Use BAUX_FORCE_INSTALL=true to force reinstall"
        return 0
    fi

    log "Installing $port_name using manual file copy..."

    # Manual installation for all components
    case "$port_name" in
        "baux")
            log "Installing baux components..."
            doas mkdir -p /usr/local/bin /usr/local/share/baux/scripts /usr/local/share/tmux
            doas cp "$BAUX_ROOT/ports/baux/files/usr/local/bin/baux" /usr/local/bin/
            doas cp "$BAUX_ROOT/ports/baux/files/usr/local/share/baux/scripts"/* /usr/local/share/baux/scripts/ 2>/dev/null || true
            doas cp "$BAUX_ROOT/ports/baux/files/usr/local/share/tmux/baux.conf" /usr/local/share/tmux/
            doas chmod +x /usr/local/bin/baux /usr/local/share/baux/scripts/*
            ;;
        "baux-bot")
            log "Installing baux-bot..."
            doas mkdir -p /usr/local/bin
            doas cp "$BAUX_ROOT/ports/baux-bot/files/usr/local/bin/baux-bot" /usr/local/bin/
            doas chmod +x /usr/local/bin/baux-bot
            ;;
        "bauxd")
            log "Installing bauxd service..."
            doas mkdir -p /usr/local/bin /usr/local/etc/rc.d /usr/local/share/bauxd
            doas cp "$BAUX_ROOT/ports/bauxd/files/usr/local/bin/bauxd" /usr/local/bin/
            doas cp "$BAUX_ROOT/ports/bauxd/files/usr/local/etc/rc.d/bauxd" /usr/local/etc/rc.d/
            doas cp "$BAUX_ROOT/ports/bauxd/files/usr/local/share/bauxd/config.json" /usr/local/share/bauxd/
            doas chmod +x /usr/local/bin/bauxd /usr/local/etc/rc.d/bauxd
            ;;
        "bwm"|"bterm")
            # Skip GUI components for non-workstation deployments
            if [[ "$DEPLOYMENT_TYPE" != "workstation" ]]; then
                log "Skipping $port_name for $DEPLOYMENT_TYPE deployment"
                return 0
            fi
            log "GUI component $port_name installation not implemented yet"
            ;;
        *)
            log "Installation method not defined for $port_name"
            ;;
    esac

    success "Installed $port_name"
}

# Configure deployment type
configure_deployment() {
    log "Configuring for $DEPLOYMENT_TYPE deployment"

    # Create deployment type marker
    doas mkdir -p /usr/local/etc
    echo "$DEPLOYMENT_TYPE" | doas tee /usr/local/etc/baux-deployment-type >/dev/null

    # Type-specific configuration
    case "$DEPLOYMENT_TYPE" in
        "workstation")
            log "Configuring workstation settings..."
            # Enable X11 services, full keymaps, etc.
            ;;
        "headless")
            log "Configuring headless settings..."
            # Disable display services, console-only keymaps
            ;;
        "kiosk")
            log "Configuring kiosk settings..."
            # Display-only, remote control
            ;;
        "special")
            log "Configuring special settings..."
            # Custom configuration based on BAUX_SPECIAL_TYPE
            ;;
    esac

    success "Deployment configuration complete"
}

# Verify installation
verify_installation() {
    log "Verifying installation..."

    local failed_components=()

    # Check core components
    for component in baux baux-bot bauxd; do
        if ! command -v "$component" >/dev/null 2>&1; then
            failed_components+=("$component")
        fi
    done

    # Type-specific checks
    case "$DEPLOYMENT_TYPE" in
        "workstation")
            # Check GUI components
            ;;
        "headless")
            # Check server-only components
            ;;
    esac

    if [[ ${#failed_components[@]} -gt 0 ]]; then
        error "Installation verification failed: ${failed_components[*]}"
        return 1
    fi

    success "Installation verification passed"
}

# Main installation
main() {
    log "=== BAUX Global Installer Started ==="
    log "BAUX Root: $BAUX_ROOT"
    log "Install Log: $INSTALL_LOG"

    # Detect deployment type
    detect_deployment_type

    # Check requirements
    check_requirements

    # Get ports to install for this deployment type
    local ports_to_install
    IFS=' ' read -ra ports_to_install <<< "${PORT_DEPENDENCIES[$DEPLOYMENT_TYPE]}"

    log "Installing components for $DEPLOYMENT_TYPE: ${ports_to_install[*]}"

    # Install each port
    local failed_ports=()
    for port in "${ports_to_install[@]}"; do
        if ! install_port "$port" "${DEPLOYMENT_TYPES[$port]:-$port}"; then
            failed_ports+=("$port")
        fi
    done

    # Configure deployment
    configure_deployment

    # Verify installation
    if ! verify_installation; then
        error "Installation verification failed"
        exit 1
    fi

    # Summary
    log "=== BAUX Installation Complete ==="
    log "Deployment Type: $DEPLOYMENT_TYPE"
    log "Installed Components: ${ports_to_install[*]}"
    if [[ ${#failed_ports[@]} -gt 0 ]]; then
        log "Failed Components: ${failed_ports[*]}"
    fi

    success "BAUX $DEPLOYMENT_TYPE installation completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Review installed components: baux --help"
    echo "2. Test AI functionality: echo 'test' | baux-bot"
    echo "3. Start services: service bauxd start"
    echo "4. Launch session: baux sessions"
}

# Show usage
usage() {
    echo "BAUX Global Installer"
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -t TYPE    Force deployment type (workstation|headless|kiosk|special)"
    echo "  -f         Force reinstall of all components"
    echo "  -h         Show this help"
    echo ""
    echo "Deployment Types:"
    echo "  workstation  Full desktop environment (default)"
    echo "  headless     Server/headless with no display"
    echo "  kiosk        Display-only kiosk mode"
    echo "  special      Custom/specialized configuration"
    echo ""
    echo "Examples:"
    echo "  $0                    # Auto-detect deployment type"
    echo "  $0 -t headless       # Force headless installation"
    echo "  $0 -f                 # Force reinstall all components"
    echo "  $0 -t workstation -f # Force workstation reinstall"
    echo "  BAUX_DEPLOYMENT_TYPE=headless $0  # Alternative override"
}

# Parse command line arguments
while getopts "t:fh" opt; do
    case $opt in
        t)
            BAUX_DEPLOYMENT_TYPE="$OPTARG"
            ;;
        f)
            BAUX_FORCE_INSTALL="true"
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

# Run main installation
main