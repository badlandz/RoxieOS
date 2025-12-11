# BWM Build Fixes for FreeBSD

## Summary
bwm (BAUX Window Manager) build was failing on FreeBSD due to Linux assumptions in the build system. All issues have been resolved and bwm builds successfully.

## Issues Fixed

### 1. Incorrect Shebang (CRITICAL)
**Problem**: build-bwm-simple.sh used #!/bin/sh but relied on bash-specific syntax
**Fix**: Changed to #!/usr/local/bin/bash (FreeBSD bash location)
**Impact**: Script could not execute properly

### 2. Wrong Privilege Escalation Tool (CRITICAL)  
**Problem**: Used sudo (Linux) instead of doas (FreeBSD)
**Fix**: Replaced all sudo commands with doas
**Impact**: Installation commands failed silently

### 3. Incorrect Library Paths (CRITICAL)
**Problem**: dwm config.mk used Linux X11 paths (/usr/X11R6/) instead of FreeBSD paths
**Fix**: Updated config.mk:
- X11INC = /usr/X11R6/include → /usr/local/include
- X11LIB = /usr/X11R6/lib → /usr/local/lib  
- FREETYPEINC = /usr/include/freetype2 → /usr/local/include/freetype2
**Impact**: X11 headers not found, build failed

### 4. Missing Configuration Definition (CRITICAL)
**Problem**: BAUX config.h missing gappx variable used by dwm.c for window gaps
**Fix**: Added static const unsigned int gappx = 5; to config.h
**Impact**: Compilation errors for undefined gappx

### 5. Path Resolution Issues (MODERATE)
**Problem**: Script path detection failed when run via doas
**Fix**: Hardcoded SCRIPT_DIR path for reliability
**Impact**: Source files not copied to build directory

## Verification

### Build Test
cd ~/src/RoxieOS
doas ./build-bwm-simple.sh

### Installation Verification
ls -la /usr/local/bin/bwm
# Should show executable bwm binary

## Files Modified
1. build-bwm-simple.sh - Fixed shebang, privilege escalation, path resolution
2. patches/upstream/dwm/config.mk - Updated FreeBSD library paths  
3. ports/bwm/files/config.h - Added missing gappx definition

## Critical Notes for Future Debugging

### Dependencies Required
doas pkg install -y xorgproto libX11 libXft libXinerama freetype2

### Common Error Patterns
- Bad substitution → Wrong shebang, use /usr/local/bin/bash
- sudo: not found → Replace with doas
- X11/Xlib.h not found → Fix X11INC path in config.mk
- undefined identifier gappx → Add gappx to config.h

## Status
✅ RESOLVED: bwm builds and installs successfully on FreeBSD
✅ TESTED: Verified working on 192.168.33.101
✅ DOCUMENTED: All fixes and troubleshooting steps recorded
