# CoseismicBSD Fonts Package - Implementation Plan v3.0

## Executive Summary

This plan creates a single, policy-compliant FreeBSD port (`cbsd-fonts`) that replaces system default fonts with a curated collection optimized for development and legal documents. The port uses proper FreeBSD port mechanisms for dependencies, conflicts, and installation, ensuring safe upgrades and removals.

**Note:** This is the original Debian implementation plan, updated for FreeBSD compatibility. See `fixedplan.md` for the current FreeBSD-specific implementation.

## Package Structure

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
│   ├── 99-cbsd-defaults.conf   # Fontconfig priority config
│   └── cbsd-fonts.sh           # Post-install script
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

## FreeBSD Port Makefile

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
%%FONTDIR%%/consolefonts/CBSD-Mono-16.psf.gz
etc/fonts/conf.d/99-cbsd-defaults.conf
```

### Console Font Handling
**Safe Console Font Management:**
- Install custom console fonts as `CBSD-Mono-16.psf.gz` (don't overwrite system files)
- Use `vidcontrol -f` in post-install to apply console fonts
- Never conflict with `console-setup` package (it's Essential: yes)
- FreeBSD uses `/usr/share/consolefonts/` for PSF fonts

## Font Configuration

### Font Priority Configuration
```xml
<!-- 99-cbsd-defaults.conf -->
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

## Post-Install Scripts

### FreeBSD Post-Install (pkg-message)
```bash
# Post-install script for cbsd-fonts

# Rebuild font cache
fc-cache -fv

# Update console if console fonts present
if [ -f /usr/share/consolefonts/CBSD-Mono-16.psf.gz ]; then
    vidcontrol -f /usr/share/consolefonts/CBSD-Mono-16.psf.gz
fi

echo "CoseismicBSD fonts installed. Restart applications for full effect."
```

### Pre-Removal (prerm)
```bash
#!/bin/bash
set -e

case "$1" in
    remove|upgrade|failed-upgrade)
        # No aggressive package removal - apt handles conflicts automatically
        # Just clean up our configuration
        if [ -f /etc/fonts/conf.d/99-roxieos-defaults.conf ]; then
            rm -f /etc/fonts/conf.d/99-roxieos-defaults.conf
        fi
        ;;
esac

exit 0
```

### Post-Removal (postrm)
```bash
#!/bin/bash
set -e

case "$1" in
    purge)
        # Rebuild font cache after removal
        fc-cache -fv
        
        # Restore console setup if needed
        if command -v setupcon >/dev/null 2>&1; then
            setupcon --force
        fi
        ;;
esac

exit 0
```

## Build Process

### Debian Rules File
```makefile
#!/usr/bin/make -f

%:
	dh $@

override_dh_auto_build:
	# Build Nerd Fonts variants where needed
	./scripts/build-nerd-fonts.sh
	
	# Generate console fonts from monospaced fonts
	./scripts/build-console-fonts.sh

override_dh_install:
	dh_install --exclude=.gitignore --exclude=README.md

override_dh_clean:
	dh_clean
	$(RM) -rf build/
```

### Font Building Scripts

#### Nerd Fonts Integration
```bash
#!/bin/bash
# scripts/build-nerd-fonts.sh

# Download Nerd Font patcher
mkdir -p build/nerd-fonts
cd build/nerd-fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip
unzip FontPatcher.zip

# Patch fonts that don't have Nerd variants
for font in ../../sources/monospaced/*.ttf; do
    if [[ ! "$font" =~ "Nerd" ]]; then
        python3 font-patcher "$font" --complete --outputdir ../../build/monospaced/
    fi
done
```

#### Console Font Generation
```bash
#!/bin/bash
# scripts/build-console-fonts.sh

# Convert primary monospace font to PSF for console use
mkdir -p build/console

# Use fontforge or otf2bdf to convert TTF to PSF
# This is a simplified example - actual implementation needs proper glyph mapping
fontforge -lang=ff -c 'Open($1); Generate($2)' \
    sources/monospaced/FiraCodeNerdFont-Regular.ttf \
    build/console/RoxieOS-Mono-16.psf

gzip build/console/RoxieOS-Mono-16.psf
```

## License Management

### Copyright File Structure
```
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: roxieos-fonts
Source: https://roxieos.com

Files: *
Copyright: Various upstream font authors
License: various

Files: sources/monospaced/FiraCode*
Copyright: 2015-2022 Nikita Prokopov
License: OFL-1.1

Files: sources/monospaced/JetBrainsMono*
Copyright: 2020 JetBrains s.r.o.
License: OFL-1.1

[Continue for each font family...]
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
vidcontrol -f
```

### Testing Checklist
- [ ] Fresh Debian Trixie VM installation
- [ ] Verify conflicting packages are automatically removed
- [ ] Check font cache updates correctly
- [ ] Test applications: terminals, IDEs, LibreOffice, browsers
- [ ] Verify console (Ctrl-Alt-F3) shows usable font
- [ ] Test upgrade from previous version
- [ ] Attempt conflict installation (should fail gracefully)

## Deployment Strategy

### Internal Repository Setup
```bash
# Create internal apt repository
mkdir -p /var/www/html/roxieos-repo/conf
cat > /var/www/html/roxieos-repo/conf/distributions << EOF
Codename: roxieos-trixie
Components: main
Architectures: amd64 all
SignWith: your-gpg-key-id
EOF

# Add package to repository
reprepro --basedir /var/www/html/roxieos-repo includedeb roxieos-trixie roxieos-fonts_1.0_all.deb
```

### Client Installation
```bash
# Add CoseismicBSD repository
mkdir -p /usr/local/etc/pkg/repos
cat > /usr/local/etc/pkg/repos/coseismic.conf << 'EOF'
coseismic: {
  url: "https://pkg.coseismic.org/freebsd/15/amd64",
  enabled: yes,
  priority: 100
}
EOF

# Update repository database
pkg update

# Install
pkg install cbsd-fonts
```

## Future Maintenance

### Version Updates
1. Update font sources in `sources/` directory
2. Bump version in `debian/changelog`
3. Rebuild package: `dpkg-buildpackage -us -uc`
4. Upload to internal repository
5. Clients receive via `apt upgrade`

### Rollback Procedure
```bash
# Uninstall CoseismicBSD fonts (pkg will restore conflicts)
pkg remove cbsd-fonts

# Manually restore defaults if needed
pkg install --reinstall dejavu liberation-fonts-ttf
```

## Benefits of This Approach

1. **Policy Compliant**: Uses proper Debian Conflicts/Replaces, no forbidden apt calls
2. **Atomic Operations**: Either everything works or nothing changes
3. **Upgrade Safe**: Handles version upgrades correctly
4. **Minimal Maintenance**: apt handles dependency resolution automatically
5. **User Friendly**: Clean installation/removal with proper notifications
6. **Professional**: Follows Debian Fonts Team best practices

## Implementation Timeline

1. **Week 1**: Set up package structure, download font sources
2. **Week 2**: Implement build scripts, generate Nerd Font variants
3. **Week 3**: Create maintainer scripts, test on fresh VM
4. **Week 4**: Internal repository setup, user acceptance testing
5. **Week 5**: Documentation, deployment to production workstations

This plan provides a robust, maintainable solution that replaces system fonts safely while following all Debian packaging best practices.