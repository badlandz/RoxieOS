# BAUXBSD Package Structure
**Clean, Minimal, FreeBSD-Native**

## Core Philosophy
Every package starts with 'b' for muscle memory and minimal typing. Maximum 4 characters per command.

## Package Hierarchy

### Core Packages (v0.1 Essential)
```
baux-base/          # System foundation
├── files/
│   ├── usr/share/syscons/keymaps/baux.kbd
│   ├── usr/local/share/X11/xkb/symbols/baux
│   └── etc/rc.conf.d/baux
├── pkg-descr         # Package description
└── Makefile           # FreeBSD port build

baux/                # Shell/session manager
├── src/
│   ├── baux           # Main wrapper script
│   └── tmux/
│       └── baux.conf   # tmux configuration
├── files/
│   └── usr/local/etc/baux/
└── Makefile

bwm/                  # Window manager
├── files/
│   └── usr/local/bin/
│       ├── dwm          # Patched dwm binary
│       └── status.sh     # Bar script
├── patches/
│   └── baux.patch      # dwm patches
└── Makefile

bterm/                # Terminal
├── files/
│   └── usr/local/bin/st   # Patched st binary
├── patches/
│   └── baux-term.patch   # st patches
└── Makefile

bvi/                  # Editor wrapper
├── src/
│   └── bvi.sh            # Neovim wrapper
├── files/
│   └── usr/local/etc/bvi/
│       ├── init.lua        # Neovim config
│       └── vimrc.tiny     # vi fallback
└── Makefile

bweb/                 # Browser
├── files/
│   └── usr/local/bin/bweb   # Browser launcher
├── patches/
│   └── qutebrowser-config/   # Theming
└── Makefile

chaos/                # Screensaver
├── files/
│   └── usr/local/bin/chaos   # tmux chaos script
└── Makefile
```

### Optional Packages (-dev tier)

```
bview/                # Image viewer
├── files/
│   └── usr/local/bin/bview   # sxiv wrapper
└── Makefile

bmedia/               # Media player
├── files/
│   └── usr/local/bin/bmedia  # mpv wrapper
└── Makefile

bbot/                 # AI assistant
├── src/
│   └── bbot.sh              # AI router script
├── files/
│   └── usr/local/etc/bbot/
│       ├── models/              # Local models
│       └── config.yaml         # Configuration
└── Makefile

bdrop/                # Session persistence
├── src/
│   └── bdrop.sh             # SeaweedFS scripts
├── files/
│   └── usr/local/etc/bdrop/
│       └── seaweedfs.conf     # Config
└── Makefile
```

## FreeBSD Port Structure

### Standard Makefile Template
```makefile
PORTNAME=    baux
CATEGORIES=   sysutils
COMMENT=      BAUX shell and session manager

MAINTAINER=   badlandz@bauxbsd.org
WWW=          https://bauxbsd.org

USES=         python
RUN_DEPENDS=   tmux seaweedfs

PLIST_FILES=   bin/baux \
               etc/baux/baux.conf \
               etc/baux/tmux.conf

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/baux ${STAGEDIR}${PREFIX}/bin/baux
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/baux
	${INSTALL_DATA} ${WRKSRC}/tmux/baux.conf ${STAGEDIR}${PREFIX}/etc/baux/baux.conf

.include <bsd.port.mk>
```

### Package Dependencies

| Package | Required Ports | Optional Ports |
|---------|----------------|----------------|
| baux-base | bash tmux |  |
| baux | tmux seaweedfs rsync git |  |
| bwm | dwm picom |  |
| bterm | st libXft |  |
| bvi | neovim |  |
| bweb | qutebrowser | surf |
| chaos | tmux |  |
| bview | sxiv |  |
| bmedia | mpv |  |
| bbot | ollama |  |
| bdrop | seaweedfs |  |

## Installation Order

### Core Installation Sequence
1. **baux-base** - System foundation, keymap
2. **baux** - Shell environment
3. **bwm** - Window manager (if X11)
4. **bterm** - Terminal (if X11)
5. **bvi** - Editor
6. **bweb** - Browser
7. **chaos** - Screensaver

### Configuration Management

### System-wide Configs
```
/usr/local/etc/baux/          # BAUX configurations
/usr/local/etc/bauxwm/        # Window manager configs
/usr/local/etc/bvi/           # Editor configs
```

### User Data
```
~/.local/share/baux/          # Session data
~/.local/share/bvi/           # Editor state
~/.local/share/bdrop/         # Persistent storage
```

## Naming Conventions

### Commands
- **4 characters max**: bvi, bwm, bweb, bterm
- **Descriptive**: baux, chaos, bview, bmedia
- **No conflicts**: Avoid existing Unix commands

### Packages
- **Lowercase**: FreeBSD port convention
- **Single word**: No hyphens in port names
- **Descriptive**: Clear purpose from name

## File Locations

### Executables
```
/usr/local/bin/b*              # Core commands
/usr/local/etc/baux*/           # System configs
/usr/local/share/baux*/          # Shared data
```

### Documentation
```
/usr/local/share/doc/baux*/      # Package docs
/usr/local/man/man1/b*.1         # Manual pages
```

This structure ensures maximum compatibility with FreeBSD ports system while maintaining the minimal, consistent BAUX philosophy.