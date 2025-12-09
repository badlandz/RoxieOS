# BAUX Session Management
**Understanding Immortal Sessions & Resurrection**

This session management supports the core vision of persistent Neovim IDE access across reboots and devices.

## Core Concepts

### Session Immortality
**Problem:** Traditional terminal sessions die with hardware failures, network issues, or accidental closures.

**BAUX Solution:** Sessions become persistent network resources that survive all interruptions and can be resurrected on any enrolled device.

### Session States
- **Active:** Running on specific device with real-time updates
- **Suspended:** Paused state, resumable on any device
- **Detached:** Running in background, attachable from anywhere
- **Archived:** Historical snapshots for recovery
- **Roaming:** Discovered via LAN probing or phone home to baux-scale

## tmux Integration

### Immortal Panes
BAUX extends tmux's session management with automatic resurrection:

```bash
# Traditional tmux: Session dies with terminal
tmux new-session -s work
# → Close terminal = session lost

# BAUX tmux: Session persists across devices
baux session start work
# → Session survives terminal, network, hardware changes
```

### Pane Resurrection
**Automatic Recovery:** Dead panes automatically restart their commands
**Exit Code Handling:** Smart respawning based on exit conditions
**State Preservation:** Command history and working directory maintained

### Session Hierarchy
```
BAUX Session (Network Resource)
├── tmux Session (Container)
│   ├── Window 1: Editor (bvi)
│   ├── Window 2: Shell (bash)
│   └── Window 3: Monitoring (htop)
└── Metadata (Device affinity, ACLs, timestamps)
```

## Session Persistence Layers

### Layer 1: Local Persistence
**Mechanism:** tmux built-in session saving
**Scope:** Single device, survives reboots
**Implementation:** `tmux-resurrect` style saving

### Layer 2: Network Persistence
**Mechanism:** Distributed storage via BAUX mesh
**Scope:** All enrolled devices
**Implementation:** Session state sync across Headscale network

### Layer 3: Cloud Persistence
**Mechanism:** BAUX server storage with redundancy
**Scope:** Survives device loss/theft
**Implementation:** Encrypted backups with versioning

## Session Lifecycle

### Creation
```bash
# Create new session
baux session create dev --template development

# Session becomes network resource
# Available on all enrolled devices
```

### Migration
```bash
# Move running session to another device
baux session migrate dev --to laptop

# Session transfers with zero interruption
# All panes, history, and state preserved
```

### Resurrection
```bash
# On any device
baux session list
# Shows: dev (active on workstation), work (suspended)

baux session attach dev
# Session resurrects exactly as left
```

### Roaming Session Discovery
**LAN Probing:** RoxieOS boot scans local network (port 9999) for active sessions; offers immediate login/clone.
**Phone Home:** Connect to baux-scale server for global session list; select from mesh-wide options.
**TUI Selection:** Unified interface for choosing sessions from LAN or cloud sources.

### Archival
```bash
# Create recoverable snapshot
baux session archive dev --label "pre-deployment"

# Restore from any point
baux session restore dev --from "pre-deployment"
```

## Anti-Nesting Protection

### The Nesting Problem
**Issue:** SSH into remote machine → start tmux → SSH again → nested sessions become confusing

**BAUX Solution:** Intelligent session detection and routing

### Detection Logic
```bash
# Check if already in BAUX session
if [ -n "$BAUX_SESSION_ID" ]; then
    # Route to existing session instead of nesting
    baux session switch $BAUX_SESSION_ID
    exit
fi
```

### Smart Routing
- **Local Session:** Use existing local tmux
- **Remote Session:** Attach to remote BAUX session
- **Hybrid Session:** Mix local and remote panes

## Session Templates

### Predefined Layouts
```bash
# Development template
baux session create dev --template dev
# Creates: editor + shell + monitoring panes

# Embedded template
baux session create hw --template embedded
# Creates: serial monitor + code editor + testing panes
```

### Custom Templates
```json
{
  "name": "development",
  "windows": [
    {
      "name": "editor",
      "panes": [
        {"command": "bvi", "directory": "~/projects"}
      ]
    },
    {
      "name": "shell",
      "panes": [
        {"command": "bash", "directory": "~/projects"}
      ]
    }
  ]
}
```

## Cross-Device Synchronization

### Real-time Sync
**Active Sessions:** Changes propagate instantly across devices
**Conflict Resolution:** Timestamp-based merging
**Bandwidth Optimization:** Delta compression for efficiency

### Offline Support
**Local Cache:** Sessions work offline with local changes
**Sync on Connect:** Automatic reconciliation when network returns
**Conflict Resolution:** User-guided merge decisions

## Security Model

### Session Encryption
- **At Rest:** AES-256 encryption for stored sessions
- **In Transit:** WireGuard encryption via Headscale
- **Key Management:** Automatic rotation and secure distribution

### Access Control
- **Device ACLs:** Which devices can access which sessions
- **User Permissions:** Read-only vs. read-write access
- **Session Sharing:** Temporary access grants

## Performance Optimization

### Resource Management
- **Memory Limits:** Prevent session bloat
- **CPU Throttling:** Background session prioritization
- **Storage Quotas:** Per-session size limits

### Network Efficiency
- **Connection Pooling:** Reuse established tunnels
- **Compression:** Reduce sync traffic
- **Caching:** Local state for instant access

## Troubleshooting

### Common Issues
- **Session Not Syncing:** Check Headscale connectivity
- **Pane Not Respawning:** Verify exit codes and respawn rules
- **Migration Failing:** Check device enrollment and permissions

### Diagnostic Commands
```bash
# Check session status
baux session status

# View sync logs
baux session logs

# Force sync
baux session sync --force

# Debug connectivity
baux mesh ping
```

## Implementation Details

### tmux Configuration
```bash
# BAUX-enhanced tmux.conf
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# BAUX integration
set-environment -g BAUX_SESSION_ID "#{session_id}"
set -g status-right "BAUX: #{session_name}"
```

### Session Storage Format
```json
{
  "session_id": "dev-001",
  "created": "2025-01-01T00:00:00Z",
  "last_active": "2025-01-07T15:30:00Z",
  "devices": ["laptop", "workstation"],
  "windows": [
    {
      "name": "editor",
      "panes": [
        {
          "command": "bvi main.c",
          "directory": "/home/user/projects",
          "history": ["..."],
          "scrollback": 1000
        }
      ]
    }
  ]
}
```

## Future Enhancements

### Advanced Features
- **Session Recording:** Historical playback
- **Collaborative Sessions:** Multi-user editing
- **AI Integration:** Intelligent session suggestions
- **Resource Pooling:** Distribute across devices

### Ecosystem Integration
- **IDE Integration:** VS Code remote session support
- **Mobile Access:** iOS/Android session viewers
- **Web Interface:** Browser-based session management

## Conclusion

BAUX session management transforms terminal sessions from ephemeral processes into persistent, distributed resources. By leveraging tmux's pane management with Headscale's mesh networking, BAUX creates an environment where your digital workspace truly follows you everywhere.

**Key Innovation:** Sessions become network resources, not hardware-dependent processes.

**References:**
- [tmux Documentation](https://github.com/tmux/tmux/wiki)
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- [Headscale Networking](https://headscale.net/)