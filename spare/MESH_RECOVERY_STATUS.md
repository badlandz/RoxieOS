# BAUX Mesh Recovery Status Report
**Generated:** 2025-12-10
**Status:** Critical - Mesh broken, recovery in progress

## What Was Broken
1. **Preauth Keys Expired**: All headscale preauth keys expired between 2025-12-10 18:55 and 20:28
2. **Tailscale Logged Out**: Both FreeBSD clients (.101 and .133) have tailscale in "Logged out" state
3. **SSH Issues**: Intermittent SSH connectivity between systems
4. **Wrong Enrollment Method**: Install script used `tailscale up` instead of `headscale register`
5. **Caddy Reverse DNS Bug**: Headscale behind reverse proxy (Caddy) causes DNS lookup timeouts on client IPs, leading to "context exceeded" errors and unresponsive CLI commands

## Current System Status

### Cloud Server (bs.coseismic.org - 207.246.106.130)
- **OS:** FreeBSD 15.0-RELEASE
- **Headscale:** Running, configured for https://bs.coseismic.org
- **Users:** 1 user (ID 1, name "baux-mesh")
- **Nodes:** 2 enrolled (baux01, 01x300) - both offline and expired
- **Keys:** 4 preauth keys, all expired, 2 marked as used
- **SSH:** Working from .101 with public key auth

### FreeBSD Workstation (.101 - 192.168.33.101)
- **OS:** FreeBSD 15.0
- **BAUX:** Installed and functional
- **Tailscale:** Installed (v1.88.3_1), logged out
- **Headscale:** Not installed
- **SSH to Cloud:** Working with public key auth

### FreeBSD Laptop (.133 - 192.168.33.133)
- **OS:** FreeBSD 15.0
- **BAUX:** Installed
- **Tailscale:** Installed (v1.88.3_1), logged out
- **Headscale:** Not installed
- **SSH to Cloud:** Failing (too many auth failures)

### Debian Backup System (Current)
- **Access:** Can SSH to both .101 and .133
- **Cannot SSH to Cloud:** No direct access

## What We've Established to Fix It

### 1. Root Cause Identified
- Mesh was using Tailscale clients connecting to Headscale control server
- Preauth keys expired due to short expiration (24h) in install script
- Clients logged out from Tailscale, breaking mesh connectivity

### 2. Recovery Plan
1. **Create New Preauth Key**: Generate reusable key with long expiration (1 year)
2. **Re-enroll Clients**: Use `tailscale up --login-server https://bs.coseismic.org --auth-key NEW_KEY`
3. **Approve Nodes**: Run `headscale nodes approve` on server
4. **Test Connectivity**: Verify mesh networking works

### 3. Script Fixes Needed
- Change `tailscale up` to `headscale register` in install script
- Use `--user baux-mesh` instead of `--user 1` for key creation
- Increase default key expiration to 8760h (1 year)
- Ensure users running headscale CLI are in the headscale group for socket access
- Configure doas properly for headscale administration

### 4. Working Components
- SSH from .101 to cloud server ✅
- Headscale server operational ✅
- Tailscale clients installed on both systems ✅
- Public key SSH auth working ✅

### 5. Recovery Results - MESH FULLY RESTORED ✅
**Completed Successfully:**
1. ✅ **Fixed Permissions**: Added badlandz to headscale group for socket access
2. ✅ **Generated new preauth key** on cloud server (1-year reusable)
3. ✅ **Enrolled clients** with doas tailscale commands
4. ✅ **Approved nodes** on headscale server
5. ✅ **Verified mesh connectivity** (0% packet loss, direct peer links)
6. ✅ **Restored baux-bot** in immortal tmux session with loaded RAG

**Current Status:**
- **Mesh**: Fully operational with 2 nodes online
- **Baux-Bot**: Running in persistent session with RAG loaded
- **Connectivity**: Direct peer-to-peer links established
- **Security**: Proper permissions configured

### 6. Future Prevention
- Update install scripts with proper doas configuration
- Implement automated key rotation
- Add mesh health monitoring
- Document emergency recovery procedures

## Recovery Commands

### Recovery Commands Used (Successfully):
```bash
# On Cloud Server (as root):
pw groupmod headscale -m badlandz  # Add user to group
headscale preauthkeys create --user 1 --reusable --expiration 8760h  # Create 1-year key

# On Each Client (as badlandz):
doas tailscale up --login-server https://bs.coseismic.org --auth-key KEY_HERE

# Approve nodes on server:
headscale nodes approve NODE_NAME
```

### Verification Commands:
```bash
tailscale status          # Client status
tailscale ip -4           # Get mesh IP
ping MESH_IP              # Test connectivity
headscale nodes list      # Server node status
tmux attach-session -t baux-bot-session  # Access baux-bot
```

## Risk Mitigation
- Backup this status report
- Test each step individually
- Have SSH access ready for troubleshooting
- Monitor for key expiration

## Contact Info
- Cloud Server: bs.coseismic.org (207.246.106.130)
- FreeBSD WS: 192.168.33.101
- FreeBSD LT: 192.168.33.133