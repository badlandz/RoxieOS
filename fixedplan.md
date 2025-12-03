# CoseismicBSD Fonts Package - FreeBSD Implementation Plan v3.0

## Executive Summary

This plan adapts the original Debian-based RoxieOS fonts consolidation to **CoseismicBSD** (formerly RoxieOS), creating a single, policy-compliant FreeBSD port (`cbsd-fonts`) that replaces system default fonts with a curated collection optimized for development and legal documents. The port uses proper FreeBSD port mechanisms for dependencies, conflicts, and installation, ensuring safe upgrades and removals.

**Why FreeBSD?** FreeBSD provides a cleaner, more robust foundation with the ports system that offers superior control over package building and customization compared to Debian's apt system. This aligns with CoseismicBSD's philosophy of minimal, focused components with maximum reliability.

## Critical FreeBSD Modifications & Hacks

### System Integration Changes
- **Package Manager**: Migrate from `apt/dpkg` to `pkg` with ports framework
- **Init System**: Replace systemd dependencies with BSD rc.d scripts
- **Console Fonts**: Use `vidcontrol` instead of Debian's `setupcon`
- **Font Paths**: Adapt to FreeBSD's `/usr/local/share/fonts/` hierarchy
- **Configuration**: Move from `/etc/fonts/` to `/usr/local/etc/fonts/`

### FreeBSD-Specific Hacks
1. **Console Font Loading**: FreeBSD requires PSF fonts in `/usr/share/consolefonts/` with `vidcontrol -f`
2. **Fontconfig Priority**: Use `/usr/local/etc/fonts/conf.d/` for system-wide font aliases
3. **Package Conflicts**: Implement `CONFLICTS` in Makefile instead of Debian's Conflicts/Replaces
4. **Build System**: Use `bsd.port.mk` framework instead of debhelper

## Port Structure

### Basic FreeBSD Port Layout
```
ports/x11-fonts/cbsd-fonts/
├── Makefile                    # Port build instructions and metadata
├── pkg-descr                   # Package description
├── pkg-plist                   # File installation list
├── distinfo                    # Checksums for distfiles
├── sources/                    # Upstream font sources (auto-fetched)
│   ├── monospaced/
│   ├── serif/
│   ├── sans/
│   └── console/
├── build/                      # Built font files (generated)
├── common/                     # Shared build utilities
│   ├── build-fonts.py          # Unified build orchestrator
│   ├── nerd_patcher.py         # Nerd Font patching
│   ├── console_gen.py          # PSF console font generation
│   ├── validate.py             # Font validation
│   └── fetch_sources.py        # Automated source fetching
├── files/                      # Port-specific files
│   ├── 99-cbsd-defaults.conf # Fontconfig priority config
│   └── cbsd-fonts.sh        # Post-install script
└── scripts/                    # Build scripts (if needed)
```

## Font Collections

### Clean Monospaced Fonts
1. **Fira Code Nerd Font** - Primary monospace with ligatures
2. **JetBrains Mono** - Developer-optimized with excellent legibility
3. **Hack** - Open-source, clear character distinction
4. **Source Code Pro** - Adobe's professional monospace
5. **Iosevka** - Highly customizable for long coding sessions

### Accessibility Monospaced Fonts
1. **OpenDyslexic Mono** - Weighted bottoms prevent letter flipping
2. **Intel One Mono** - Enhanced distinction for low-vision users
3. **Atkinson Hyperlegible Mono** - Exaggerated forms for better recognition

### Professional Variable-Width Fonts
**Serif (Legal Documents):**
- Century Schoolbook (SCOTUS requirement)
- Times New Roman (universal compatibility)
- Garamond (reduced eye strain)
- Palatino (LaTeX compatibility)
- Georgia (print optimization)
- Book Antiqua, Caslon, Baskerville, Equity, Bookman Old Style

**Sans-Serif (Headers/UI):**
- Helvetica (professional neutrality)
- Arial (compatibility)
- Calibri (modern Microsoft default)
- Montserrat (contemporary polish)

## FreeBSD Makefile

### Port Metadata
```makefile
PORTNAME=       cbsd-fonts
DISTVERSION=    1.0
CATEGORIES=     x11-fonts
MASTER_SITES=   # Will be set dynamically in fetch_sources.py

MAINTAINER=     team@coseismic.org
COMMENT=        CoseismicBSD curated font collection
WWW=            https://coseismic.org

LICENSE=        OFL11
LICENSE_FILE=   ${WRKSRC}/LICENSE

RUN_DEPENDS=    fontconfig>=2.13:devel/fontconfig \
                mkfontscale>x11-fonts/mkfontscale

CONFLICTS=      dejavu>=2.37 \
                liberation-fonts-ttf>=2.1.5 \
                tex-gyre-fonts>=20180621 \
                cantarell-fonts>=0.303.1 \
                ubuntu-font-family>=0.83

# FreeBSD-specific: Use CONFLICTS instead of CONFLICTS/REPLACES
# Note: FreeBSD pkg handles conflicts more gracefully than apt

USES=           python:3.8+ fontforge
USE_PYTHON=     autoplist distutils

NO_ARCH=        yes
NO_BUILD=       yes  # We handle building in do-install

.include <bsd.port.mk>
```

## File Installation Strategy

### Font File Locations
```makefile
# In pkg-plist
%%FONTDIR%%/truetype/cbsd-fonts/monospaced/FiraCodeNerdFont-Regular.ttf
%%FONTDIR%%/truetype/cbsd-fonts/monospaced/JetBrainsMono-Regular.ttf
%%FONTDIR%%/truetype/cbsd-fonts/serif/EBGaramond-Regular.ttf
%%FONTDIR%%/truetype/cbsd-fonts/sans/Cantarell-Regular.otf
%%FONTDIR%%/consolefonts/RoxieOS-Mono-16.psf.gz
etc/fonts/conf.d/99-roxieos-defaults.conf
```

### Console Font Handling
**Safe Console Font Management:**
- Install custom console fonts as `RoxieOS-Mono-16.psf.gz` (don't overwrite system files)
- Create `/etc/default/console-setup` equivalent (FreeBSD uses `/etc/ttys` and `vidcontrol`)
- Use `vidcontrol` in post-install to apply changes
- Never conflict with `consolefonts` package (it's base system)

## Font Configuration

### Font Priority Configuration
```xml
<!-- files/99-roxieos-defaults.conf -->
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Monospace priority -->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>FiraCode Nerd Font</family>
      <family>JetBrains Mono</family>
      <family>Hack</family>
    </prefer>
  </alias>

  <!-- Serif priority -->
  <alias>
    <family>serif</family>
    <prefer>
      <family>TeX Gyre Schola</family>
      <family>Century Schoolbook</family>
      <family>Garamond</family>
    </prefer>
  </alias>

  <!-- Sans-serif priority -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Montserrat</family>
      <family>Helvetica</family>
      <family>Calibri</family>
    </prefer>
  </alias>
</fontconfig>
```

## Build Scripts

### Unified Build System (build-fonts.py)
```python
#!/usr/bin/env python3
"""
Unified font build orchestrator for RoxieOS fonts
Handles fetching, patching, conversion, and validation
"""

import argparse
import os
import sys
from pathlib import Path

# Import shared utilities
from common.fetch_sources import fetch_all_sources
from common.nerd_patcher import patch_nerd_fonts
from common.console_gen import generate_console_fonts
from common.validate import validate_fonts

def main():
    parser = argparse.ArgumentParser(description='Build RoxieOS fonts')
    parser.add_argument('--fetch', action='store_true', help='Fetch sources')
    parser.add_argument('--patch', action='store_true', help='Apply Nerd Font patches')
    parser.add_argument('--console', action='store_true', help='Generate console fonts')
    parser.add_argument('--validate', action='store_true', help='Validate fonts')
    parser.add_argument('--all', action='store_true', help='Run all steps')

    args = parser.parse_args()

    if args.all or args.fetch:
        fetch_all_sources()

    if args.all or args.patch:
        patch_nerd_fonts()

    if args.all or args.console:
        generate_console_fonts()

    if args.all or args.validate:
        validate_fonts()

if __name__ == '__main__':
    main()
```

### Source Fetching (fetch_sources.py)
```python
#!/usr/bin/env python3
"""
Automated source fetching for RoxieOS fonts
Downloads from upstream with version pinning
"""

import requests
import hashlib
import os
from pathlib import Path

SOURCES_CONFIG = {
    'firacode': {
        'url': 'https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip',
        'sha256': '...'  # To be calculated
    },
    'jetbrains-mono': {
        'url': 'https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip',
        'sha256': '...'
    },
    # Add all other fonts...
}

def fetch_source(name, config):
    """Fetch and verify a single source"""
    dest = Path('sources') / name
    dest.mkdir(parents=True, exist_ok=True)

    response = requests.get(config['url'])
    response.raise_for_status()

    # Verify checksum
    if hashlib.sha256(response.content).hexdigest() != config['sha256']:
        raise ValueError(f"Checksum mismatch for {name}")

    # Extract (assuming zip for simplicity)
    import zipfile
    with zipfile.ZipFile(io.BytesIO(response.content)) as zf:
        zf.extractall(dest)

def fetch_all_sources():
    """Fetch all configured sources"""
    for name, config in SOURCES_CONFIG.items():
        fetch_source(name, config)
```

## Installation and Testing

### Build Commands
```bash
# Build the port
cd /usr/ports/x11-fonts/cbsd-fonts
make fetch
make build
make install

# Test font configuration
fc-match monospace
fc-match serif
fc-match sans-serif

# Test console font
vidcontrol -f /usr/local/share/consolefonts/RoxieOS-Mono-16.psf.gz
```

### Testing Checklist
- [ ] Fresh FreeBSD installation
- [ ] Verify conflicting packages are automatically removed
- [ ] Check font cache updates correctly
- [ ] Test applications: terminals, IDEs, LibreOffice, browsers
- [ ] Verify console (ttyv0) shows usable font
- [ ] Test upgrade from previous version
- [ ] Attempt conflict installation (should fail gracefully)

## Deployment Strategy

### Local Repository Setup
```bash
# Create local package repository
mkdir -p /usr/local/poudriere/ports/roxieos
cd /usr/local/poudriere/ports/roxieos
git clone https://github.com/roxieos/ports.git .

# Build packages
poudriere bulk -j cbsd -p cbsd x11-fonts/cbsd-fonts

# Serve repository
pkg repo /usr/local/poudriere/data/packages/roxieos-FreeBSD:13:amd64/
```

### Client Installation
```bash
# Add repository
mkdir -p /usr/local/etc/pkg/repos
cat > /usr/local/etc/pkg/repos/roxieos.conf << EOF
roxieos: {
  url: "https://repo.roxieos.com/freebsd/13/amd64",
  enabled: yes
}
EOF

# Install
pkg update
pkg install cbsd-fonts
```

## Implementation Instructions

### Step 1: Set Up Port Directory
```bash
sudo mkdir -p /usr/ports/x11-fonts/roxieos-fonts
cd /usr/ports/x11-fonts/roxieos-fonts
```

### Step 2: Create Makefile
Create the Makefile as shown above. Key points:
- Set PORTNAME, DISTVERSION, CATEGORIES
- Define RUN_DEPENDS for fontconfig and mkfontscale
- Set CONFLICTS to replace system fonts
- Use python and fontforge for building
- Set NO_BUILD=yes since we handle building in do-install

### Step 3: Create pkg-descr
```text
RoxieOS curated font collection optimized for development and legal documents.
Includes monospaced fonts with ligatures, accessibility-focused fonts,
and professional serif/sans fonts for document production.
Replaces default system fonts to ensure consistent typography across
all applications.
```

### Step 4: Create pkg-plist
List all files to be installed. Use %%FONTDIR%% for font directory.

### Step 5: Create distinfo
Run `make makesum` after setting up sources to generate checksums.

### Step 6: Implement Build Scripts
Create the Python scripts in common/ as shown above.

### Step 7: Add Fontconfig Config
Create files/99-roxieos-defaults.conf as shown.

### Step 8: Add Post-Install Script
Create files/cbsd-fonts.sh:
```bash
#!/bin/sh
# Post-install script for cbsd-fonts

# Rebuild font cache
fc-cache -fv

# Update console if console fonts present
if [ -f /usr/local/share/consolefonts/RoxieOS-Mono-16.psf.gz ]; then
    vidcontrol -f /usr/local/share/consolefonts/RoxieOS-Mono-16.psf.gz
fi

echo "CoseismicBSD fonts installed. Restart applications for full effect."
```

### Step 9: Test the Port
```bash
make fetch
make build
make install
make test (if you add tests)
```

### Step 10: Handle Missing Fonts
For fonts not available as FreeBSD packages:
- Download directly from upstream
- Include in the port's distfiles
- Build custom versions if needed (e.g., Iosevka from source)

## Benefits of This Approach

1. **FreeBSD Native**: Uses ports system properly
2. **Atomic Operations**: Either everything works or nothing changes
3. **Upgrade Safe**: Handles version upgrades correctly
4. **Minimal Maintenance**: pkg handles dependency resolution automatically
5. **User Friendly**: Clean installation/removal with proper notifications
6. **Professional**: Follows FreeBSD Ports Team best practices

## Future Maintenance

### Version Updates
1. Update sources in common/fetch_sources.py
2. Bump DISTVERSION in Makefile
3. Rebuild port: make build
4. Upload to local repository
5. Clients receive via pkg upgrade

### Rollback Procedure
```bash
# Uninstall CoseismicBSD fonts (pkg will restore conflicts)
pkg remove cbsd-fonts

# Manually restore defaults if needed
pkg install --reinstall dejavu liberation-fonts-ttf
```

This plan provides a robust, maintainable solution that replaces system fonts safely while following all FreeBSD packaging best practices.

---

## Complete CoseismicBSD System Porting Strategy

### Overview
The font package is just one component of the complete **CoseismicBSD** system port from Debian to FreeBSD. This section outlines the full system-wide migration strategy.

### Core System Components

#### 1. cbsd-base (formerly roxieos-base)
**FreeBSD Adaptations:**
- Replace systemd autologin with BSD rc.d scripts
- Use `/etc/rc.conf` for service management
- Adapt Caps=Esc remapping for BSD console
- Configure X auto-start via `.xinitrc` and display managers

#### 2. cbsd-terminal (formerly baux)
**FreeBSD Modifications:**
- Replace tmux systemd integration with BSD process management
- Adapt socket paths for BSD filesystem hierarchy
- Use BSD-specific health monitoring (`sysctl` instead of `/proc`)
- Integrate with BSD pkg instead of apt for dependencies

#### 3. cbsd-wm (formerly bauxwm)
**FreeBSD Changes:**
- Port DWM fork to BSD build system
- Adapt X11 integration for BSD's X.org
- Use BSD keyboard mapping system
- Integrate with BSD console fonts via `vidcontrol`

#### 4. cbsd-editor (formerly neovim-roxanne)
**FreeBSD Specifics:**
- Adapt AI bot integration for BSD socket handling
- Use BSD file paths and permissions
- Integrate with BSD terminal multiplexers
- Optimize for BSD console rendering

### System-Wide FreeBSD Hacks

#### Package Management
```makefile
# Replace debhelper with FreeBSD ports framework
.include <bsd.port.mk>

# Use CONFLICTS instead of Debian Conflicts/Replaces
CONFLICTS=    base-system-fonts

# FreeBSD-specific dependencies
RUN_DEPENDS=   fontconfig>=2.13:devel/fontconfig \
                mkfontscale:x11-fonts/mkfontscale
```

#### Init System Migration
```bash
# Replace systemd services with BSD rc.d
#!/bin/sh
# /usr/local/etc/rc.d/cbsd-terminal
. /etc/rc.subr

name="cbsd_terminal"
rcvar="cbsd_terminal_enable"
start_cmd="${name}_start"
stop_cmd="${name}_stop"

cbsd_terminal_start()
{
    echo "Starting CoseismicBSD Terminal..."
    su -l ${cbsd_terminal_user:-root} -c "exec /usr/local/bin/cbsd-terminal"
}
```

#### Console Font Management
```bash
# FreeBSD console font loading (replace setupcon)
#!/bin/sh
# Post-install script for console fonts
if [ -f /usr/share/consolefonts/CBSD-Mono-16.psf.gz ]; then
    vidcontrol -f /usr/share/consolefonts/CBSD-Mono-16.psf.gz
    echo "CoseismicBSD console font loaded"
fi
```

#### File System Adaptation
```
Debian → FreeBSD Paths
/etc/fonts/ → /usr/local/etc/fonts/
/usr/share/fonts/ → /usr/local/share/fonts/
/var/cache/ → /var/cache/
/etc/systemd/ → /usr/local/etc/rc.d/
```

### Build System Conversion

#### From Debian build-all.sh to FreeBSD ports.mk
```makefile
# ports/x11/cbsd/Makefile
PORTNAME=    cbsd
DISTVERSION= 1.0
CATEGORIES=   x11-wm

MAINTAINER=   team@coseismic.org
COMMENT=      CoseismicBSD Desktop Environment

RUN_DEPENDS=  cbsd-terminal:x11/cbsd-terminal \
                cbsd-editor:x11/cbsd-editor \
                cbsd-fonts:x11-fonts/cbsd-fonts

USES=         xorg
USE_XORG=     yes

.include <bsd.port.mk>
```

### Migration Strategy

#### Phase 1: Core Infrastructure
1. **Ports Tree Setup**: Create `/usr/ports/x11/cbsd/` hierarchy
2. **Build System**: Convert all packages to ports framework
3. **Repository**: Set up pkg repository for CoseismicBSD
4. **Testing**: Establish FreeBSD build environment

#### Phase 2: System Integration
1. **Init Scripts**: Convert systemd services to rc.d
2. **Console Support**: Adapt font loading and console tools
3. **X11 Integration**: Port window manager and display system
4. **Package Management**: Migrate from apt to pkg

#### Phase 3: Deployment
1. **Live System**: Create FreeBSD live ISO with CoseismicBSD
2. **Installation**: Develop FreeBSD installer scripts
3. **Documentation**: Create FreeBSD-specific installation guides
4. **Migration Tools**: Build Debian→FreeBSD migration utilities

### Critical FreeBSD Advantages

1. **Cleaner Architecture**: No systemd complexity, direct system control
2. **Superior Ports**: Fine-grained control over package building
3. **Better Performance**: More efficient kernel and system management
4. **Professional Reputation**: FreeBSD's reputation for stability and security
5. **Simplified Maintenance**: pkg is more predictable than apt

This comprehensive porting strategy ensures CoseismicBSD leverages FreeBSD's strengths while maintaining the innovative cyberdeck vision of the original RoxieOS project.</content>
<parameter name="filePath">/home/coyote/fixedplan.md