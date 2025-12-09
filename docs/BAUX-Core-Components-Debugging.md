# BAUX Core Components: Theoretical Debugging Guide

This debugging guide supports the core vision by ensuring reliable Neovim, tmux, and keymap components for consistent IDE access on any system.

## Overview
This document provides theoretical debugging approaches for BAUX's core components: Neovim, Tmux, and Keymap. Based on research of common issues, implementation patterns, and troubleshooting techniques.

## 1. NEOVIM COMPONENT ANALYSIS

### Current BAUX Neovim Architecture
- **Framework**: LazyVim with lazy.nvim plugin manager
- **Variants**: lite (minimal), dev (developer), src (full build)
- **Key Features**: Unified keymaps, tmux integration, LSP support

### Common Issues & Debugging Approaches

#### A. Plugin Loading Conflicts
**Symptoms**: Plugins not working, keybindings fail, LSP errors

**Theoretical Root Causes**:
1. **Lazy Loading Conflicts**: Multiple plugins trying to load same module
2. **Dependency Order**: Plugins loading before dependencies ready
3. **Event Triggering**: Lazy events not firing correctly

**Debugging Steps**:
```lua
-- Check plugin loading status
:Lazy
:Lazy log
:Lazy profile

-- Verify plugin health
:checkhealth

-- Debug specific plugin
:lua require('lazy.core.config').plugins['plugin-name']
```

**BAUX-Specific Issues**:
- Tmux integration keybindings (`<C-b>s`, `<C-b>w`) conflicting with lazy loading
- Window navigation (`<C-hjkl>`) failing when tmux pane focus changes

#### B. Keybinding Conflicts
**Symptoms**: Keybindings work outside tmux but fail inside tmux

**Theoretical Root Causes**:
1. **Tmux Escape Sequences**: tmux intercepting key combinations
2. **Terminal Emulation**: Different TERM values causing issues
3. **Focus Events**: Neovim not receiving focus events from tmux

**Debugging Steps**:
```bash
# Check TERM variable
echo $TERM

# Test key sequences
tmux send-keys C-h  # Should navigate left in BAUX
```

**BAUX-Specific Solutions**:
```lua
-- In keymaps.lua, ensure tmux-aware bindings
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
-- But check if tmux is intercepting first
```

#### C. LSP Configuration Issues
**Symptoms**: Language servers not starting, completion not working

**Theoretical Root Causes**:
1. **Mason Installation**: LSP servers not installed
2. **Path Issues**: Executables not in PATH
3. **Configuration Conflicts**: Multiple LSP configs conflicting

**Debugging Steps**:
```lua
-- Check LSP status
:LspInfo
:LspLog

-- Verify Mason
:Mason
:MasonInstall <language-server>
```

### BAUX Neovim Debugging Checklist

1. **Plugin Loading**:
   - `:Lazy` shows all plugins loaded
   - No errors in `:Lazy log`
   - Profile shows reasonable load times (<500ms)

2. **Keybindings**:
   - `<Space>` leader works
   - `<C-hjkl>` navigation works outside tmux
   - Tmux-specific bindings work inside tmux

3. **LSP**:
   - `:LspInfo` shows attached servers
   - Completion works in supported filetypes
   - Diagnostics appear

## 2. TMUX COMPONENT ANALYSIS

### Current BAUX Tmux Architecture
- **Prefix**: `C-Space` (instead of `C-b`)
- **Plugins**: TPM, resurrect, continuum
- **Features**: Immortal sessions, pane resurrection, status bar

### Common Issues & Debugging Approaches

#### A. Session Resurrection Failures
**Symptoms**: Sessions not restoring after reboot, commands not restarting

**Theoretical Root Causes**:
1. **Save Directory**: `@resurrect-dir` not writable
2. **Process Patterns**: `@resurrect-processes` regex not matching
3. **Timing Issues**: Continuum saving during shutdown

**Debugging Steps**:
```bash
# Check resurrect directory
ls -la ~/.tmux/resurrect/

# Manual save/restore test
tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh

# Check process patterns
tmux list-panes -F '#{pane_pid} #{pane_current_command}'
```

**BAUX-Specific Issues**:
- Host-specific directories: `/var/tmp/baux-resurrect/$(hostname)`
- Process matching: `ssh mosh psql mysql serial~* "*baux*"`

#### B. Keybinding Failures
**Symptoms**: Custom keybindings not working, prefix conflicts

**Theoretical Root Causes**:
1. **Prefix Conflicts**: Other applications using `C-Space`
2. **Escape Time**: `escape-time` too high/low
3. **Key Table Issues**: Wrong key table active

**Debugging Steps**:
```bash
# Test prefix
tmux send-prefix  # Should show prefix indicator

# Check key tables
tmux list-keys

# Test specific binding
tmux bind-key M-h  # Should show binding
```

#### C. Pane Management Issues
**Symptoms**: Panes not resizing, navigation failing, status bar wrong

**Theoretical Root Causes**:
1. **Window Size**: Terminal size reporting issues
2. **Mouse Mode**: Mouse events interfering
3. **Status Bar**: Wrong status format

**Debugging Steps**:
```bash
# Check pane info
tmux display-panes

# Test mouse mode
tmux set -g mouse off  # Then test
tmux set -g mouse on   # Then test

# Reload config
tmux source ~/.tmux.conf
```

### BAUX Tmux Debugging Checklist

1. **Plugin Installation**:
   - TPM installed: `~/.tmux/plugins/tpm/`
   - Resurrect installed: `~/.tmux/plugins/tmux-resurrect/`
   - Continuum installed: `~/.tmux/plugins/tmux-continuum/`

2. **Session Management**:
   - Save works: `prefix + C-s`
   - Restore works: `prefix + C-r`
   - Auto-save enabled: `@continuum-save-interval`

3. **Keybindings**:
   - Prefix works: `C-Space`
   - Pane navigation: `M-hjkl`
   - Window switching: `M-123456789`

## 3. KEYMAP COMPONENT ANALYSIS

### Current BAUX Keymap Architecture
- **File**: `ports/bbase/baux.kbd`
- **Function**: Caps Lock → Escape (tap) + Control (hold)
- **Scope**: System-wide console keymap

### Common Issues & Debugging Approaches

#### A. Keymap Loading Failures
**Symptoms**: Caps Lock still functions as Caps Lock, no Escape/Control behavior

**Theoretical Root Causes**:
1. **File Permissions**: Keymap file not readable
2. **rc.conf**: `keymap` setting not applied
3. **Console Type**: Wrong console device

**Debugging Steps**:
```bash
# Check current keymap
kbdcontrol -d

# Test keymap file
kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd

# Check rc.conf
grep keymap /etc/rc.conf

# Test manual loading
kbdcontrol -f /usr/share/syscons/keymaps/baux.kbd
```

#### B. Partial Functionality
**Symptoms**: Only Escape works, or only Control works, not both

**Theoretical Root Causes**:
1. **Keycode Mapping**: Wrong scan codes in keymap
2. **Modifier Conflicts**: Other keyboard modifiers interfering
3. **Application Override**: X11 or desktop environment overriding

**Debugging Steps**:
```bash
# Show keycodes
kbdcontrol -a

# Test in different contexts
# Console: should work
# X11: may be overridden by setxkbmap

# Check X11 keymap
setxkbmap -query
```

#### C. Multi-User Issues
**Symptoms**: Works for root but not for regular users

**Theoretical Root Causes**:
1. **Permissions**: Keymap file permissions
2. **User Context**: Keymap loading per-user vs system-wide
3. **Console Access**: User not having console access

**Debugging Steps**:
```bash
# Check file permissions
ls -la /usr/share/syscons/keymaps/baux.kbd

# Test as different user
su - user -c 'kbdcontrol -d'

# Check console permissions
ls -la /dev/ttyv*
```

### BAUX Keymap Debugging Checklist

1. **File Installation**:
   - Keymap exists: `/usr/share/syscons/keymaps/baux.kbd`
   - Permissions: readable by all
   - Format: valid FreeBSD keymap format

2. **System Configuration**:
   - rc.conf: `keymap="baux"`
   - Console device: correct tty device
   - No conflicts with X11 keymap

3. **Functionality Testing**:
   - Console: Caps tap = Escape, Caps hold = Control
   - X11: May need separate configuration
   - Multi-user: Works for all console users

## INTEGRATION DEBUGGING

### Neovim + Tmux Integration Issues

**Symptoms**: Navigation between neovim splits and tmux panes conflicts

**Debugging Approach**:
```lua
-- In neovim keymaps.lua
vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>', { silent = true })
```

**BAUX-Specific**: Unified `<C-hjkl>` for both vim splits and tmux panes

### Tmux + Keymap Integration Issues

**Symptoms**: Tmux keybindings conflict with system keymap

**Debugging Approach**:
```bash
# Check tmux key bindings
tmux list-keys | grep -i space

# Test prefix in different contexts
# Console vs X11 vs SSH
```

### Full Stack Testing

**Comprehensive Test Suite**:
```bash
#!/bin/bash
# BAUX Integration Test

echo "=== BAUX Integration Test ==="

# Test 1: Keymap
echo "Testing keymap..."
kbdcontrol -d | grep -q baux && echo "✓ Keymap loaded" || echo "✗ Keymap failed"

# Test 2: Tmux
echo "Testing tmux..."
tmux has-session 2>/dev/null && echo "✓ Tmux running" || echo "✗ Tmux not running"

# Test 3: Neovim
echo "Testing neovim..."
nvim --version >/dev/null 2>&1 && echo "✓ Neovim available" || echo "✗ Neovim missing"

# Test 4: Integration
echo "Testing integration..."
# Add specific integration tests

echo "=== Test Complete ==="
```

## PERFORMANCE DEBUGGING

### Startup Time Issues
- **Neovim**: `:Lazy profile` to identify slow plugins
- **Tmux**: Check plugin loading time
- **Keymap**: Minimal impact, but verify loading

### Memory Usage Issues
- **Neovim**: Monitor with `:lua collectgarbage("count")`
- **Tmux**: Check resident memory with `ps`
- **Keymap**: System-level, minimal impact

## CONCLUSION

The BAUX core components (Neovim, Tmux, Keymap) form a tightly integrated stack. Most issues stem from:

1. **Configuration Conflicts**: Keybindings overlapping
2. **Loading Order**: Plugins/deps loading incorrectly
3. **Environment Differences**: Console vs X11 vs SSH
4. **Permission Issues**: File access and user contexts

**Debugging Strategy**:
1. Isolate components (test each separately)
2. Check logs and status commands
3. Verify configurations match BAUX standards
4. Test in different environments
5. Use minimal reproduction cases

This theoretical debugging guide provides systematic approaches for identifying and resolving issues in the BAUX core component stack.