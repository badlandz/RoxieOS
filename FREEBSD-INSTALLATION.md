# CoseismicBSD FreeBSD Installation & Migration Guide

## Overview

This guide covers complete installation of **CoseismicBSD** on FreeBSD systems and migration from existing Debian-based RoxieOS installations. CoseismicBSD leverages FreeBSD's superior ports system and cleaner architecture for a more robust cyberdeck environment.

## System Requirements

### Hardware Requirements
- **Architecture**: amd64 (x86_64)
- **Memory**: Minimum 4GB RAM (8GB+ recommended for AI features)
- **Storage**: 20GB free disk space
- **Network**: Internet connection for package installation

### FreeBSD Version Support
- **FreeBSD 15.0-RELEASE** (Primary target)
- **FreeBSD 14.x** (Supported)
- **FreeBSD 13.x** (Legacy support)

## Installation Methods

### Method 1: Fresh FreeBSD Installation

#### Step 1: Base FreeBSD Installation
```bash
# Download FreeBSD 15.0-RELEASE
fetch https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/15.0-RELEASE/freebsd-15.0-RELEASE-amd64-disc1.iso

# Create bootable USB
dd if=freebsd-15.0-RELEASE-amd64-disc1.iso of=/dev/da0 bs=1M status=progress

# Boot and install following standard FreeBSD installer
# Choose: Minimal installation + ports collection
```

#### Step 2: CoseismicBSD Repository Setup
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

# Install CoseismicBSD meta-package
pkg install cbsd-meta
```

#### Step 3: System Configuration
```bash
# Enable CoseismicBSD services
sysrc cbsd_terminal_enable="YES"
sysrc cbsd_wm_enable="YES"
sysrc cbsd_editor_enable="YES"

# Configure console font
echo 'font8x16="/usr/share/consolefonts/CBSD-Mono-16.psf.gz"' >> /etc/rc.conf
echo 'font8x14="/usr/share/consolefonts/CBSD-Mono-14.psf.gz"' >> /etc/rc.conf

# Reboot for full system integration
reboot
```

### Method 2: Migration from Debian/RoxieOS

#### Step 1: Backup Existing System
```bash
# Backup critical data
mkdir -p /mnt/backup/roxieos
cp -r /home /mnt/backup/roxieos/
cp -r /etc /mnt/backup/roxieos/etc-backup
cp -r /usr/local/etc /mnt/backup/roxieos/local-etc-backup

# Export package list (for reference)
dpkg --get-selections > /mnt/backup/roxieos/packages.txt
```

#### Step 2: FreeBSD Installation
```bash
# Follow Method 1 for fresh FreeBSD installation
# During partitioning, preserve /home if desired
```

#### Step 3: Data Migration
```bash
# Restore user data
cp -r /mnt/backup/roxieos/home/* /home/
chown -R root:wheel /home

# Restore selective configurations
cp -r /mnt/backup/roxieos/etc-backup/coseismic* /usr/local/etc/ 2>/dev/null || true
cp -r /mnt/backup/roxieos/local-etc-backup/* /usr/local/etc/ 2>/dev/null || true
```

#### Step 4: Package Migration
```bash
# Install CoseismicBSD equivalents
pkg install cbsd-terminal cbsd-wm cbsd-editor cbsd-fonts

# Install Debian compatibility packages if needed
pkg install linux-c6-texlive  # For LaTeX compatibility
pkg install compat64-linux  # For Linux binary compatibility
```

## FreeBSD-Specific Configuration

### Console and Terminal
```bash
# Load CoseismicBSD console font
vidcontrol -f /usr/share/consolefonts/CBSD-Mono-16.psf.gz

# Verify font loading
vidcontrol -f
```

### X11 and Window Manager
```bash
# Configure X to start CoseismicBSD WM
echo 'exec /usr/local/bin/cbsd-wm' > ~/.xinitrc
chmod +x ~/.xinitrc

# Start X manually or configure auto-start
startx
```

### Font Configuration
```bash
# Rebuild font cache
fc-cache -fv

# Verify font priority
fc-match monospace
fc-match serif
fc-match sans-serif

# Expected output should show:
# monospace: "FiraCode Nerd Font", "JetBrains Mono", "Hack"
# serif: "TeX Gyre Schola", "Century Schoolbook", "Garamond"
```

### Package Management
```bash
# List CoseismicBSD packages
pkg info | grep cbsd

# Update CoseismicBSD
pkg upgrade

# Remove individual components
pkg remove cbsd-terminal
pkg remove cbsd-wm

# Complete removal
pkg remove cbsd-meta
```

## FreeBSD Hacks and Optimizations

### Performance Tuning
```bash
# Enable performance optimizations
echo 'kern.ipc.maxsockbuf=2097152' >> /etc/sysctl.conf
echo 'net.inet.tcp.recvspace=65536' >> /etc/sysctl.conf
echo 'vfs.zfs.arc_max=2147483648' >> /etc/sysctl.conf

# Apply immediately
sysctl -f /etc/sysctl.conf
```

### Memory Management
```bash
# Configure swap for systems with <8GB RAM
# During installation or via /etc/fstab
swapfile="/usr/swap0"
dd if=/dev/zero of=$swapfile bs=1M count=4096  # 4GB swap
chmod 600 $swapfile
swapon $swapfile
echo "$swapfile none swap sw 0 0" >> /etc/fstab
```

### Network Optimization
```bash
# Configure network for cyberdeck operations
echo 'ifconfig_em0="DHCP"' >> /etc/rc.conf
echo 'gateway_enable="YES"' >> /etc/rc.conf
echo 'sshd_enable="YES"' >> /etc/rc.conf

# Advanced network tuning
echo 'net.link.if.up.0=ifconfig em0 inet 192.168.1.100 netmask 255.255.255.0' >> /etc/rc.conf
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Font Not Loading in Console
```bash
# Problem: Console shows default font
# Solution: Manually load CoseismicBSD font
vidcontrol -f /usr/share/consolefonts/CBSD-Mono-16.psf.gz

# Add to startup
echo 'vidcontrol -f /usr/share/consolefonts/CBSD-Mono-16.psf.gz' >> /etc/rc.local
chmod +x /etc/rc.local
```

#### 2. X11 Fails to Start
```bash
# Problem: X server crashes or doesn't start
# Solution: Check DRI and kernel modules
kldload i915kms  # Intel graphics
kldload amdgpu    # AMD graphics
kldload nvidia-modeset  # NVIDIA graphics

# Check X log
cat /var/log/Xorg.0.log | tail -20
```

#### 3. Package Conflicts
```bash
# Problem: pkg conflicts during installation
# Solution: Force remove conflicting packages
pkg remove -f dejavu liberation-fonts

# Lock CoseismicBSD packages
pkg lock cbsd-base cbsd-terminal cbsd-wm
```

#### 4. Performance Issues
```bash
# Problem: System feels slow
# Solution: Enable FreeBSD optimizations
sysctl hw.memsize.pages=0  # Disable page coloring
sysctl vm.pmap.pt_pages=0   # Reduce memory overhead

# Check for resource hogs
top -o res -P | head -10
```

## Migration from Specific Components

### From BAUX (Debian) to cbsd-terminal (FreeBSD)
| Feature | Debian Method | FreeBSD Method |
|---------|----------------|----------------|
| Process Management | systemd services | rc.d scripts |
| Socket Paths | /run/baux-bot.sock | /tmp/cbsd-bot.sock |
| Terminal Integration | tmux systemd integration | tmux with BSD process control |
| Health Monitoring | systemd-journal | syslog + custom scripts |

### From BAUXWM (Debian) to cbsd-wm (FreeBSD)
| Feature | Debian Method | FreeBSD Method |
|---------|----------------|----------------|
| Build System | debhelper | ports framework |
| X11 Integration | systemd user services | .xinitrc + X.org |
| Keymap Handling | xkb configuration | kbd configuration |
| Status Bar | custom script | dwm status integration |

### From neovim-roxanne (Debian) to cbsd-editor (FreeBSD)
| Feature | Debian Method | FreeBSD Method |
|---------|----------------|----------------|
| AI Integration | systemd sockets | Unix domain sockets |
| Package Management | apt dependencies | pkg dependencies |
| Configuration | /etc/neovim/ | /usr/local/etc/neovim/ |
| Plugin System | vim-plug | native FreeBSD packaging |

## Advanced Configuration

### Custom Kernel Building
```bash
# Build CoseismicBSD kernel with cyberdeck optimizations
cd /usr/src
make KERNCONF=COSEISMIC
make install
```

### ZFS Integration
```bash
# Create ZFS dataset for CoseismicBSD
zpool create coseismic /dev/ada0
zfs create coseismic/root
zfs set mountpoint=/ coseismic/root
zfs set compression=lz4 coseismic/root

# Export for system use
zfs set sharenfs=on coseismic/home
```

### Jail Integration
```bash
# Create CoseismicBSD development jail
ezjail create cbsd-dev
ezjail config -c cbsd-dev -p tcp -s 22.0.0.0:22
ezjail start cbsd-dev

# Install CoseismicBSD in jail
pkg -j cbsd-dev install cbsd-meta
```

## Support and Maintenance

### System Updates
```bash
# Update CoseismicBSD packages
pkg update && pkg upgrade

# Update base system
freebsd-update fetch
freebsd-update install

# Rebuild custom ports
cd /usr/ports/x11/cbsd-wm
make clean && make reinstall
```

### Backup and Recovery
```bash
# System backup script
#!/bin/sh
# /usr/local/sbin/cbsd-backup
DATE=$(date +%Y%m%d_%H%M%S)
zfs snapshot coseismic/root@coseismic-backup-$DATE
zfs send coseismic/root@coseismic-backup-$DATE | gzip > /backup/coseismic-$DATE.gz

# Automated backup in rc.conf
echo 'daily_backup_enable="YES"' >> /etc/rc.conf
echo 'daily_backup_cmd="/usr/local/sbin/cbsd-backup"' >> /etc/rc.conf
```

### Monitoring
```bash
# Enable system monitoring
pkg install monitoring-plugins

# Configure monitoring
echo 'bsnmpd_enable="YES"' >> /etc/rc.conf
echo 'bsnmpd_flags="-p 161 -c public"' >> /etc/rc.conf

# Custom metrics collection
cat > /usr/local/etc/cbsd-monitor.conf << 'EOF'
collect_interval=300
log_file=/var/log/cbsd-monitor.log
metrics_enabled=cpu,memory,disk,network
EOF
```

## Community and Support

### Getting Help
- **Documentation**: https://docs.coseismic.org
- **Issues**: https://github.com/badlandz/coseismicbsd/issues
- **Community**: https://community.coseismic.org
- **Updates**: https://pkg.coseismic.org/freebsd/15/amd64

### Contributing
- **Source Code**: https://github.com/badlandz/coseismicbsd
- **Ports Collection**: https://github.com/badlandz/freebsd-ports
- **Documentation**: https://github.com/badlandz/coseismicbsd-docs

This guide ensures successful migration to CoseismicBSD with all cyberdeck functionality preserved and enhanced through FreeBSD's superior architecture.