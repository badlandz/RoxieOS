# BAUXBSD Package Structure
**Clean, Minimal, FreeBSD-Native**

## Core Philosophy
Every package starts with 'b' for muscle memory and minimal typing. Maximum 4 characters per command.

## Package Hierarchy

### Core Packages (v0.1 Essential)
```
bauxbsd/ports/
├── bbase/           # System foundation
│   ├── Makefile
│   ├── pkg-descr
│   ├── pkg-plist
│   └── files/
│       └── usr/share/syscons/keymaps/baux.kbd
├── baux/            # Shell/session manager
├── bwm/             # Window manager
├── bterm/           # Terminal
├── bvi/             # Editor
├── bweb/            # Browser
├── chaos/           # Screensaver
└── baux-bot/        # AI assistant
```

### Optional Packages (-dev tier)

```
├── bview/           # Image viewer
├── bmedia/          # Media player
├── bbot/            # AI assistant
└── bdrop/           # Session persistence
```

## FreeBSD Port Structure

### Standard Port Layout
```
bbase/
├── Makefile          # Port build instructions
├── pkg-descr         # Package description
├── pkg-plist         # File installation list
├── distinfo          # Checksums for distfiles
└── files/            # Additional files to install
    └── usr/share/syscons/keymaps/baux.kbd
```

### Example Makefile
```makefile
PORTNAME=    bbase
CATEGORIES=   sysutils
COMMENT=      BAUXBSD system foundation with keymap

MAINTAINER=   badlandz@bauxbsd.org
WWW=          https://bauxbsd.org

USES=         python
RUN_DEPENDS=   bash tmux

PLIST_FILES=   share/syscons/keymaps/baux.kbd \
               etc/rc.conf.d/baux

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/share/syscons/keymaps
	${INSTALL_DATA} ${FILESDIR}/baux.kbd ${STAGEDIR}${PREFIX}/share/syscons/keymaps/baux.kbd
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/rc.conf.d
	${INSTALL_DATA} ${FILESDIR}/baux.rc ${STAGEDIR}${PREFIX}/etc/rc.conf.d/baux

.include <bsd.port.mk>
```

### Port Dependencies

| Package | Required Ports | Size |
|---------|----------------|-------|
| bbase | bash, tmux | 50MB |
| baux | tmux, seaweedfs, rsync, git | 80MB |
| bwm | dwm, picom | 25MB |
| bterm | st, libXft | 5MB |
| bvi | neovim (lite/dev variants) | 15MB/50MB |
| bweb | qutebrowser | 40MB |
| chaos | tmux | 1MB |
| baux-bot | ollama | 4GB |
| bview | sxiv | 2MB |
| bmedia | mpv | 15MB |
| bbot | ollama | 4GB |
| bdrop | seaweedfs | 50MB |

## Installation Order

### Core Installation Sequence
1. **bbase** - System foundation, keymap - *⚠️ blocked by privilege escalation bug*
2. **baux** - Shell environment - *pending bbase completion*
3. **bwm** - Window manager (if X11) - *pending baux completion*
4. **bterm** - Terminal (if X11) - *not implemented*
5. **bvi** - Editor (lite/dev variants) - *pending baux completion*
6. **bweb** - Browser - *not implemented*
7. **chaos** - Screensaver - *pending baux completion*
8. **baux-bot** - AI assistant (optional, requires Ollama) - *pending baux completion*

### Configuration Management

### System-wide Configs
```
/usr/local/etc/baux/          # BAUX configurations
/usr/local/etc/bwm/           # Window manager configs
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
- **4 characters max**: bwm, bvi, bweb, bterm
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

## Special Considerations

### bvi Conflict Resolution
```makefile
# In bvi/Makefile
CONFLICTS_INSTALL= bvi-[0-9]*
```

This declares the intentional replacement of the basic binary editor with our enhanced Neovim wrapper.

This structure ensures maximum compatibility with FreeBSD ports system while maintaining the minimal, consistent BAUX philosophy.