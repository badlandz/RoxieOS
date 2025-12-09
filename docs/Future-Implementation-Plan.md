# BAUXBSD Implementation Status
**Completed Upgrades and Future Plans**

## ✅ Completed: Foundation Setup

### Neovim Configuration
- **Standalone Config**: `neovim/` directory with LazyVim
- **bvi Variants**: Lite (15MB) and dev (50MB) configs ready
- **Gruvbox Theming**: Unified colors across all variants
- **Keymap Integration**: BAUXBSD system implemented

### Development Infrastructure
- **System Probe**: `scripts/baux-probe.sh` for compatibility testing
- **Build Scripts**: Basic package building framework
- **Documentation**: Complete handbook with cross-references
- **Testing Focus**: ThinkPad X200 as primary platform
- **Neovim**: `<C-hjkl>` navigation, `<leader>1-9` buffers, tmux integration
- **BAUX Bot**: `<leader>b/l` for AI assistance

## Live USB Persistence (NomadBSD Approach)

### Implementation Plan
- **Filesystem:** Adopt unionfs-fuse for read-only base + writable overlay
- **Expansion:** Automatic filesystem growth on first boot
- **Variants:** Support both UFS and ZFS for different use cases
- **Tools:** Qt-based installer for hard disk deployment

### Bootloader & UEFI
- **Dual Support:** BIOS and UEFI with EFI framebuffer fixes
- **Graphics Detection:** Boot-time driver selection with fallback options
- **Troubleshooting:** Boot menu options (disable graphics detection, syscons)

### Hardware Auto-Setup
- **Graphics:** Intel/NVIDIA/AMD auto-detection with VESA/SCFB fallback
- **Sound:** Pre-configured drivers with DSBMixer interface
- **Network:** NetworkMgr for wireless setup
- **Input:** Touchpad and keyboard configuration

## Chaos Screensaver Implementation

### Current Status
- **Location**: `ports/chaos/` (placeholder)
- **Features**: Idle detection, manual Mod4+c, tmux effects
- **Integration**: Session preservation with baux

### Next Steps
1. Implement tmux pane manipulation scripts
2. Add idle detection logic
3. Test with bwm integration
4. Ensure instant restoration on keypress

## Session Resurrection (baux revive)

### Current Status
- **ZFS Integration**: Planned with zfs-periodic snapshots
- **SeaweedFS**: Buffering for hot storage
- **Neovim**: folke/persistence plugin integrated

### Implementation Plan
1. Extend baux with revive commands
2. Add SeaweedFS API integration
3. Implement ZFS snapshot automation
4. Test cross-machine resurrection

## DWM Patches for bwm

### Current Status
- **Source**: `patches/upstream/dwm/` (dwm source moved)
- **Patches**: `patches/roxanne.patch` (placeholder)

### Patches Needed
- **Session Display**: Show BAUX session names in bar
- **Keybindings**: Mod4+1-9 session switching
- **BAUXWM Integration**: Environment variable handling
- **Status Updates**: Real-time session info

### Build Process
```bash
# In ports/bwm/Makefile
do-build:
    cd ${WRKSRC} && patch < ${PATCHDIR}/roxanne.patch
    make
```

## ST Patches for bterm

### Current Status
- **Port**: `ports/bterm/` (placeholder created)
- **Source**: Need to add to `patches/upstream/st/`

### Patches Needed
- **BAUX Theming**: Color scheme matching bwm
- **Font Stack**: Optimized rendering
- **Integration**: Seamless with bwm/baux
- **Keymaps**: Consistent BAUX bindings

### Implementation
1. Obtain suckless/st source
2. Create BAUX patches
3. Build FreeBSD port
4. Integrate with bwm theming

## Config Files Organization

### System Configs
- **Keymap**: `ports/bbase/files/usr/share/syscons/keymaps/baux.kbd`
- **X11 Keymap**: `ports/bbase/files/usr/local/share/X11/xkb/symbols/baux`
- **rc.conf**: Auto-enable keymap and services

### User Configs
- **tmux**: `ports/baux/files/usr/local/etc/baux/tmux.conf`
- **neovim**: `neovim/` (standalone), `ports/bvi/lite/dev/` (variants)
- **bwm**: `ports/bwm/files/usr/local/etc/bwm/config.h`

## Build Scripts Enhancement

### Current Status
- **build-ports.sh**: Basic port building script
- **build-src.sh**: FreeBSD src patching
- **install-live.sh**: Upstream patching workflow
- **clone-workstation.sh**: Backup/restore automation

### Enhancements Needed
- Add bvi variant detection (lite/dev)
- Integrate neovim config selection
- Automate patch application
- Add dependency checking

## Testing Strategy

### Current Testing
- Keymap verification scripts
- Session resurrection testing
- Package installation validation

### Enhanced Testing
- Neovim config loading (lite/dev variants)
- Plugin compatibility on Pi Zero
- BAUX keymap consistency across layers
- Performance benchmarks (<5s boot, <200MB idle)
- Cross-architecture testing (amd64, aarch64)

## Integration Points

### ✅ Completed: bvi + baux
- folke/persistence for neovim session management
- Complements baux tmux resurrection
- Auto-restore buffers and cursor positions

### bwm + baux
- BAUXWM=1 environment variable
- Session name display in status bar
- Mod4+1-9 session switching

### bterm + bwm
- Matching Gruvbox color schemes
- Font consistency
- Seamless terminal spawning

### chaos + baux
- Session state preservation during effects
- Instant restoration on any keypress
- Non-disruptive idle operation

## Advanced AI Features (Post-v0.1)

### AI Shepherding Implementation
**Status:** Planned for v0.2
**Features:**
- **Query Analysis**: Local AI determines best model (Ollama for code, Grok for docs, Gemini for research)
- **Automatic Switching**: Seamless backend selection based on query type
- **Performance Optimization**: Route simple queries to fast local models, complex to cloud
- **User Preferences**: Configurable defaults in `~/.baux-bot/config`

### Interactive AI Tutors
**Status:** Planned for v0.2
**Features:**
- **VIM Tutor**: AI-guided vim command learning with real-time feedback
- **TMUX Tutor**: Interactive tmux session management tutorials
- **BAUX Keymap Training**: Muscle memory building for unified bindings
- **Progress Tracking**: Session-based learning with persistent state

### RTFM Documentation Bot
**Status:** Planned for v0.2
**Features:**
- **Codebase Search**: AI-powered documentation lookup across all BAUX components
- **Context-Aware Help**: Query understanding with relevant code examples
- **Cross-Reference Generation**: Automatic linking between docs and code
- **Offline Capability**: Cached documentation for disconnected work

### Memory and Continuity Features
**Status:** Planned for v0.2
**Features:**
- **Session Memory**: Chat logs persist across reboots via SeaweedFS
- **Context Carryover**: Previous conversations inform new queries
- **Project Memory**: Codebase changes tracked for evolving assistance
- **User Learning**: AI adapts to user preferences and corrections

### Daemon Mode and Notifications
**Status:** Planned for v0.3
**Features:**
- **Background Monitoring**: AI watches for development patterns/errors
- **TMUX Popups**: Non-intrusive notifications for suggestions
- **Idle Assistance**: Context-aware help during coding pauses
- **Proactive Suggestions**: Code improvements based on usage patterns

### Ollama Tuning for Hardware Optimization
**Status:** Implemented in v0.2
**Features:**
- **Auto-Tune Command**: `baux-bot --autotune-ollama` benchmarks available models on current hardware
- **Performance Metrics**: Measures response time, quality, and resource usage for each model
- **Dynamic Model Selection**: Updates `MODEL_PREF` array based on hardware capabilities
- **Workstation-Specific**: Adapts for old laptops (prioritize smollm2:135m) vs. servers (llama3.1:8b)
- **Fallback Logic**: Ensures at least one model works; skips unavailable models
- **Documentation**: Logs tuning results to `~/.baux-bot/tune.log` for troubleshooting

### BAUX-MESH AI Distribution
**Status:** Planned for v0.3
**Vision:** Leverage RoxieOS's persistent pane ecosystem for distributed AI intelligence
**Core Concept:** RoxieOS requires 2+ installs (live IP holder with Tailscale keys, maintenance sessions); AI resources shared across mesh based on latency/ollama performance
**Features:**
- **Distributed RAG**: Shared codebase knowledge pools across devices (USB, VM, cloud, LAN) via SeaweedFS/drop-baux
- **Mesh Model Execution**: Route AI queries to optimal RoxieOS install (e.g., server for heavy models, local for privacy)
- **Session Resurrection with AI**: Grab panes from crashed systems, AI reconstructs context
- **Collaborative Learning**: Bots across mesh share learnings, improve collectively
- **Latency-Aware Routing**: Auto-select closest/fastest AI resource in BAUX-MESH
- **Novel Capabilities**: Global tutoring (learn vim on one device, continue on another), distributed builds with AI oversight

**Current Status:**
- **drop-baux Port**: Completed FreeBSD port (installed and tested on .101; uses rsync/sshfs for peer syncing)
- **Remaining Work:**
- **SeaweedFS Setup**: Install and configure SeaweedFS for distributed storage (requires FreeBSD package or manual build)
- **RAG Integration**: Modify baux-bot to store/load RAG from drop-baux (user dirs for now; SeaweedFS for full mesh)
- **Tmux Hooks**: Add resurrect integration for RAG persistence in sessions
- **Testing**: Validate cross-device RAG sharing and AI routing
- **Future Enhancement**: Background daemon mode for 24-48 hour continuous tuning

### Custom AI Model Training (baux-bot v1.0)
**Status:** Long-term goal for v1.0
**Vision:** Train a custom AI model specifically for RoxieOS development
**Requirements:**
- **Dataset**: RoxieOS codebase, documentation, user interactions, bug reports
- **Training**: Cloud GPU resources ($50-100 budget for initial training)
- **Fine-Tuning**: Focus on FreeBSD, tmux, neovim, shell scripting, C development
- **Integration**: Replace Ollama models with custom model for superior context understanding
- **Benefits**: Perfect AI assistant that "knows" RoxieOS intimately
**Steps:**
1. Collect training data from git history, docs, chat logs
2. Set up cloud GPU training environment
3. Train base model (e.g., fine-tune Llama on RoxieOS data)
4. Integrate into baux-bot as primary backend
5. Continuous learning from user corrections

### Multi-Modal AI Integration
**Status:** Planned for v0.3
**Features:**
- **Screenshot Analysis**: TMUX layout feedback and UI improvement suggestions
- **Code Review**: Visual diff analysis with AI commentary
- **Error Screenshot Help**: Debug assistance from error messages/images
- **Workflow Optimization**: AI suggestions for tmux/neovim layouts

## BAUX Mesh Infrastructure

### Headscale Integration
**Status:** Planned for Phase 3
**Requirements:**
- Headscale FreeBSD package creation
- Domain setup (hs.coseismic.org) on cloud VPS
- Client/server configuration for secure mesh
- Authentication and ACL setup
- LAN testing with X200, then cloud deployment

### Server Hosting Options
**Vultr Cloud Compute (Recommended):**
- **1GB Plan:** ~$6/month (1 vCPU, 25GB SSD, 2TB transfer)
  - Sufficient for basic BAUX server + Headscale
  - Excellent FreeBSD support
- **2GB Plan:** ~$12/month (1 vCPU, 50GB SSD, 3TB transfer)
  - Better for concurrent sessions and growth
- **Locations:** Multiple global datacenters available

**Reference:** FreeBSD Server Setup Guide - https://www.youtube.com/watch?v=r-qn6DrJ6IA

### Server Software Stack
- **Headscale:** Lightweight Go application (~50MB RAM)
- **Session Registry:** SQLite database for location tracking
- **Local Maintenance:** Storage for server's own admin sessions
- **Web Interface:** Optional administration interface
- **Monitoring:** Basic resource and connectivity monitoring

### Network Architecture
- **Control Plane:** hs.coseismic.org for Headscale coordination
- **Mesh Traffic:** Encrypted device-to-device communication
- **Registry Queries:** Lightweight location lookups for session discovery
- **Peer-to-Peer Sync:** Direct session synchronization between devices

This plan provides the roadmap for implementing all planned features while maintaining the clean FreeBSD ports structure.