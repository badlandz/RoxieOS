# BAUX Deployment Types & Configuration

## Overview

BAUX supports multiple deployment types optimized for different hardware configurations and use cases. The deployment type is automatically detected and configured during installation.

## Deployment Types

### 1. WORKSTATION (Default)
**Hardware**: Keyboard + Mouse + Monitor/Display
**Use Case**: Primary development workstations, laptops
**Components**: Full BAUX stack + X11 + window manager + terminal

**Detection**:
```bash
# Has keyboard/mouse/monitor
if [[ -n "$DISPLAY" && -c "/dev/input/event0" ]]; then
    DEPLOYMENT_TYPE="workstation"
fi
```

**Installed Components**:
- ✅ baux (session management)
- ✅ baux-bot (AI assistant)
- ✅ bauxd (mesh coordination)
- ✅ bwm (window manager)
- ✅ bterm (terminal emulator)
- ✅ X11 integration
- ✅ Full keymap support

### 1.5. LITE (Console-Only Workstation)
**Hardware**: Keyboard + No Monitor/Display
**Use Case**: Console-focused development, remote servers, lightweight workstations
**Components**: Full BAUX functionality without X11 overhead

**Detection**:
```bash
# Has keyboard but no display capability
if [[ -c "/dev/input/event*" && -z "$DISPLAY" ]]; then
    DEPLOYMENT_TYPE="lite"
fi
```

**Installed Components**:
- ✅ baux (session management)
- ✅ baux-bot (AI assistant)
- ✅ bauxd (mesh coordination)
- ✅ bterm (console-only mode)
- ✅ Console keymaps and navigation
- ❌ bwm (no window manager needed)
- ❌ X11 integration (console only)
- ✅ Full tmux/neovim integration

### 2. HEADLESS
**Hardware**: No keyboard/mouse/monitor (server)
**Use Case**: Cloud servers, remote build machines
**Components**: Core BAUX without display components

**Detection**:
```bash
# No display, no input devices
if [[ -z "$DISPLAY" && ! -c "/dev/input/event*" ]]; then
    DEPLOYMENT_TYPE="headless"
fi
```

**Installed Components**:
- ✅ baux (session management)
- ✅ baux-bot (AI assistant)
- ✅ bauxd (mesh coordination)
- ❌ bwm (no window manager needed)
- ❌ bterm X11 features (console only)
- ✅ Console keymaps
- ✅ SSH/remote access only

### 3. KIOSK
**Hardware**: Monitor/Display + No keyboard/mouse
**Use Case**: Remote session displays, media playback, dashboards
**Components**: Display-only with remote control

**Detection**:
```bash
# Has display, no input devices
if [[ -n "$DISPLAY" && ! -c "/dev/input/event*" ]]; then
    DEPLOYMENT_TYPE="kiosk"
fi
```

**Installed Components**:
- ✅ baux (session display)
- ✅ baux-bot (limited, for remote queries)
- ✅ bauxd (mesh coordination)
- ❌ bwm (external window management)
- ✅ bterm (display-only mode)
- ✅ Remote control protocols
- ✅ Auto-login for display

### 4. SPECIAL
**Hardware**: Varies by use case
**Use Case**: Custom configurations (baux-scale, development servers)
**Components**: Base BAUX + custom additions

**Detection**:
```bash
# Environment variables or hostname-based
if [[ "${BAUX_SPECIAL_TYPE:-}" == "mesh-server" ]] || [[ "$(hostname)" == "baux-scale" ]]; then
    DEPLOYMENT_TYPE="special"
    SPECIAL_TYPE="mesh-server"
fi
```

**Installed Components**:
- ✅ Base BAUX components
- ✅ Custom additions based on SPECIAL_TYPE
- ✅ Extended capabilities (headscale, monitoring, etc.)

## Implementation

### Detection Logic
```bash
detect_deployment_type() {
    # Check for explicit override
    if [[ -n "${BAUX_DEPLOYMENT_TYPE:-}" ]]; then
        DEPLOYMENT_TYPE="$BAUX_DEPLOYMENT_TYPE"
        return
    fi

    # Hardware-based detection
    local has_display=false
    local has_input=false

    # Check for display
    if [[ -n "$DISPLAY" ]] || [[ -e "/tmp/.X11-unix" ]]; then
        has_display=true
    fi

    # Check for input devices
    if [[ -c "/dev/input/event0" ]] || [[ -e "/dev/input/mice" ]]; then
        has_input=true
    fi

    # Determine type
    if $has_display && $has_input; then
        DEPLOYMENT_TYPE="workstation"
    elif $has_display && ! $has_input; then
        DEPLOYMENT_TYPE="kiosk"
    elif ! $has_display && ! $has_input; then
        DEPLOYMENT_TYPE="headless"
    else
        DEPLOYMENT_TYPE="workstation"  # fallback
    fi

    # Check for special cases
    if [[ "$(hostname)" == "baux-scale" ]] || [[ "${BAUX_SPECIAL_TYPE:-}" ]]; then
        DEPLOYMENT_TYPE="special"
    fi

    echo "Detected deployment type: $DEPLOYMENT_TYPE"
}
```

### Configuration by Type
```bash
configure_by_type() {
    case "$DEPLOYMENT_TYPE" in
        "workstation")
            # Full desktop environment
            install_x11_components
            install_window_manager
            install_full_keymaps
            ;;
        "headless")
            # Server-only components
            install_console_only
            disable_x11_services
            ;;
        "kiosk")
            # Display-only with remote control
            install_display_only
            configure_auto_login
            ;;
        "special")
            # Custom configuration
            configure_special_type
            ;;
    esac
}
```

### Component Installation Matrix

| Component | Workstation | Lite | Headless | Kiosk | Special |
|-----------|-------------|------|----------|-------|---------|
| baux | ✅ | ✅ | ✅ | ✅ | ✅ |
| baux-bot | ✅ | ✅ | ✅ | ⚠️ (limited) | ✅ |
| bauxd | ✅ | ✅ | ✅ | ✅ | ✅ |
| bwm | ✅ | ❌ | ❌ | ❌ | ⚠️ |
| bterm | ✅ (full) | ✅ (console) | ⚠️ (console) | ✅ (display) | ✅ |
| X11 | ✅ | ❌ | ❌ | ⚠️ (minimal) | ⚠️ |
| Keymaps | ✅ (full) | ✅ (console) | ⚠️ (console) | ⚠️ (remote) | ✅ |

## Usage

### Automatic Detection
```bash
# Install script auto-detects
~/src/RoxieOS/install.sh  # Detects and configures automatically
```

### Manual Override
```bash
# Force specific type
BAUX_DEPLOYMENT_TYPE=headless ~/src/RoxieOS/install.sh

# Or set in environment
export BAUX_DEPLOYMENT_TYPE=kiosk
~/src/RoxieOS/install.sh
```

### Runtime Checking
```bash
# Check current deployment type
baux deployment-type

# Component availability
baux components  # Shows what's installed based on type
```

## Benefits

### Hardware Optimization
- **Workstation**: Full GUI environment for development
- **Lite**: Console-only workstation with full BAUX functionality
- **Headless**: Minimal resource usage for servers
- **Kiosk**: Display-focused for remote sessions
- **Special**: Custom configurations for unique needs

### Maintenance Efficiency
- **Automatic detection**: No manual configuration needed
- **Type-aware updates**: Only update relevant components
- **Resource optimization**: Don't install unnecessary services
- **Deployment consistency**: Same install script, different results

### Future-Proofing
- **Extensible types**: Easy to add new deployment scenarios
- **Component matrix**: Clear what gets installed where
- **Configuration flags**: Runtime adaptation capabilities
- **Upgrade paths**: Type-aware migration between configurations

## Current Status

### Implemented
- ✅ Detection logic framework
- ✅ Type definitions and matrices
- ✅ Configuration by type structure
- ✅ Workstation deployment (current focus)

### Planned
- 🔄 Headless deployment testing
- 🔄 Kiosk deployment framework
- 🔄 Special type configurations
- 🔄 Runtime type checking commands

## Migration Strategy

### Phase 1: Detection Framework
- Add detection logic to install scripts
- Implement type-based configuration
- Test workstation deployment (current)

### Phase 2: Type-Specific Deployments
- Implement headless server configuration
- Add kiosk display-only mode
- Configure special types (baux-scale)

### Phase 3: Runtime Management
- Add type checking commands
- Implement type-aware updates
- Create migration tools between types

This deployment type system ensures BAUX can be optimally configured for any hardware scenario while maintaining consistent behavior and management across all installations.</content>
<parameter name="filePath">docs/BAUX-DEPLOYMENT-TYPES.md