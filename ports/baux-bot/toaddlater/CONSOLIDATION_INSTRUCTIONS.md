# BAUX-BOT Evolution: Integration with bauxd

## End Game: Become bauxd Client Service

According to BAUX_CONSOLIDATION_PLAN.md, BAUX-BOT must evolve from standalone service to integrated bauxd client. This eliminates duplicate service discovery and enables hardware-aware AI routing.

## Current State vs Target State

### Current BAUX-BOT (bash-based)
- Custom service discovery logic
- Local Ollama + GROK API integration  
- File-based session tracking
- No hardware awareness
- Standalone operation

### Target BAUX-BOT (bauxd-integrated)
- Uses bauxd for service discovery (/ai/services endpoint)
- Registers with bauxd as AI service
- Hardware-aware query routing via bauxd
- Centralized session management
- Mesh-coordinated operation

## Evolution Path

### Phase 1: Add bauxd Client (Current Focus)
1. Implement HTTP client for bauxd API calls
2. Add service registration with bauxd
3. Replace local discovery with bauxd queries
4. Add hardware-aware routing logic

### Phase 2: Python Migration  
1. Migrate from bash to Python for better API integration
2. Use requests library for bauxd communication
3. Implement proper error handling and retries
4. Add async capabilities for mesh operations

### Phase 3: Full Integration
1. Become bauxd-managed AI service
2. Support cross-node session migration
3. Enable predictive resource allocation
4. Provide mesh-wide AI coordination

## Immediate Implementation Tasks

### 1. Add bauxd HTTP Client Functions


### 2. Service Registration with bauxd


### 3. Hardware-Aware Service Discovery


### 4. Replace Local Discovery
Replace current smart_query routing with:


## Success Criteria

- BAUX-BOT registers successfully with bauxd
- Service discovery uses bauxd instead of local logic
- Hardware stats influence routing decisions
- No duplicate session/service tracking
- Backward compatibility maintained during transition

## Testing Protocol

1. Start bauxd service on port 9999
2. Register BAUX-BOT with bauxd
3. Verify service appears in /ai/services endpoint
4. Test queries use bauxd-discovered services
5. Confirm hardware-aware routing works

## Next Evolution Steps

After basic integration:
1. Add load balancing based on bauxd hardware stats
2. Implement session migration coordination
3. Add mesh-wide AI service coordination
4. Migrate to Python for advanced features

This evolution transforms BAUX-BOT from isolated AI assistant to intelligent mesh participant.
