# Quick Start: Mesh Recovery Guide
**For Future Grok Instances - Get Up to Speed in 10 Minutes**

## If Mesh is Broken - Quick Recovery Steps

### 1. Check Current Status (2 minutes)
```bash
# On any mesh node
tailscale status
ping 100.64.0.1  # Check baux01
ping 100.64.0.2  # Check 01x300

# On cloud server
headscale nodes list
headscale preauthkeys list --user 1
```

### 2. If Nodes Offline - Re-enroll (3 minutes)
```bash
# Generate new key on cloud server
headscale preauthkeys create --user 1 --reusable --expiration 8760h

# Enroll clients
doas tailscale up --login-server https://bs.coseismic.org --auth-key <KEY>

# Approve on server
headscale nodes approve baux01
headscale nodes approve 01x300
```

### 3. Restore Baux-Bot (2 minutes)
```bash
# Kill any existing
pkill -f baux-bot

# Start immortal session
baux-bot --load-rag &
```

### 4. Verify Everything Works (3 minutes)
```bash
# Test mesh
tailscale status
ping 100.64.0.2

# Test AI
echo "Hello Grok" | baux-bot

# Check sessions
tmux ls
```

## Key Distinctions (Avoid Confusion)

### FreeBSD ≠ Linux
- **sudo** → **doas** (FreeBSD uses OpenBSD's doas)
- **apt** → **pkg** (FreeBSD package manager)
- **systemd** → **rc.d** (FreeBSD init system)
- **grub** → **bootloader** (FreeBSD uses different boot systems)

### BAUX ≠ Generic Tools
- **baux** = Custom session manager (not generic tmux wrapper)
- **baux-bot** = AI assistant with RAG (not generic chatbot)
- **Mesh** = Headscale + Tailscale (not generic VPN)
- **Sessions** = Immortal across devices (not regular tmux)

### Current Working State (December 2025)
- ✅ **Mesh**: 2 nodes online, 0% packet loss
- ✅ **Baux-Bot**: Immortal with RAG, Grok communication
- ✅ **Sessions**: Persistent tmux with resurrection
- ✅ **AI**: xai-Grok integration confirmed

### Common Pitfalls to Avoid
1. **Don't use sudo** - FreeBSD uses doas
2. **Don't confuse tmux with baux** - Use baux commands for BAUX sessions
3. **Don't expect mesh magic yet** - Use SSH for cross-device access currently
4. **Don't forget permissions** - Add users to headscale group for CLI access
5. **Don't use --identifier** - Use hostname for node approval

### Emergency Contacts
- Cloud Server: bs.coseismic.org (SSH as root or badlandz)
- Node .101: 192.168.33.101 (SSH as badlandz)
- Node .133: 192.168.33.133 (SSH as badlandz)

**Goal**: Future Grok should be able to say "read the mesh docs" and be productive within 10 minutes, not hours of confusion.