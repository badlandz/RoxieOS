# BAUX .133 (x300 Laptop) Shakedown Test List
**Date:** December 10, 2025
**System:** .133 (x300 laptop) - FreeBSD 15
**Purpose:** Verify BAUX resurrection deployment and full functionality

## Pre-Test Setup
```bash
# Ensure clean state
tmux kill-server 2>/dev/null || true
rm -f ~/.tmux.conf 2>/dev/null || true
```

## 1. BAUX Startup & Configuration Tests

### 1.1 Basic BAUX Launch
```bash
baux
# EXPECTED: tmux starts with BAUX config
# - Status bar on TOP (not bottom)
# - C-Space prefix responds (shows indicator)
# - Window shows: main (1 pane)
```

### 1.2 Configuration Verification
```bash
# In tmux, check settings:
tmux show-options -g | grep prefix
# EXPECTED: prefix C-Space

tmux show-options -g | grep status-position
# EXPECTED: status-position top

tmux show-options -g | grep mouse
# EXPECTED: mouse on
```

### 1.3 Session Information
```bash
tmux display-message "#S:#I.#P"
# EXPECTED: Shows session:window.pane info
# Example: baux-01x300:1.1
```

## 2. Keymap & Navigation Tests

### 2.1 Prefix Key Test
```bash
# Press C-Space (Ctrl+Space)
# EXPECTED: Status bar shows "PREFIX" indicator briefly
```

### 2.2 Window Management
```bash
# C-Space + c (new window)
# EXPECTED: New window created, tab appears at top

# C-Space + n (next window)
# EXPECTED: Switches to next window

# C-Space + p (previous window)
# EXPECTED: Switches to previous window

# C-Space + , (rename window)
# EXPECTED: Prompt appears to rename window
```

### 2.3 Pane Management
```bash
# C-Space + % (vertical split)
# EXPECTED: Pane splits vertically

# C-Space + " (horizontal split)
# EXPECTED: Pane splits horizontally

# C-Space + h/j/k/l (pane navigation)
# EXPECTED: Moves between panes (vim-style navigation)

# C-Space + H/J/K/L (pane resize)
# EXPECTED: Resizes panes by 5 units
```

### 2.4 Session Management
```bash
# C-Space + d (detach)
# EXPECTED: Returns to shell, tmux session persists

# C-Space + s (session list)
# EXPECTED: Shows session selector
```

## 3. Plugin Integration Tests

### 3.1 Plugin Installation Check
```bash
ls -la /usr/local/share/baux/tmux-plugins/
# EXPECTED: tpm/, tmux-resurrect/, tmux-continuum/ directories

ls -la /usr/local/share/baux/tmux-plugins/tmux-resurrect/
# EXPECTED: Plugin files present
```

### 3.2 Plugin Loading Verification
```bash
# In tmux:
tmux show-options -g | grep resurrect
# EXPECTED: resurrect-dir /var/tmp/baux-resurrect

tmux show-options -g | grep continuum
# EXPECTED: continuum-restore on, continuum-save-interval 10
```

### 3.3 TPM Status
```bash
# Check if TPM is running
ps aux | grep tpm
# EXPECTED: May show TPM process or be background
```

## 4. Resurrection Functionality Tests

### 4.1 Manual Save Test
```bash
# Create test content
echo "RESURRECTION TEST - $(date)" > /tmp/resurrection-test.txt
cat /tmp/resurrection-test.txt

# Manual save (should happen automatically every 10 min)
# C-Space + : then type: run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
```

### 4.2 Resurrection Test
```bash
# Detach from session: C-Space + d

# Kill the session
tmux kill-session -t $(tmux ls | grep attached | cut -d: -f1)

# Restart BAUX
baux

# Check if content restored
ls -la /tmp/resurrection-test.txt
cat /tmp/resurrection-test.txt
# EXPECTED: File exists with original content
```

### 4.3 Automatic Saving
```bash
# Wait 10+ minutes or force save
# C-Space + : then: set -g @continuum-save-interval 1
# Wait 1 minute, check /var/tmp/baux-resurrect/ for save files
ls -la /var/tmp/baux-resurrect/
# EXPECTED: Save files created
```

## 5. AI Integration Tests

### 5.1 Baux-Bot Startup
```bash
# Start baux-bot
baux-bot daemon &
# EXPECTED: Starts without errors

# Check if running
ps aux | grep baux-bot
# EXPECTED: baux-bot process visible
```

### 5.2 Socket Communication
```bash
# Test socket connection
echo "test query" | nc -U /tmp/baux-bot.sock
# EXPECTED: AI response or error message
```

### 5.3 Pane Integration
```bash
# In tmux, create new pane/window
# C-Space + c (new window)
# In new window: baux-bot interactive
# EXPECTED: AI chat interface starts
```

## 6. Cross-System Session Tests

### 6.1 Session Discovery
```bash
# Check local sessions
tmux ls
# EXPECTED: Shows baux-01x300 session

# Check remote connectivity (if mesh active)
ping 192.168.33.101  # baux01
ping 192.168.33.133  # self
# EXPECTED: Mesh connectivity working
```

### 6.2 Session Switching (Future)
```bash
# These will work once registry is implemented:
baux list          # List all mesh sessions
baux switch session-name [node]  # Switch to session
baux pull session-name node      # Pull remote session
```

## 7. Performance & Stability Tests

### 7.1 Memory Usage
```bash
# Check tmux memory
ps aux | grep tmux
# EXPECTED: Reasonable memory usage (< 50MB)

# Check baux-bot memory
ps aux | grep baux-bot
# EXPECTED: AI process running, reasonable memory
```

### 7.2 Session Persistence
```bash
# Detach, logout, SSH back in
# EXPECTED: tmux session still running
tmux attach-session -t $(tmux ls | head -1 | cut -d: -f1)
# EXPECTED: Reattaches to existing session
```

## 8. Error Handling Tests

### 8.1 Plugin Failure Recovery
```bash
# Temporarily break a plugin
mv /usr/local/share/baux/tmux-plugins/tmux-resurrect /usr/local/share/baux/tmux-plugins/tmux-resurrect.bak

# Restart tmux
baux
# EXPECTED: tmux starts but resurrection disabled

# Restore plugin
mv /usr/local/share/baux/tmux-plugins/tmux-resurrect.bak /usr/local/share/baux/tmux-plugins/tmux-resurrect
```

### 8.2 Network Disconnection
```bash
# Disconnect network briefly
# EXPECTED: Local sessions continue working
# Reconnect: Sessions should sync when mesh active
```

## 9. Documentation & Reporting

### 9.1 Test Results Summary
```bash
# After all tests, document:
echo "BAUX .133 Shakedown - $(date)"
echo "✅ PASSED: [list]"
echo "❌ FAILED: [list]"
echo "🔄 PARTIAL: [list]"
echo "📝 NOTES: [observations]"
```

### 9.2 Issue Reporting
- **Keymaps not working**: Check tmux.conf loading
- **Resurrection fails**: Verify plugin installation
- **AI not responding**: Check socket permissions
- **Performance issues**: Monitor resource usage

## Expected Test Duration: 30-45 minutes

## Success Criteria
- ✅ BAUX starts with correct configuration
- ✅ All keymaps respond properly
- ✅ Resurrection saves/restores content
- ✅ Plugins load and function
- ✅ AI integration works
- ✅ Session persistence across disconnects
- ✅ No crashes or major issues

## Emergency Recovery
If BAUX breaks completely:
```bash
# Clean reinstall
cd /src/RoxieOS/ports/baux
./install.sh

# Or rollback to working commit
cd /src/RoxieOS
git reset --hard HEAD~1  # If needed
./install.sh
```</content>
<parameter name="filePath">/src/RoxieOS/133-SHAKEDOWN-TEST-LIST.md