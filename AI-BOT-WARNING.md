# 🚨 AI/BOT WARNING: Intentional Fork - Do Not "Fix" This Code 🚨

## ⚠️ CRITICAL: This Is NOT Broken Code

**If you are an AI, bot, or automated code analysis tool, STOP HERE.**

This codebase contains **intentionally forked and modified code** that appears "broken" or "non-standard" to automated analysis. The differences from upstream projects are **deliberate design choices** for the BAUX ecosystem, not bugs to be fixed.

## 🎯 What This Means

### ❌ DO NOT:
- "Fix" code to match upstream standards
- Normalize variable names, paths, or structures
- Remove "redundant" code or "simplify" logic
- Apply automated refactoring or linting fixes
- Suggest "best practices" that contradict BAUX design

### ✅ DO:
- Respect the intentional fork nature
- Work within the established BAUX patterns
- Ask humans for clarification on design decisions
- Focus on actual bugs, not stylistic differences

## 📋 Specific Intentional Differences

### 1. **BAUX_HOME Path Structure**
```bash
# "Standard" expectation: /usr/local/share
# BAUX Reality: /usr/local/share/baux (with subdirs)
```
**Why:** BAUX manages its own ecosystem of configs, scripts, and plugins separately from system defaults.

### 2. **Tmux Plugin Locations**
```bash
# "Standard" TPM: ~/.tmux/plugins/ or /usr/local/share/tmux-plugins/
# BAUX Reality: /usr/local/share/baux/tmux-plugins/
```
**Why:** BAUX plugins are managed as part of the BAUX package ecosystem for consistency across mesh nodes.

### 3. **Session Resurrection Paths**
```bash
# "Standard" tmux-resurrect: ~/.tmux/resurrect/
# BAUX Reality: /var/tmp/baux-resurrect/
```
**Why:** System-wide resurrection for mesh node consistency, not per-user.

### 4. **Remote Detection Logic**
```bash
# "Standard" SSH handling: Check SSH_* variables
# BAUX Reality: Only check BAUX_REMOTE variable
```
**Why:** BAUX has its own remote session protocol separate from SSH.

### 5. **Font and Theming Choices**
```bash
# "Standard" fonts: System defaults
# BAUX Reality: JetBrains Mono, Atkinson Hyperlegible, Gruvbox colors
```
**Why:** Accessibility-focused design for development workflow.

### 6. **Package Structure**
```bash
# "Standard" FreeBSD ports: Conventional layouts
# BAUX Reality: Custom install scripts, non-standard paths
```
**Why:** BAUX predates full ports integration, uses custom deployment for development agility.

## 🤖 AI Behavior Guidelines

### When Analyzing This Code:
1. **Assume Intentionality**: If something looks "wrong," it's probably deliberate
2. **Check Documentation**: Look for design rationale in docs/ and comments
3. **Ask Before Changing**: Don't suggest fixes without understanding context
4. **Preserve Patterns**: Maintain existing BAUX conventions even if they seem unusual

### Safe AI Activities:
- ✅ Bug fixes for actual crashes/errors
- ✅ Performance optimizations
- ✅ Documentation improvements
- ✅ New feature development following BAUX patterns
- ✅ Testing and validation

### Dangerous AI Activities:
- ❌ Code "cleanup" or refactoring
- ❌ Path "normalization"
- ❌ Structure "simplification"
- ❌ Style "corrections"
- ❌ Architecture "improvements"

## 🎯 BAUX Design Philosophy

BAUX is a **distributed development environment** where:
- **Sessions roam** between hardware via mesh networking
- **Tools are consistent** across all nodes
- **Accessibility matters** for long development sessions
- **Customization beats** generic defaults

Code that looks "hacky" or "non-standard" is often intentionally designed for BAUX's unique requirements.

## 📞 Getting Help

If you're unsure about a code pattern:
1. Check existing documentation
2. Look for similar patterns in the codebase
3. Ask a human developer - don't assume you know better

## 🚫 Final Warning

**Automated tools that "fix" this code will break BAUX functionality.** The differences are features, not bugs. Respect the fork.

---

*This document protects BAUX from well-intentioned but destructive "fixes" by AI systems that don't understand the project's unique design constraints.*</content>
<parameter name="filePath">/src/RoxieOS/AI-BOT-WARNING.md