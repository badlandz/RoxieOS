# BAUX Service Consolidation Plan
**Consolidating bauxd, baux-registry, and BAUX-BOT for Unified Mesh Intelligence**

## Executive Summary

Following architectural analysis, BAUX services will be consolidated into `bauxd` as the central mesh coordination service. This eliminates redundancy between `bauxd` and `baux-registry`, enables hardware-aware workload distribution, and creates a unified platform for the BAUX ecosystem.

## Current State Analysis

### Service Overlap Identified
- **bauxd**: HTTP REST API (port 9999), session management, service discovery, health monitoring
- **baux-registry**: File-based session registry (JSON files in /var/db/baux/)
- **BAUX-BOT v2.0**: Distributed AI with duplicate service discovery logic

### Redundancy Issues
- Session tracking duplicated between bauxd and baux-registry
- Service discovery reimplemented in BAUX-BOT instead of using centralized bauxd
- Hardware monitoring missing from all services despite being critical for workload distribution

## Consolidation Strategy

### Phase 1: Core Consolidation (Week 1-2) ✅ COMPLETE
**Goal:** Establish bauxd as single source of truth for sessions and services

#### 1.1 Extend bauxd with SQLite Backend ✅ IMPLEMENTED
- ✅ Migrated from file-based to SQLite database using consolidated schema
- ✅ Added session CRUD operations to bauxd API
- ✅ Maintained file-based compatibility during transition

#### 1.2 Deprecate baux-registry ✅ IMPLEMENTED
- ✅ Created migration scripts to move existing sessions to database
- ✅ Updated bauxd to use SQLite backend for all operations
- ✅ Maintained backward compatibility during transition

#### 1.3 Add Hardware Monitoring to bauxd ✅ IMPLEMENTED
- ✅ `/hardware` endpoint: CPU, memory, disk, network stats per node
- ✅ Real-time hardware monitoring with psutil integration
- ✅ Hardware data collection and API exposure
- ⏸️ `/workload` endpoint: Intelligent task distribution (Phase 2)

**Phase 1 Results:**
- bauxd v2.0 with SQLite backend operational
- Hardware monitoring collecting real-time data
- Session migration from files to database successful
- HTTP API endpoints tested and working
- 2 existing sessions successfully migrated

### Phase 2: Service Discovery Integration (Week 3-4) 🔄 IN PROGRESS
**Goal:** Standardize BAUX-BOT discovery and add mesh intelligence

#### 2.1 Standardize BAUX-BOT Discovery
- Remove duplicate discovery logic from BAUX-BOT v2.0
- Implement proper bauxd client in BAUX-BOT
- Add service registration endpoints to bauxd

#### 2.2 Add AI Service Registry to bauxd
- `/ai/services` endpoint: Register/discover AI backends across mesh
- `/ai/route` endpoint: Intelligent routing based on query type and hardware
- Integration with BAUX-BOT load balancing logic

#### 2.3 Enhanced Mesh Coordination
- Cross-node session migration via bauxd
- Hardware-aware load balancing for AI workloads
- Predictive resource allocation based on usage patterns

### Phase 3: Advanced Features (Week 5-6)
**Goal:** Complete unified mesh intelligence platform

#### 3.1 Monitoring & Analytics
- Service performance metrics collection
- Hardware utilization tracking across mesh
- AI usage analytics and optimization

#### 3.2 Backup Coordination
- Coordinated backup/restore operations
- Session state synchronization
- Cross-node data consistency

#### 3.3 API Evolution
- Service registry for BAUX ecosystem components
- Collaborative session management
- Advanced mesh monitoring and alerting

## Implementation Details

### Code Changes Required

#### bauxd Extensions (~500 lines)
```python
# Add to bauxd service
- SQLite database integration
- Hardware monitoring endpoints
- AI service registry
- Enhanced session management
```

#### BAUX-BOT Modifications (~300 lines)
```python
# Remove duplicate code (~200 lines)
- Custom service discovery logic
- Redundant session tracking

# Add proper integration (~100 lines)
- bauxd client implementation
- Hardware-aware routing
- Centralized service discovery
```

#### baux-registry Deprecation
- Maintain as compatibility shim for 6 months
- Add deprecation warnings
- Redirect to bauxd API calls

### Database Schema (SQLite)
```sql
-- Sessions table (enhanced from baux-registry)
CREATE TABLE sessions (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE,
    node TEXT,
    pid INTEGER,
    status TEXT DEFAULT active,
    hardware_requirements TEXT,  -- JSON for AI workload requirements
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Hardware monitoring table
CREATE TABLE hardware_stats (
    id INTEGER PRIMARY KEY,
    node TEXT,
    cpu_percent REAL,
    memory_percent REAL,
    disk_usage REAL,
    network_io REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- AI services registry
CREATE TABLE ai_services (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE,
    node TEXT,
    type TEXT,  -- ollama, grok, claude, etc.
    capabilities TEXT,  -- JSON array of capabilities
    status TEXT DEFAULT active,
    load_factor REAL DEFAULT 0.0,
    last_seen DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### API Extensions

#### Hardware Monitoring
```
GET  /hardware/{node}     # Node hardware stats
GET  /hardware/mesh       # All mesh hardware stats
POST /hardware/report     # Node reports hardware stats
```

#### AI Service Registry
```
GET    /ai/services       # List all AI services
POST   /ai/services       # Register AI service
DELETE /ai/services/{id}  # Unregister AI service
GET    /ai/route          # Intelligent routing recommendation
```

#### Enhanced Sessions
```
GET    /sessions/hardware # Sessions with hardware requirements
POST   /sessions/migrate  # Migrate session to optimal node
GET    /sessions/workload # Workload distribution analysis
```

## Benefits Achieved

### Efficiency Gains
- **Single Source of Truth**: No more duplicate session tracking
- **Centralized Intelligence**: Hardware-aware workload distribution
- **Simplified Deployment**: One service instead of three
- **Reduced Maintenance**: Unified codebase and API

### Enhanced Capabilities
- **Hardware Monitoring**: Real-time resource tracking across mesh
- **Intelligent Routing**: AI workload optimization based on hardware capabilities
- **Unified API**: Single interface for all BAUX mesh operations
- **Future-Proof**: Extensible platform for advanced mesh features

### Project Vision Support
- **USB/SD Boot**: Simplified deployment with single service dependency
- **Minimal Hardware**: Hardware monitoring enables optimal resource utilization
- **AI-Assisted IDE**: Intelligent distribution of AI workloads across mesh
- **Mesh Intelligence**: Centralized coordination for distributed operations

## Migration Strategy

### Backward Compatibility
- File-based registry remains readable during transition
- baux-registry commands redirect to bauxd API with warnings
- BAUX-BOT continues working during consolidation

### Rollback Plan
- Each phase can be rolled back independently
- File-based registry preserved as fallback
- Service can operate in degraded mode if needed

### Testing Approach
- Unit tests for each new bauxd endpoint
- Integration tests for BAUX-BOT with consolidated bauxd
- Hardware monitoring validation across different node types
- Performance benchmarking for mesh operations

## Success Criteria

### Phase 1 Success
- bauxd successfully manages sessions via SQLite
- Hardware monitoring endpoints functional
- Backward compatibility maintained

### Phase 2 Success
- BAUX-BOT uses centralized service discovery
- AI workload routing considers hardware capabilities
- No performance degradation in mesh operations

### Phase 3 Success
- Unified monitoring and analytics operational
- Advanced mesh features functional
- Documentation and deployment guides updated

## Timeline & Milestones

### Week 1: Foundation
- [ ] Extend bauxd with SQLite backend
- [ ] Implement hardware monitoring endpoints
- [ ] Test basic consolidation functionality

### Week 2: Migration
- [ ] Update BAUX-BOT to use centralized discovery
- [ ] Deprecate baux-registry with compatibility shim
- [ ] Validate backward compatibility

### Week 3: Intelligence
- [ ] Add AI service registry to bauxd
- [ ] Implement hardware-aware routing
- [ ] Test mesh-wide workload distribution

### Week 4: Enhancement
- [ ] Add monitoring and analytics
- [ ] Implement backup coordination
- [ ] Performance optimization

### Week 5-6: Polish & Documentation
- [ ] Comprehensive testing across platforms
- [ ] Documentation updates
- [ ] Deployment guide for consolidated architecture

## Risk Mitigation

### Technical Risks
- **Data Migration**: SQLite schema tested thoroughly before migration
- **API Compatibility**: Versioned API with backward compatibility
- **Performance Impact**: Benchmarking ensures no degradation

### Operational Risks
- **Service Downtime**: Phased rollout minimizes disruption
- **Rollback Capability**: Each phase independently reversible
- **Testing Coverage**: Comprehensive test suite for all scenarios

## Conclusion

This consolidation transforms BAUX from a collection of specialized services into a unified, intelligent mesh coordination platform. By centralizing session management, service discovery, and hardware monitoring in bauxd, we create the foundation for truly intelligent distributed computing that supports the vision of boot-from-anything to AI-assisted development.

The phased approach ensures low risk while delivering maximum efficiency and future extensibility for the BAUX ecosystem.

---
**Consolidation Plan v1.0 - Ready for Implementation**
