# BAUX Drop-System: Key Management & User Creation

## Overview

The **drop-baux system** has evolved from a simple session recovery buffer into a comprehensive **key management and user creation framework** for BAUX systems. It serves multiple critical functions in the BAUX ecosystem.

## Evolution of Purpose

### Phase 1: Session Recovery Buffer (Original Concept)
- Shared buffer for tmux session persistence across devices
- `/var/tmp/baux-resurrect/` for resurrection data
- Cross-device session synchronization

### Phase 2: Key Drop Area (Current Reality)
- Secure key storage outside git repository
- API keys for AI services (Grok, Gemini, Claude, etc.)
- Environment variable integration
- Faster key distribution than git/scp/rsync

### Phase 3: User Creation System (Future Vision)
- Live image user initialization
- Multi-user BAUX environment support
- Automated key integration into user environments
- Immortal session population with user-specific keys

## Architecture

### Directory Structure
```
~/mnt/drop-baux/
├── keys/
│   ├── api_keys.sh          # AI service API keys
│   └── session_keys.sh      # Session-specific keys
├── sessions/                # Session recovery data
├── users/                   # Multi-user configurations
└── config/                  # System-wide settings
```

### Key Integration
```bash
# ~/.bashrc integration
if [[ -f ~/mnt/drop-baux/keys/api_keys.sh ]]; then
    source ~/mnt/drop-baux/keys/api_keys.sh
fi

# Environment variables loaded:
export GROK_API_KEY="..."
export GEMINI_API_KEY="..."
export CLAUDE_API_KEY="..."
export REPLICATE_API_TOKEN="..."
export TOGETHER_API_KEY="..."
```

## Live Image User Creation

### Clean ISO Concept
- **No pre-configured users** - Clean, secure base image
- **No embedded keys** - Security by design
- **Ready for initialization** - Drop-baux enables first user creation

### User Creation Workflow
1. **Boot Clean ISO** - Root-only live environment, no users/keys
2. **Create Persistence** - Drop-baux creates persistent storage on boot media
3. **Drop Mesh Key** - Place minimal `api_keys.sh` with `MESH_LOGIN_KEY`
4. **Auto User Creation** - System creates first user account
5. **Clone RoxieOS** - Each user gets `~/src/RoxieOS` with their configuration
6. **Mesh Connection** - Single key unlocks access to all other keys
7. **Immortal Session** - User sessions persist with full AI integration

### Live USB to Persistent Workflow
```bash
# 1. Boot clean ISO (root only)
# 2. Mount drop-baux (USB partition or external drive)
mount /dev/da0s3 /mnt/drop-baux  # or wherever keys are

# 3. Place minimal keys for user creation
cat > /mnt/drop-baux/keys/api_keys.sh << 'EOF'
export MESH_LOGIN_KEY="tskey-auth-..."
export BAUX_USERNAME="developer"
EOF

# 4. Run user creation
baux-user-creation.sh

# 5. Reboot and login as new user
# 6. Full RoxieOS environment with mesh access
# 7. Drop additional API keys for AI services
# 8. Immortal sessions work immediately
```

### Multi-User Support
- **Per-user key isolation** - Each user has their own drop-baux
- **Shared system keys** - Common keys for system services
- **Session inheritance** - Users can inherit session configurations
- **Key rotation** - Individual users can update their keys independently

## Security Considerations

### Risks Identified
1. **Key Exposure** - Drop-baux accessible to all users with filesystem access
2. **Mount Persistence** - Keys remain available after unmount/remount
3. **Backup Inclusion** - Keys might be included in system backups
4. **Network Transmission** - Keys transmitted over potentially insecure channels

### Mitigation Strategies
1. **File Permissions** - `600` permissions on key files
2. **Encryption at Rest** - Optional key file encryption
3. **Access Control** - Drop-baux mount restricted to authorized users
4. **Key Rotation** - Regular key updates with secure distribution
5. **Audit Logging** - Track key access and usage

### Best Practices
- **Key Separation** - Different keys for different environments
- **Regular Rotation** - Update keys periodically
- **Secure Distribution** - Use encrypted channels for key drops
- **Backup Exclusion** - Ensure keys not included in backups
- **Access Monitoring** - Log key file access

## Implementation Details

### Mount System
```bash
# drop-baux mount command
drop-baux mount    # Mount the shared key/session storage
drop-baux sync     # Synchronize across BAUX-MESH nodes
drop-baux unmount  # Secure unmount when done
```

### Key Detection & Loading
```bash
# Automatic key loading in ~/.bashrc
if [[ -f ~/mnt/drop-baux/keys/api_keys.sh ]]; then
    source ~/mnt/drop-baux/keys/api_keys.sh
    echo "🔑 BAUX keys loaded from drop-baux"
fi
```

### Live ISO Integration
```bash
# Clean ISO boot sequence:
# 1. Root-only environment
# 2. Check for drop-baux mount
# 3. If keys found → create persistence → create user
# 4. If no keys → remain root-only for setup

# User creation script (baux-user-creation.sh):
# - Detects live environment
# - Creates persistence partition on boot media
# - Loads dropped keys
# - Creates user with ~/src/RoxieOS clone
# - Connects to BAUX mesh
# - Sets up immortal session environment
```

### Per-User RoxieOS Cloning
```bash
# Each user gets their own development environment:
~/src/RoxieOS/          # User's development repository
~/mnt/drop-baux/        # Symlink to shared key storage
~/.bashrc               # Auto-loads keys from drop-baux

# Benefits:
# - User-specific configurations
# - Isolated development environments
# - Shared key access without duplication
# - Easy backup/restore per user
```

### Session Integration
- **Immortal Sessions** populated with user keys on creation
- **Cross-device continuity** with key availability
- **Session templates** can include key requirements
- **Recovery scenarios** maintain key access

## User Experience

### Ease of Use Discovered
1. **Zero Configuration** - Drop keys, system works
2. **Cross-Device Sync** - Keys follow users across BAUX nodes
3. **No Git Conflicts** - Keys outside repository
4. **Fast Distribution** - Drop once, available everywhere
5. **Automatic Integration** - No manual environment setup

### Developer Workflow
```bash
# New developer onboarding
1. Get API keys from secure source
2. Create ~/mnt/drop-baux/keys/api_keys.sh
3. Populate with service keys
4. Restart shell or source ~/.bashrc
5. All BAUX AI services immediately available
```

## Future Enhancements

### Planned Features
- **Key Encryption** - Optional encryption of key files
- **Key Vault Integration** - External key management systems
- **Automated Rotation** - Scheduled key updates
- **Multi-Factor Key Access** - Additional security layers
- **Key Backup/Restore** - Secure key archival

### Integration Points
- **BAUX-MESH** - Distributed key synchronization
- **Session Manager** - Key-aware session creation
- **User Manager** - Automated user setup with keys
- **Security Framework** - Key access auditing

## Documentation Status

### Currently Documented
- ✅ Basic drop-baux as key storage
- ✅ API key integration patterns
- ✅ Mount/sync commands
- ❌ User creation workflow
- ❌ Security considerations
- ❌ Multi-user support
- ❌ Clean ISO concept

### Needs Documentation
- User creation process
- Security best practices
- Multi-user key isolation
- Key rotation procedures
- Backup exclusion rules
- Audit logging setup

## Workability Analysis

### ✅ **Highly Workable - Addresses Key Requirements**

#### **Clean ISO Concept:**
- **Root-only boot**: Achievable with minimal FreeBSD live configuration
- **No pre-configured users**: Security by design
- **No embedded keys**: Clean security model

#### **Drop-Baux as User Creator:**
- **Single key unlock**: `MESH_LOGIN_KEY` as master key
- **Automatic user creation**: Script detects keys and creates accounts
- **Persistence creation**: Boot media becomes persistent storage
- **Per-user environments**: Each user gets `~/src/RoxieOS`

#### **Mesh Integration:**
- **One key to rule them all**: Mesh login enables full environment
- **Key cascading**: Mesh access allows retrieval of all other keys
- **Secure distribution**: Keys follow users across devices

### ⚠️ **Identified Issues & Solutions**

#### **1. Persistence Location**
**Issue**: Where to create persistent storage on live USB?
**Solution**: Use boot device detection + partition 3 for persistence (like NomadBSD)

#### **2. Root Access During Setup**
**Issue**: User creation requires root privileges initially
**Solution**: Dedicated `baux-user-creation.sh` script runs as root, then drops privileges

#### **3. Key Precedence**
**Issue**: Conflicts between dropped keys and existing user keys
**Solution**: Drop-baux keys take precedence, user can override locally

#### **4. Live vs Installed Detection**
**Issue**: How to know if we're on live media needing persistence
**Solution**: Check for live indicators (`/etc/live/config.conf`, mount sources)

### 🚀 **Implementation Path**

#### **Phase 1: Clean ISO Base**
- Modify FreeBSD live image to boot root-only
- Remove default user creation
- Add drop-baux mount detection

#### **Phase 2: User Creation Script**
- Implement `baux-user-creation.sh`
- Add persistence creation logic
- Integrate with RoxieOS cloning

#### **Phase 3: Key Management**
- Mesh key as primary unlock
- Cascading key retrieval
- Per-user key isolation

#### **Phase 4: Testing & Refinement**
- Test live USB scenarios
- Validate persistence creation
- Verify multi-user workflows

### 🎯 **Success Criteria**

- **Boot clean ISO** → Root-only environment ✅
- **Drop one key** → Full user environment created ✅
- **Persistence works** → USB becomes persistent storage ✅
- **Mesh connection** → Access to all services ✅
- **Per-user RoxieOS** → Isolated development environments ✅

## Conclusion

Drop-baux has evolved from a simple technical workaround into a fundamental component of the BAUX user experience. It enables secure, easy key management while supporting the vision of immortal, personalized development sessions across the BAUX ecosystem.

**The clean ISO + drop-baux user creation concept is not only workable, but represents the ideal BAUX onboarding experience: one key drop, instant immortal development environment.**

The system successfully balances **security**, **ease of use**, and **distributed functionality** - allowing users to "drop their keys" once and have fully functional AI-assisted development environments everywhere.</content>
<parameter name="filePath">docs/DROP-BAUX-SYSTEM.md