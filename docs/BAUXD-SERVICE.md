# BAUX Daemon (bauxd) - Service Architecture

## Overview

bauxd is the BAUX daemon service that provides a clean REST API on port 9999 for distributed BAUX operations. It replaces ad-hoc SSH-based approaches with a proper service architecture for mesh coordination, session management, and future BAUX ecosystem features.

## Current Use Needs (Phase 1)

### Session Discovery & Switching
**Primary Goal:** Enable clean remote session discovery and switching across BAUX-MESH

#### API Endpoints
```
GET  /sessions              # List available tmux sessions on this node
GET  /sessions/{name}       # Get session details (panes, windows, metadata)
POST /sessions/{name}/attach # Attach to session (for remote clients)
POST /sessions/{name}/clone  # Clone session to requesting node
GET  /health               # Service health and node status
GET  /peers                # List mesh peers (via headscale integration)
```

#### Integration with TUI
- TUI queries `bauxd` on each mesh node for available sessions
- Clean JSON responses replace ping-based discovery
- Proper error handling and timeouts
- Authentication via mesh certificates

## Architecture

### Service Design
```bash
bauxd (port 9999)
├── HTTP REST API (JSON)
├── Local tmux integration
├── BAUX-MESH peer discovery
├── Service health monitoring
└── Extensible plugin system
```

### Security Model
- **Mesh Authentication:** Uses Tailscale certificates for peer verification
- **Local Access:** Unix socket for local privileged operations
- **Rate Limiting:** Prevents abuse from mesh peers
- **Access Control:** Configurable peer permissions

### Configuration
```json
{
  "port": 9999,
  "mesh_auth": true,
  "rate_limit": 100,
  "allowed_peers": ["*"],
  "log_level": "info",
  "tmux_socket": "/tmp/tmux-$(id -u)/default"
}
```

## Future Expansion Ideas (Phase 2+)

### File Synchronization
```
POST /files/sync           # Coordinate rsync/git operations
GET  /files/status         # Sync status across nodes
POST /files/transfer       # Secure file transfer
```

### Collaborative Features
```
POST /sessions/share       # Share session with specific peers
GET  /sessions/active      # List shared sessions
POST /sessions/join        # Join collaborative session
```

### Service Discovery
```
GET  /services             # List available BAUX services
POST /services/register    # Register new service
DELETE /services/{id}      # Unregister service
```

### Monitoring & Analytics
```
GET  /metrics              # Service performance metrics
GET  /logs                 # Structured logging API
POST /alerts               # Send alerts to mesh
```

### Backup Coordination
```
POST /backup/init          # Start coordinated backup
GET  /backup/status        # Backup progress across nodes
POST /backup/restore       # Coordinated restore operation
```

## Implementation Plan

### Phase 1: Session Switching (Current Focus)
1. **Basic HTTP Service** - socat-based REST API
2. **Session Discovery** - tmux session enumeration
3. **Mesh Integration** - Peer discovery via headscale
4. **TUI Integration** - Replace ping-based discovery
5. **Security** - Mesh certificate authentication

### Phase 2: File Operations
1. **Rsync Coordination** - Distributed file sync API
2. **Git Operations** - Multi-node repository management
3. **Backup System** - Coordinated backup/restore

### Phase 3: Advanced Collaboration
1. **Session Sharing** - Real-time collaborative sessions
2. **Service Registry** - Dynamic service discovery
3. **Monitoring** - Centralized health and metrics

## Technical Implementation

### Current Stack
- **Language:** Bash + socat for HTTP
- **Data Format:** JSON responses
- **Authentication:** Tailscale mesh certificates
- **Integration:** Direct tmux socket access

### Future Stack (Phase 2)
- **Language:** Python/Go microservice
- **Database:** SQLite for session metadata
- **Web Framework:** FastAPI/Chi for REST API
- **Security:** Mutual TLS with mesh certificates

## Benefits Over SSH Approach

### Scalability
- **Service Discovery:** Clean API vs SSH key management
- **Rate Limiting:** Built-in protection vs SSH abuse
- **Monitoring:** Service metrics vs SSH log parsing

### Maintainability
- **Centralized Logic:** Single service vs distributed scripts
- **Version Control:** API versioning vs script compatibility
- **Testing:** Unit tests vs integration testing

### Security
- **Certificate Auth:** Mesh certificates vs SSH keys
- **Access Control:** Configurable permissions vs all-or-nothing
- **Audit Logging:** Structured logs vs SSH logs

### Extensibility
- **Plugin System:** Easy feature addition vs script modification
- **API Evolution:** Backward compatibility vs breaking changes
- **Multi-Language:** Any language can use API vs bash-only

## Deployment Strategy

### Initial Rollout
1. **Single Node:** Deploy on baux-scale for testing
2. **API Validation:** Test all endpoints with TUI
3. **Mesh Testing:** Verify peer discovery works
4. **Security Audit:** Validate authentication

### Production Deployment
1. **Staged Rollout:** Deploy to one node at a time
2. **Backward Compatibility:** Keep SSH fallback during transition
3. **Monitoring:** Watch service health and usage
4. **Documentation:** Update all guides for new API

## Migration Path

### From SSH-Based Approach
1. **Parallel Operation:** Run both SSH and bauxd during transition
2. **Feature Parity:** Ensure bauxd provides all SSH functionality
3. **User Migration:** Update tools to use new API
4. **Deprecation:** Phase out SSH approach after validation

### Tool Updates Needed
- **baux-pull:** Use `POST /sessions/{name}/attach` instead of SSH
- **baux-push:** Use `POST /sessions/{name}/clone` instead of SSH
- **TUI:** Query `/sessions` on all mesh nodes
- **Monitoring:** Use `/health` and `/metrics` endpoints

## Success Criteria

### Phase 1 Success
- ✅ TUI discovers sessions via bauxd API
- ✅ Remote session switching works reliably
- ✅ Mesh authentication functions properly
- ✅ Service starts automatically on boot
- ✅ Proper error handling and logging

### Long-term Success
- ✅ Extensible API for future BAUX features
- ✅ Reliable service across all mesh nodes
- ✅ Security model prevents unauthorized access
- ✅ Performance meets user expectations
- ✅ Easy maintenance and updates

## Conclusion

bauxd represents the evolution from ad-hoc distributed operations to a proper service-oriented architecture. Starting with session switching as the foundation, it provides a scalable platform for all future BAUX mesh coordination needs.

The SSH-based approach got us working quickly, but bauxd will provide the robust, maintainable foundation for the BAUX ecosystem's continued growth.</content>
<parameter name="filePath">docs/BAUXD-SERVICE.md