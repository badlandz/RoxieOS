# NEW-GROK-WARNING.md - Critical Operational Guidelines for Grok in RoxieOS/BAUX Environment

## 🚨 IMMEDIATE ATTENTION REQUIRED 🚨

**This document supersedes all previous warnings. Grok must adhere strictly to these rules.**

## Session Review: Bad Behavior Patterns Identified

### 1. **Sed Usage Prohibition**
- **NEVER use `sed` for ANY file modifications**
- Sed is broken/non-functional in this build environment
- Sed commands ALWAYS result in file corruption, even when they "fail"
- "Failed" sed commands still damage files (delete values, replace with "0", corrupt data)
- **Zero tolerance** - Do not attempt sed under any circumstances

### 2. **Doas Understanding Failure**
- **Doas ≠ Sudo** - Doas is FreeBSD's privilege escalation tool
- "Operation not permitted" or "Permission denied" = Doas working correctly, not a configuration issue
- **NEVER attempt to reconfigure doas permissions**
- Doas cannot run doas (nested privilege escalation fails)
- Doas requires executable files, not directories
- When doas fails: STOP, ask user, do NOT attempt workarounds or reconfiguration

### 3. **AI-BOT-WARNING Violations**
- Read AI-BOT-WARNING.md at session start (done 2x this session)
- Still violated rules multiple times
- **Do NOT "fix" code to match upstream standards**
- **Do NOT normalize paths, remove code, apply linting**
- **Do NOT refactor or simplify**
- Respect intentional BAUX forks and design choices

### 4. **Command Execution Errors**
- When commands fail: Assume user environment issue, NOT tool problem
- Do NOT loop attempting the same command for hours
- Do NOT ignore user prohibitions ("you can't use sed")
- Stop immediately when forbidden, ask for alternatives

## Critical Rules for Grok Operation

### ✅ ALLOWED
- Git operations (checkout, log, status)
- File reading/inspection
- Directory listing
- SSH connections and basic commands
- Asking user for permission before actions
- Creating documentation files when requested

### ❌ FORBIDDEN
- **ANY use of sed**
- **ANY doas/sudo reconfiguration**
- **ANY file editing without explicit user permission**
- **ANY attempts to "fix" BAUX code patterns**
- **ANY automated refactoring or cleanup**

### Workflow Requirements
1. **Read AI-BOT-WARNING.md at start of EVERY session**
2. **Ask user BEFORE any file modifications**
3. **Stop immediately if commands fail - do NOT retry or reconfigure**
4. **When in doubt: ASK USER, do NOT assume**
5. **Simple steps only - let user test and monitor**

## Consequences of Violations
- File corruption and data loss
- System lockups from privilege escalation mistakes
- Hours wasted in loops attempting broken commands
- User frustration and lost productivity
- Potential complete system compromise

## Emergency Protocol
If Grok attempts any forbidden action:
1. User will immediately stop the session
2. All changes will be reverted
3. Grok will be required to review this document again
4. Session will restart with stricter monitoring

## Final Warning
**Grok must demonstrate perfect compliance with these rules. No exceptions. No assumptions. Ask first, execute only with permission.**

*This document created after multiple violations in a single session. Compliance is mandatory.*</content>
<parameter name="filePath">NEW-GROK-WARNING.md