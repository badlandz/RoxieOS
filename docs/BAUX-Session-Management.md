# BAUX Session Management
**Understanding Immortal Sessions & Resurrection**

This session management supports the core vision of persistent Neovim IDE access across reboots and devices.

## Core Concepts

### Session Immortality ✅ WORKING
**Problem:** Traditional terminal sessions die with hardware failures, network issues, or accidental closures.

**BAUX Solution:** Sessions become persistent network resources that survive all interruptions and can be resurrected on any enrolled device.

**Current Status:** Baux-bot runs immortal in persistent tmux session with loaded RAG. Sessions survive reboots via tmux resurrect integration.

### Session States (Current Implementation)
- **Active:** Running on specific device with real-time updates ✅ (baux-bot session)
- **Suspended:** Paused state, resumable on any device (planned)
- **Detached:** Running in background, attachable from anywhere ✅ (tmux detach/attach)
- **Archived:** Historical snapshots for recovery (planned)
- **Roaming:** Discovered via LAN probing or phone home to baux-scale (SSH-based currently)

## tmux Integration

### Immortal Panes ✅ WORKING
BAUX extends tmux's session management with automatic resurrection:

```bash
# Traditional tmux: Session dies with terminal
tmux new-session -s work
# → Close terminal = session lost

# BAUX tmux: Session persists across devices
baux  # Starts persistent tmux session
# → Session survives terminal, network, hardware changes

# Current working example: baux-bot session
tmux new-session -d -s baux-bot-session 'baux-bot --load-rag'
# → Immortal AI assistant with persistent RAG
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

### Roaming Session Discovery (Current: SSH-Based)
**LAN Probing:** Planned - RoxieOS boot scans local network (port 9999) for active sessions.
**Phone Home:** Current - Use SSH to access mesh nodes: `ssh user@192.168.33.133`
**TUI Selection:** Planned unified interface for session selection.

**Working Examples:**
```bash
# Access baux-bot from any mesh node
ssh badlandz@192.168.33.101 "tmux attach-session -t baux-bot-session"

# Direct mesh connectivity confirmed
ping 100.64.0.1  # Reach baux01
ping 100.64.0.2  # Reach 01x300
```

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

### Diagnostic Commands (Tested & Working)
```bash
# Check session status
tmux ls  # See active sessions
ps aux | grep baux-bot  # Check AI assistant

# View mesh connectivity
tailscale status
ping 100.64.0.1  # Ping mesh nodes
ping 100.64.0.2

# Server diagnostics
headscale nodes list
headscale preauthkeys list --user 1

# Force session sync (planned)
# baux session sync --force

# Debug connectivity
tailscale ping 100.64.0.2  # Direct mesh ping
```

## Implementation Details

### tmux Configuration (Working Setup)
```bash
# BAUX-enhanced tmux.conf
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# BAUX integration
set-environment -g BAUX_SESSION_ID "#{session_id}"
set -g status-right "BAUX: #{session_name}"

# Current working configuration on mesh nodes
# - baux-bot session: Immortal AI assistant
# - RAG persistence: Knowledge base survives reboots
# - Mesh connectivity: Direct peer links maintained
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

## Current Achievements & Future Enhancements

### ✅ Completed Features
- **Immortal Sessions:** tmux sessions persist across reboots
- **AI Integration:** Baux-bot with persistent RAG in tmux
- **Mesh Connectivity:** Direct peer-to-peer links established
- **Cross-Device Access:** SSH-based session roaming working

### Advanced Features (Next Phase)
- **Session Recording:** Historical playback
- **Collaborative Sessions:** Multi-user editing
- **AI Integration:** Enhanced session suggestions (Grok/xai working)
- **Resource Pooling:** Distribute across mesh devices

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