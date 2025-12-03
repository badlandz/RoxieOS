# BAUX: The Immortal Shell
**Core session management for BAUXBSD v0.1**  
badlandz – December 2025  
Root is love. Layers forever.

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

BAUX is the foundation of instant productivity on BAUXBSD.