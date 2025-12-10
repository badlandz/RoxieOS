# Today's Roadmap Brief: Critical BAUX Components (Dec 10, 2025)
**Most Needed But Not Debugged/Implemented Components**

## Executive Summary

Based on comprehensive analysis of BAUX project goals, current implementation status, and roadmap documents, here are the **most critical components** that need immediate attention. These represent the highest-impact items that are either partially implemented, not debugged, or completely missing from the current BAUX ecosystem.

## 🔥 **CRITICAL PRIORITY: Core Infrastructure Gaps**

### 1. **bauxd HTTP REST API** (IN PROGRESS - Foundation Ready)
**Status:** CLI working, HTTP server framework exists but not implemented
**Impact:** Blocks mesh session discovery and service-oriented architecture
**Why Critical:** TUI currently falls back to ping-based discovery; proper API needed for scalable mesh operations

**Immediate Actions:**
- Implement HTTP server in `ports/bauxd/files/usr/local/bin/bauxd`
- Add GET `/sessions` and GET `/health` endpoints
- Test cross-node API calls via curl
- Integrate with TUI for clean session enumeration

### 2. **Session Registry Database** (NOT IMPLEMENTED)
**Status:** Planned in mini-roadmap but no code exists
**Impact:** No centralized session tracking across mesh nodes
**Why Critical:** Core to "immortal sessions" vision - can't find sessions across devices without registry

**Immediate Actions:**
- Create SQLite database schema on baux-scale
- Implement registry API (`/usr/local/bin/baux-registry`)
- Add session registration on creation/update
- Integrate with `baux` commands for automatic tracking

### 3. **GUI Layer Completion** (PARTIALLY IMPLEMENTED)
**Status:** bwm and bterm ports exist but not fully debugged/deployed
**Impact:** Workstation deployment incomplete without working desktop
**Why Critical:** BAUX workstation vision requires functional GUI layer

**Immediate Actions:**
- Debug bwm (dwm fork) compilation and BAUX patches
- Test bterm (st fork) with scaling fonts and theming
- Verify X11 integration and keymap support
- Deploy to .133 for workstation testing

## 🟡 **HIGH PRIORITY: User Experience Gaps**

### 4. **Live System Persistence** (FRAMEWORK EXISTS - Not Fully Debugged)
**Status:** NomadBSD unionfs-fuse approach documented but not implemented
**Impact:** USB boot loses changes on reboot
**Why Critical:** Core "instant workstation cloning" requires persistence

**Immediate Actions:**
- Implement unionfs-fuse overlay system
- Test automatic filesystem expansion
- Add Qt-based installer for hard disk deployment
- Verify ZFS/UFS compatibility

### 5. **Font Accessibility Stack** (PLANNED - No Implementation)
**Status:** 9-font Debian accessibility suite identified but not ported
**Impact:** Poor readability for users with visual impairments
**Why Critical:** Inclusive development environment requires accessible fonts

**Immediate Actions:**
- Create FreeBSD ports for accessibility fonts:
  - `x11-fonts/jetbrains-mono`
  - `x11-fonts/atkinson-hyperlegible`
  - `x11-fonts/opendyslexic`
- Implement fontconfig integration
- Test screen reader compatibility

### 6. **Cross-Platform Session Sync** (RESEARCH PHASE)
**Status:** Debian analysis complete but no FreeBSD implementation
**Impact:** Sessions don't survive OS switches
**Why Critical:** "Any hardware, instant resurrection" requires cross-platform sync

**Immediate Actions:**
- Design cross-platform session format
- Implement export/import utilities
- Test FreeBSD ↔ Debian session migration
- Add conflict resolution for simultaneous edits

## 🔵 **MEDIUM PRIORITY: Ecosystem Expansion**

### 7. **Repository Infrastructure** (PLANNED - Framework Needed)
**Status:** Local pkg repository concept exists but not implemented
**Impact:** No offline development capability
**Why Critical:** Distributed development requires local package management

**Immediate Actions:**
- Configure local pkg repository
- Create automated package building pipeline
- Implement secure update distribution
- Add multi-architecture support

### 8. **Chaos Screensaver** (PORT EXISTS - Not Implemented)
**Status:** `ports/chaos/` placeholder with design but no code
**Impact:** No idle protection for long-running sessions
**Why Critical:** Session security and power management

**Immediate Actions:**
- Implement tmux pane manipulation scripts
- Add idle detection logic
- Test with bwm integration
- Ensure instant restoration on activity

## 💡 **STRATEGIC ADDITION: baux-lite Deployment Type**

### **New Concept: Console-Only Layer**
**Rationale:** Add deployment type between "headless" and "workstation" for console-focused development

**Proposed Implementation:**
```bash
# BAUX-LITE: Console-only workstation
# - Full BAUX session management
# - Console keymaps and navigation
# - No X11/window manager overhead
# - Perfect for SSH-only development
# - Lower resource usage than full workstation
```

**Benefits:**
- Faster boot times (<3 seconds vs <5 for workstation)
- Lower memory footprint (~100MB vs ~200MB)
- Ideal for remote development servers
- Maintains full BAUX functionality
- Easy upgrade path to full workstation

**Detection Logic:**
```bash
# Has keyboard but no display capability
if [[ -c "/dev/input/event*" && -z "$DISPLAY" ]]; then
    DEPLOYMENT_TYPE="lite"
fi
```

## 📊 **Implementation Priority Matrix**

| Component | Difficulty | Impact | Timeline | Status |
|-----------|------------|--------|----------|--------|
| bauxd HTTP API | Medium | Critical | 1-2 days | In Progress |
| Session Registry | Medium | Critical | 3-5 days | Not Started |
| GUI Layer (bwm/bterm) | High | High | 1-2 weeks | Partial |
| Live Persistence | Medium | High | 1 week | Framework |
| Font Accessibility | Low | Medium | 3-5 days | Planned |
| Cross-Platform Sync | High | Medium | 2-3 weeks | Research |
| Repository Infra | Medium | Medium | 1-2 weeks | Planned |
| Chaos Screensaver | Low | Low | 2-3 days | Placeholder |

## 🎯 **Recommended Next Steps**

### **Today (Dec 10):**
1. **Complete bauxd HTTP API** - Finish the HTTP server implementation
2. **Test TUI integration** - Verify API calls work across mesh
3. **Add baux-lite concept** - Document and plan console-only deployment type

### **This Week:**
1. **Implement session registry** - SQLite database and API
2. **Debug bwm/bterm ports** - Get GUI layer working
3. **Start font accessibility ports** - Create FreeBSD font packages

### **Success Criteria:**
- ✅ TUI discovers sessions via bauxd API (not ping)
- ✅ Session registry tracks locations across mesh
- ✅ GUI layer boots and runs on workstation
- ✅ Live USB maintains changes across reboots
- ✅ 3+ accessibility fonts available in ports

## 📈 **Expected Outcomes**

**By end of week:** Functional mesh session discovery, working GUI layer, persistent live system
**By end of month:** Complete workstation deployment, accessible fonts, cross-platform sync foundation
**By end of quarter:** Full BAUX ecosystem with immortal sessions across all platforms

This roadmap focuses on the **minimum viable components** needed to achieve BAUX's core vision of "instant workstation resurrection on any hardware."</content>
<filePath>todays-roadmap-brief.md