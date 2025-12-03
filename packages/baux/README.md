# baux - Immortal Shell
**Core session management for BAUXBSD v0.1**

BAUX provides immortal tmux sessions with resurrection, anti-nesting detection, and SeaweedFS integration for persistent storage across reboots and machine migrations.

## Core Features

- **Anti-nesting**: Detects SSH/remote, skips tmux attach
- **Session resurrection**: Saves/restores panes every 5 minutes
- **SeaweedFS buffering**: Offline sync for "sleep mode"
- **Cross-machine sync**: Projects sync between BAUX instances
- **Zero intervention**: Dead panes auto-revive on Enter

## Package Structure

```
baux/
├── src/baux              # Main wrapper script
├── files/
│   ├── usr/local/bin/baux
│   └── usr/local/etc/baux/
│       ├── baux.conf      # tmux configuration
│       └── tmux.conf       # system tmux config
└── Makefile               # FreeBSD port
```

## Integration

- **bwm**: Session names in bar via BAUXWM=1
- **bvi**: Editor state persistence
- **bdrop**: SeaweedFS storage buffers
- **bbot**: AI assistant integration

## Usage

```bash
baux                    # Start BAUX environment
baux list               # Show all sessions
baux kill session-name   # Kill specific session
baux revive --all       # Restore all sessions
baux sync target        # Sync projects to target
```

## Session Persistence

BAUX implements a hybrid persistence strategy:

### ZFS Snapshots (Cold Storage)
- Automatic snapshots via zfs-periodic
- Full system state preservation
- Rollback capability for disaster recovery

### SeaweedFS Buffering (Hot Storage)
- Temporary buffering for sudden disconnects
- API-based file operations (no FUSE mounting)
- Cross-machine synchronization

### rsync/git Integration
- Reliable project synchronization
- Version control integration
- Fallback when SeaweedFS unavailable

BAUX is the foundation of instant productivity on BAUXBSD.