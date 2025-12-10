# BAUX Development Workflow Best Practices

## Current Issue Analysis

**Problem:** Rapid development cycles causing version confusion and deployment failures.

**Symptoms:**
- `./install.sh` says "INSTALLED" but doesn't update files
- Hard to tell which version is running
- Port installation tries to fetch from FreeBSD mirrors instead of local files
- RAG rebuilds every time instead of using mesh persistence

## Recommended Workflow Solutions

### 1. **Versioning Strategy During Development**

#### **Daily/Hourly Versioning (Current Rapid Dev)**
```bash
# In baux-bot header
echo "BAUX BOT v6.4-dev-$(date +%Y%m%d-%H%M) — AI assistant for RoxieOS development"

# Or use git commit hash
echo "BAUX BOT v6.4-dev-$(git rev-parse --short HEAD)"
```

#### **Milestone Versioning (Stable Releases)**
```bash
# When reaching stability
echo "BAUX BOT v7.0-stable — AI assistant for RoxieOS"
```

### 2. **Dev vs Stable Branch Strategy**

#### **Git Branch Structure**
```
main (stable) ←-- deployments
├── dev (rapid development)
│   ├── feature/baux-bot-fixes
│   ├── feature/mesh-registry
│   └── hotfix/crash-handler
└── staging (pre-release testing)
```

#### **Deployment Pipeline**
```bash
# Development workflow
git checkout dev
# Make changes...
git commit -m "fix: baux-bot crash on routing"
git push origin dev

# When ready for testing
git checkout staging
git merge dev
# Test on staging...

# When stable
git checkout main
git merge staging
git tag v7.0
```

### 3. **Real-World Best Practices (From Sources We Study)**

#### **FreeBSD Ports Tree Approach**
- **Local Development:** Modify ports in `/usr/ports` directly
- **Version Control:** Use `portlint` and `portfmt` for consistency
- **Testing:** `make install` in port directory for local testing
- **Upstream Sync:** Regular `portsnap fetch update`

#### **Neovim Plugin Development**
- **Version:** Use git tags for releases
- **Dev Versions:** Include commit hash in version string
- **Testing:** Local installation with `make install`
- **CI/CD:** GitHub Actions for automated testing

#### **Tmux Plugin Ecosystem**
- **Version:** Semantic versioning (major.minor.patch)
- **Dev:** Include `-dev` suffix with date
- **Testing:** Local tmux with plugin loaded
- **Distribution:** GitHub releases

### 4. **BAUX-Specific Recommendations**

#### **Short-term (Fix Current Issues)**
```bash
# Add version checking to installer
install.sh --version-check  # Show what versions are installed vs available

# Add deployment verification
install.sh --verify        # Check if files actually match repo versions

# Force version in scripts
echo "BAUX BOT v6.4-dev-$(git rev-parse --short HEAD)" > /usr/local/share/baux/version
```

#### **Medium-term (Better Organization)**
```
roxieos/
├── main/           # Stable releases
├── dev/            # Development branch
├── ports/          # FreeBSD ports (as now)
├── debian/         # Debian packages (as now)
├── patches/        # Upstream patches
│   ├── freebsd-src/    # FreeBSD source patches
│   ├── dwm/           # Window manager patches
│   └── tmux/          # Tmux patches
└── releases/       # Tagged releases
    ├── v6.0/       # Stable versions
    └── v6.4-dev/   # Dev snapshots
```

#### **Long-term (Production-Ready)**
- **Automated CI/CD** with version tagging
- **Package repositories** for each platform
- **Automated testing** across FreeBSD/Debian
- **Release management** with changelogs

### 5. **Immediate Fixes for Current Issues**

#### **Fix Port Installation**
```bash
# In ports/Makefile
# Use local distfiles instead of fetching
DISTDIR= /usr/local/distfiles
MASTER_SITES= file:///usr/local/distfiles/
```

#### **Fix RAG Persistence**
```bash
# Use mesh-mounted location
RAG_DIR="$HOME/mnt/drop-baux/rag"
# Check if mesh is available before rebuilding
if [[ -d "$RAG_DIR" && -f "$RAG_DIR/current.txt" ]]; then
    # Use existing RAG
else
    build_rag
fi
```

#### **Add Version Checking**
```bash
# In install.sh
check_version() {
    local component="$1"
    local installed_version=$(get_installed_version "$component")
    local repo_version=$(get_repo_version "$component")
    if [[ "$installed_version" != "$repo_version" ]]; then
        log "Version mismatch: installed=$installed_version, repo=$repo_version"
        return 1
    fi
}
```

## Implementation Priority

1. **🔥 CRITICAL:** Fix installer version checking and force updates
2. **🟡 HIGH:** Add version strings with git hashes for debugging
3. **🔵 MEDIUM:** Implement dev/stable branch workflow
4. **📋 LOW:** Set up automated CI/CD pipeline

## Questions for You

**Which approach appeals most:**
- **Quick Fix:** Add version hashes to debug current issues
- **Workflow Redesign:** Implement dev/stable branches now
- **Hybrid:** Version hashes + basic branch structure

**For the ports issue:** Should we modify the ports to use local distfiles, or fix the make process to not try fetching?</content>
<filePath>workflow-analysis.md