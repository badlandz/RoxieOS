# BAUX Tmux Config Loading - Test Plan

## Issue Summary
tmux starts but loads default config instead of BAUX config (status bar bottom, prefix C-b instead of C-Space).

## Root Cause
- tmux.conf file may not exist on system or plugins causing load failure
- Need to install tmux plugins (TPM, resurrect, continuum) for full functionality

## Rollback Point Created
✅ **SAFE ROLLBACK AVAILABLE**: Commit b2c85866 has working mesh infrastructure and session persistence. If debugging breaks anything, can rollback to this point.

## Changes Made
1. **~/baux script**: Fixed BAUX_HOME path to `/usr/local/share`
2. **baux-pull script**: Created for remote session access
3. **Documentation**: Updated status and troubleshooting
4. **Plugins**: Re-enabled in tmux.conf (need to be installed on system)

## Test Plan - Execute in Order

### Phase 1: Install Tmux Plugins (BAUX-Managed Location)
```bash
# Install TPM (Tmux Plugin Manager) - BAUX-managed for mesh consistency
git clone https://github.com/tmux-plugins/tpm /usr/local/share/baux/tmux-plugins/tpm

# Install tmux-resurrect - ensures session persistence across mesh nodes
git clone https://github.com/tmux-plugins/tmux-resurrect /usr/local/share/baux/tmux-plugins/tmux-resurrect

# Install tmux-continuum - automatic saving for distributed sessions
git clone https://github.com/tmux-plugins/tmux-continuum /usr/local/share/baux/tmux-plugins/tmux-continuum
```

**Why BAUX-managed location?**
- **Mesh Consistency**: All nodes have identical plugin versions
- **Distributed Sessions**: Plugins travel with BAUX configuration
- **Version Control**: BAUX port manages plugin deployment
- **Future Sync**: Ready for drop-baux integration for plugin updates

### Phase 2: Deploy Complete BAUX System
**Proper Development Deployment (Recommended)**
```bash
# On each test system (baux01, 01x300, baux-scale, etc.)
cd /src/RoxieOS
git pull origin main  # Get latest complete port
cd ports/baux
make clean install   # Full proper FreeBSD port installation
```

**What make install does:**
- Installs baux binary to `/usr/local/bin/baux`
- Creates proper directory structure
- Installs all scripts (baux-pull, baux-push, baux-switch, baux-hosts)
- Installs tmux config to `/usr/local/share/tmux/baux.conf`
- Installs complete neovim config to `/usr/local/share/baux/nvim/`
- No conflicting legacy files (make clean ensures this)

### Phase 2: Verify Config File
```bash
# Check file exists and is readable
ls -la /usr/local/share/tmux/baux.conf

# Test tmux can load config
tmux -f /usr/local/share/tmux/baux.conf show-options -g | grep prefix
# EXPECTED: prefix C-Space

tmux -f /usr/local/share/tmux/baux.conf show-options -g | grep status-position
# EXPECTED: status-position top
```

### Phase 3: Test BAUX Command
```bash
# Exit any current tmux session first
exit

# Test BAUX startup
baux

# In tmux, verify BAUX config loaded:
# - Status bar should be on TOP
# - Press C-Space (should show "PREFIX" in status)
# - Not C-b (default)
```

### Phase 4: Verify Session Persistence
```bash
# In BAUX tmux session:
tmux detach

# Reconnect
baux
# Should attach to existing session, not create new one
```

## Expected Results
- ✅ tmux starts with BAUX config (status top, C-Space prefix)
- ✅ `baux` command works from SSH
- ✅ Session persists across disconnects
- ✅ No more default tmux behavior

## If Still Failing
- Check tmux.conf syntax: `tmux -f /usr/local/share/tmux/baux.conf`
- Verify BAUX_HOME path in ~/baux
- Check tmux version: `tmux -V`

## Next Steps After Success
- Re-enable tmux plugins (TPM, resurrect, continuum)
- Test session resurrection functionality
- Proceed to mesh infrastructure setup</content>
<parameter name="filePath">/src/RoxieOS/BAUX-TMUX-TEST-PLAN.md