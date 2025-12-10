# BAUX Mesh Architecture
**Distributed Session Management with Headscale**

This mesh architecture supports the core vision of connecting to your IDE from ANY system via BAUX-MESH for distributed development.

## Overview

**WORKING MESH ACHIEVED!** BAUX Mesh transforms workstation cloning from local USB-based recovery into a distributed, always-available session ecosystem. Using Headscale (self-hosted Tailscale control server), BAUX creates a secure mesh network where sessions persist across devices and locations.

**Current Status (December 2025):** Mesh is operational with 2 nodes (baux01/01x300) showing 0% packet loss and direct peer connectivity. Baux-bot runs immortal with RAG loaded, communicating via xai-Grok integration.

## Core Concepts

### Session Distribution
**Traditional Approach:** Sessions tied to specific hardware via USB backup
**BAUX Mesh Approach:** Sessions exist as network resources, accessible from any enrolled device

### Device Roles (Current Implementation)
- **Baux-Scale Server:** Cloud VPS (bs.coseismic.org) running Headscale control server ✅ OPERATIONAL
- **BAUX LAN Server:** FreeBSD server with service jails (planned for Phase 3)
- **BAUX Client:** FreeBSD workstations enrolled via Tailscale ✅ baux01 (.101) and 01x300 (.133) ONLINE
- **BAUX Backup Server:** Future RoxieOS install for ZFS backups across mesh
- **BAUX Relay:** Optional intermediate nodes for complex network topologies

**Active Mesh Nodes:**
- baux01 (192.168.33.101) → Mesh IP: 100.64.0.1 ✅ Online
- 01x300 (192.168.33.133) → Mesh IP: 100.64.0.2 ✅ Online

### Authentication Model
- **Headscale Control:** Device identity and access control via mesh networking
- **Session ACLs:** Granular permissions for session access between users/devices
- **Zero-Trust:** All session traffic encrypted end-to-end via WireGuard

## Architecture Layers

```
┌─────────────────┐
│   BAUX Mesh     │ ← Distributed session management
├─────────────────┤
│  Headscale      │ ← Authentication & networking
├─────────────────┤
│  WireGuard      │ ← Encrypted device connectivity
├─────────────────┤
│ Session Registry│ ← Location tracking & coordination
└─────────────────┘
```

## Headscale Integration

### Control Plane Setup
**Domain:** `hs.coseismic.org` (configurable)
**Server Location:** Cloud VPS (Vultr $6-12/month) or LAN server
**Authentication:** Device pre-authorization with ACL policies

### Device Enrollment (Tested & Working)
```bash
# On FreeBSD client (requires doas setup)
doas tailscale up --login-server https://bs.coseismic.org --auth-key <preauth-key>

# On server (approve the node)
headscale nodes approve <hostname>  # e.g., headscale nodes approve baux01

# Verify connectivity
tailscale status
ping <mesh-ip>  # e.g., ping 100.64.0.2
```

**Key Lessons Learned:**
- Use `doas` on FreeBSD (not `sudo`)
- Node approval uses hostname, not --identifier flag
- Preauth keys expire (use 8760h for 1 year)
- Add users to headscale group for CLI socket access

### Roaming Session Discovery
- **LAN Probing**: RoxieOS boot probes local network (port 9999) for active BAUX sessions; offers login/clone if found
- **Phone Home**: Connect to baux-scale domain/IP for full mesh session list; select and resurrect sessions globally
- **Session Selection**: TUI interface presents available sessions from LAN or mesh for user choice

### Network Topology
- **Full Mesh:** All devices can communicate directly
- **NAT Traversal:** Automatic hole-punching for connectivity
- **DERP Relays:** Cloud fallback for complex network scenarios

## Session Management

### Distributed Sessions
**Creation:** Sessions can be created on any device and become mesh resources
**Migration:** Move active sessions between devices seamlessly via peer-to-peer sync
**Multi-Access:** View same session from multiple devices simultaneously
**Persistence:** Sessions survive device failures via peer-to-peer replication

### Session States
- **Active:** Running on specific device with peer-to-peer sync
- **Suspended:** Paused state, resumable on any device via registry lookup
- **Archived:** Historical snapshots stored locally on devices
- **Shared:** Collaborative sessions with access controls

## Implementation Phases (Updated Status)

### Phase 1: Headscale Foundation ✅ COMPLETE
**Goal:** Establish secure mesh networking
- ✅ Deploy Headscale server on Vultr VPS (bs.coseismic.org)
- ✅ Configure domain and certificates
- ✅ Set up initial ACL policies
- ✅ Test device enrollment (2 nodes online, 0% packet loss)

### Phase 2: Session Distribution 🔄 CURRENT
**Goal:** Basic session sharing across devices
- ✅ Implement peer-to-peer connectivity (direct links confirmed)
- ✅ Add session location registry on server (nodes approved)
- 🔄 Create session discovery (currently SSH-based, mesh discovery planned)
- ✅ Test basic connectivity (ping works, file transfer tested)

### Phase 3: Advanced Features (Next Milestone)
**Goal:** Full distributed session ecosystem
- 🔄 Multi-device simultaneous access (SSH works, mesh sessions planned)
- 🔄 Collaborative session features (baux-bot immortal, RAG loaded)
- 🔄 Advanced ACL management
- 🔄 Performance optimization (sub-1ms latency achieved)

**Phase 2.5: AI Integration ✅ COMPLETE**
- Baux-bot immortal in persistent tmux session
- RAG system active with repo monitoring
- xai-Grok communication confirmed
- Multi-backend support (Grok/Ollama)

## Server Requirements

### Minimum Cloud VPS
- **Provider:** Vultr Cloud Compute ($6-12/month)
- **CPU:** 1 vCPU (sufficient for Headscale + registry coordination)
- **RAM:** 1GB (Headscale ~50MB + minimal registry processing)
- **Storage:** 25GB SSD (registry data + logs, no session storage)
- **Bandwidth:** 1TB/month (minimal coordination traffic)
- **OS:** FreeBSD 15.0 (excellent support)

### Scaling Considerations
- **Growth Path:** Upgrade to 2GB RAM plan ($12/month) for increased registry capacity
- **Multi-Server:** Additional VPS for geographic distribution of registry
- **Load Balancing:** Distribute registry lookups across multiple servers

## Security Model

### Authentication
- **Device Keys:** Cryptographic identity for each BAUX device
- **User Identity:** Integration with existing authentication systems
- **Session Tokens:** Time-limited access to specific sessions

### Access Control
- **ACL Policies:** Define which users can access which sessions
- **Device Groups:** Organize devices by trust levels
- **Session Permissions:** Read-only vs. read-write access

### Encryption
- **WireGuard:** End-to-end encryption for all mesh traffic
- **Session Data:** Encrypted at rest and in transit
- **Key Management:** Automatic key rotation and renewal

## Network Architecture

### Connectivity Models
- **Direct Peer:** Devices communicate directly for session sync when possible
- **NAT Traversal:** Automatic relay for firewall traversal
- **DERP Servers:** Cloud relays for complex network scenarios
- **Registry Queries:** Lightweight server lookups for session locations

### Performance Optimization
- **Connection Pooling:** Reuse established connections
- **Compression:** Reduce bandwidth for session state sync
- **Caching:** Local session state caching for offline work
- **Quality of Service:** Prioritize active session traffic

## Migration Strategy

### From Local to Mesh
1. **Export Existing Sessions:** Convert local tmux sessions to mesh format
2. **Device Enrollment:** Register existing devices with Headscale
3. **Session Upload:** Migrate session state to mesh storage
4. **Access Migration:** Update local scripts to use mesh sessions

### Backward Compatibility
- **Local Fallback:** Devices can operate without mesh connectivity
- **Hybrid Mode:** Mix local and mesh sessions as needed
- **Gradual Migration:** Move sessions to mesh incrementally

## Troubleshooting

### Common Issues
- **Connection Failures:** Check Headscale server status and ACLs
- **Session Discovery Issues:** Verify registry connectivity and location updates
- **Performance Problems:** Monitor peer-to-peer bandwidth and registry response times

### Diagnostic Tools
- `baux mesh status` - Check mesh connectivity
- `baux mesh registry` - Query session locations
- `headscale nodes list` - View enrolled devices

## Future Extensions

### Advanced Features
- **Session Recording:** Historical playback of session activity
- **Collaborative Editing:** Real-time shared terminal sessions
- **Resource Pooling:** Distribute compute across mesh devices
- **AI Integration:** Intelligent session suggestions and automation

### Ecosystem Growth
- **Mobile Clients:** Access sessions from smartphones/tablets
- **Web Interface:** Browser-based session access
- **API Integration:** Third-party tool integration
- **Multi-Platform:** Windows/macOS client support

## Conclusion

BAUX Mesh transforms personal computing from device-centric to session-centric. By leveraging Headscale's battle-tested mesh networking, BAUX creates a distributed computing environment where your digital workspace follows you seamlessly across all your devices.

**Start Small:** Begin with a single cloud server and local device, then expand as your needs grow.

**References:**
- [Headscale Documentation](https://headscale.net/)
- [Tailscale Concepts](https://tailscale.com/blog/how-tailscale-works)
- [Vultr Cloud Compute](https://www.vultr.com/pricing/#cloud-compute)