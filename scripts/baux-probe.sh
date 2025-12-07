#!/usr/local/bin/bash
# BAUX System Probe Script
# Gathers hardware and software information for BAUX compatibility testing
# Usage: ./baux-probe.sh [output_file]

OUTPUT_FILE="${1:-baux-probe-$(hostname)-$(date +%Y%m%d-%H%M%S).txt}"

echo "BAUX System Probe Report" > "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "Hostname: $(hostname)" >> "$OUTPUT_FILE"
echo "User: $(whoami)" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "SYSTEM INFORMATION" >> "$OUTPUT_FILE"
echo "==================" >> "$OUTPUT_FILE"
uname -a >> "$OUTPUT_FILE"
echo "OS Version: $(freebsd-version)" >> "$OUTPUT_FILE"
echo "Uptime: $(uptime)" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "HARDWARE INFORMATION" >> "$OUTPUT_FILE"
echo "====================" >> "$OUTPUT_FILE"
echo "CPU Info:" >> "$OUTPUT_FILE"
sysctl hw.model hw.ncpu hw.machine >> "$OUTPUT_FILE"
echo "Memory:" >> "$OUTPUT_FILE"
sysctl hw.physmem hw.usermem >> "$OUTPUT_FILE"
echo "Storage:" >> "$OUTPUT_FILE"
df -h >> "$OUTPUT_FILE"
echo "Network Interfaces:" >> "$OUTPUT_FILE"
ifconfig | grep -E "^[a-z]" | cut -d: -f1 >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "GRAPHICS INFORMATION" >> "$OUTPUT_FILE"
echo "====================" >> "$OUTPUT_FILE"
echo "PCI Graphics:" >> "$OUTPUT_FILE"
pciconf -lv | grep -i vga >> "$OUTPUT_FILE"
echo "DRM Modules:" >> "$OUTPUT_FILE"
kldstat | grep drm >> "$OUTPUT_FILE"
echo "X11 Status:" >> "$OUTPUT_FILE"
if command -v Xorg >/dev/null 2>&1; then
    echo "Xorg installed: $(Xorg -version 2>&1 | head -1)" >> "$OUTPUT_FILE"
else
    echo "Xorg not installed" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "INSTALLED PACKAGES" >> "$OUTPUT_FILE"
echo "==================" >> "$OUTPUT_FILE"
echo "Total packages: $(pkg info | wc -l)" >> "$OUTPUT_FILE"
echo "Key packages:" >> "$OUTPUT_FILE"
for pkg in xorg dwm tmux neovim git bash; do
    if pkg info $pkg >/dev/null 2>&1; then
        echo "  $pkg: $(pkg info $pkg | head -1)" >> "$OUTPUT_FILE"
    else
        echo "  $pkg: NOT INSTALLED" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "SERVICES STATUS" >> "$OUTPUT_FILE"
echo "===============" >> "$OUTPUT_FILE"
for svc in dbus hald slim sddm; do
    if service $svc status >/dev/null 2>&1; then
        echo "$svc: RUNNING" >> "$OUTPUT_FILE"
    else
        echo "$svc: NOT RUNNING" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "NETWORK CONFIGURATION" >> "$OUTPUT_FILE"
echo "=====================" >> "$OUTPUT_FILE"
echo "IP Addresses:" >> "$OUTPUT_FILE"
ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 >> "$OUTPUT_FILE"
echo "DNS:" >> "$OUTPUT_FILE"
cat /etc/resolv.conf >> "$OUTPUT_FILE"
echo "Hosts:" >> "$OUTPUT_FILE"
cat /etc/hosts >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "BAUX COMPATIBILITY CHECK" >> "$OUTPUT_FILE"
echo "=========================" >> "$OUTPUT_FILE"

# Check for BAUX prerequisites
echo "FreeBSD version check:" >> "$OUTPUT_FILE"
if freebsd-version | grep -q "14\|15"; then
    echo "  ✓ FreeBSD 14/15 detected" >> "$OUTPUT_FILE"
else
    echo "  ✗ FreeBSD 14/15 required" >> "$OUTPUT_FILE"
fi

echo "Memory check:" >> "$OUTPUT_FILE"
MEM_MB=$(( $(sysctl -n hw.physmem) / 1024 / 1024 ))
if [ $MEM_MB -ge 512 ]; then
    echo "  ✓ ${MEM_MB}MB RAM (minimum 512MB)" >> "$OUTPUT_FILE"
else
    echo "  ✗ ${MEM_MB}MB RAM (minimum 512MB required)" >> "$OUTPUT_FILE"
fi

echo "Storage check:" >> "$OUTPUT_FILE"
ROOT_FREE=$(df / | tail -1 | awk '{print $4}')
if [ $ROOT_FREE -gt 1000000 ]; then  # 1GB in KB
    echo "  ✓ ${ROOT_FREE}KB free on /" >> "$OUTPUT_FILE"
else
    echo "  ✗ Only ${ROOT_FREE}KB free on / (1GB+ recommended)" >> "$OUTPUT_FILE"
fi

echo "Graphics check:" >> "$OUTPUT_FILE"
if pciconf -lv | grep -i vga >/dev/null; then
    echo "  ✓ Graphics card detected" >> "$OUTPUT_FILE"
else
    echo "  ✗ No graphics card detected" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "RECOMMENDATIONS" >> "$OUTPUT_FILE"
echo "===============" >> "$OUTPUT_FILE"

# Generate recommendations
if ! pkg info xorg >/dev/null 2>&1; then
    echo "- Install Xorg: pkg install xorg" >> "$OUTPUT_FILE"
fi

if ! pkg info dwm >/dev/null 2>&1; then
    echo "- Install window manager: pkg install dwm" >> "$OUTPUT_FILE"
fi

if ! pkg info neovim >/dev/null 2>&1; then
    echo "- Install neovim: pkg install neovim" >> "$OUTPUT_FILE"
fi

if ! command -v git >/dev/null 2>&1; then
    echo "- Install git: pkg install git" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "Report saved to: $OUTPUT_FILE"
echo "Send this file when reporting BAUX compatibility issues."

echo "BAUX system probe completed. Report: $OUTPUT_FILE"