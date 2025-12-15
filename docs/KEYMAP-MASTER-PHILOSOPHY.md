# KEYMAP-MASTER-PHILOSOPHY.md
**Unified Keymap Philosophy for BAUX Ecosystem**

**Document Purpose**: Establish the master philosophy and rules for keymap design across all BAUX components to ensure consistent, intuitive, and accessible keyboard interactions.

---

## **Core Philosophy: Human-Centric Flow Logic**

### **The BAUX Keymap Promise**
> "Keymaps so intuitive to a vim user, even when the fonts are failing you, you can almost code blind anyway"

BAUX keymaps are designed around **human hand movement patterns** and **muscle memory**, not arbitrary key combinations. Every key binding follows natural finger flow and maintains consistency across all layers.

### **Three Eternal Principles**

#### **1. One Finger Movement = One Meaning**
- **Caps Lock → Escape**: Natural thumb position becomes universal escape
- **hjkl Navigation**: Vim-style movement everywhere (console, GUI, terminal)
- **Space as Leader**: Most accessible key becomes command prefix
- **Alt+Numbers**: Session/workspace switching (tmux windows, bwm tags)

#### **2. Layer Consistency**
- **Console**: Mod4+1-9 = TTY switching
- **bwm**: Mod4+1-9 = Tag switching (same as console sessions)
- **tmux**: Alt+1-9 = Window switching (same as bwm tags)
- **Neovim**: Space+1-9 = Buffer switching (same as tmux windows)

#### **3. Accessibility First**
- **20pt Fonts Minimum**: Visually impaired users must read instantly
- **1920x1080 Limits**: Prevent tiny text when graphics drivers load
- **High Contrast**: Red/green/blue themes for maximum visibility
- **Keyboard-Only**: No mouse dependencies for core workflows

---

## **The BAUX Keymap Hierarchy**

### **Foundation Layer: baux.kbd**
**Location**: `/usr/share/syscons/keymaps/baux.kbd` (FreeBSD) / `/usr/share/keymaps/baux.kbd` (Debian)
**Purpose**: System-level remapping that affects everything

#### **Core Remappings**
```bash
# Caps Lock → Escape (thumb position becomes universal escape)
caps_lock = escape

# Mod4 (Super/Windows) → Session switching
mod4 + 1-9 = F1-F9 (TTY/session switching)

# Alt preserved for application-specific actions
# Ctrl preserved for universal actions
```

#### **FreeBSD Implementation**
```bash
# From /src/RoxieOS/ports/roxieos-base/files/usr/local/etc/roxieos/setup-keymap
# Caps Lock scan code remapped to Escape
026   '['    '{'    esc    esc    '['    '{'    esc    esc     O
```

### **Application Layers**

#### **Console/Terminal Layer**
- **Navigation**: hjkl (vim-style everywhere)
- **Session Switching**: Mod4+1-9 (TTY switching)
- **Global Actions**: Ctrl+Alt+Delete (system functions)

#### **bwm Window Manager Layer**
- **Tag Switching**: Mod4+1-9 (same as console sessions)
- **Window Navigation**: Mod4+hjkl (focus movement)
- **Terminal Spawning**: Mod4+Enter (new terminal)
- **Status Toggle**: Mod4+b (show/hide status bar)

#### **tmux Multiplexer Layer**
- **Prefix**: Ctrl-Space (accessible, doesn't conflict)
- **Window Switching**: Alt+1-9 (same as bwm tags)
- **Pane Navigation**: Alt+hjkl (vim-style movement)
- **Session Switching**: Mod4+1-9 (when BAUXWM unset)
- **Status Toggle**: Mod4+b (when BAUXWM unset)

#### **Neovim Editor Layer**
- **Leader**: Space (most accessible key)
- **Buffer Switching**: Space+1-9 (same as tmux windows)
- **Window Navigation**: Ctrl+hjkl (same as tmux panes)
- **File Operations**: Space+f* (find files, grep, buffers)
- **Git Operations**: Space+g* (status, branches, commits)

#### **BAUX Shell Layer**
- **Vi-Mode**: Default enabled (set -o vi)
- **Navigation**: hjkl in command line
- **Session Commands**: baux session list/attach/create
- **Mesh Commands**: baux mesh enroll/status

---

## **Keymap Flow Logic: Hand Movement Patterns**

### **Primary Hand Positions**

#### **Left Hand (Navigation & Control)**
```
~ 1 2 3   → Session/Workspace switching (Alt/Mod4 + 1-9)
  q w e r → Standard typing position
a s d f   → Movement keys (hjkl adjacent)
  z x c v → Less used, available for custom
```

#### **Right Hand (Actions & Commands)**
```
  7 8 9   → Function keys (F7-F9 for custom)
u i o p   → Standard typing position
j k l ;   → Movement keys (hjkl primary)
m , . /   → Command keys (Space/Enter adjacent)
```

#### **Thumb Positions**
- **Left Thumb**: Space (leader), Ctrl (modifier)
- **Right Thumb**: Enter (execute), Alt (application modifier)

### **Movement Flow Patterns**

#### **Vim-Style Navigation (hjkl)**
- **h**: Left (index finger left)
- **j**: Down (index finger down)
- **k**: Up (middle finger up)
- **l**: Right (ring finger right)

**Why hjkl?** Natural finger movement without stretching, works even with failing vision.

#### **Session Switching (1-9)**
- **Left hand**: 1-4 (index through pinky)
- **Right hand**: 6-9 (index through pinky)
- **Modifier**: Alt/Mod4 (thumb position)

**Why Alt/Mod4?** Thumb modifiers are most comfortable for repeated use.

#### **Leader Key (Space)**
- **Position**: Left thumb, most accessible key
- **Usage**: Command prefix for complex operations
- **Why Space?** Always available, doesn't conflict with typing

---

## **Cross-Component Consistency Rules**

### **Rule 1: Same Action = Same Keys**
```bash
# Session switching works identically everywhere
Console: Mod4+1-9 → TTY 1-9
bwm:    Mod4+1-9 → Tag 1-9
tmux:   Mod4+1-9 → Session 1-9 (when BAUXWM=0)
Neovim: Space+1-9 → Buffer 1-9
```

### **Rule 2: Vim Navigation Everywhere**
```bash
# hjkl movement works in all contexts
Console: Alt+hjkl → Direction (when supported)
bwm:    Mod4+hjkl → Focus window
tmux:   Alt+hjkl → Select pane
Neovim: hjkl → Move cursor (normal mode)
```

### **Rule 3: Layer Awareness**
```bash
# Environment variables control behavior
BAUXWM=1    # bwm is running, adjust tmux bindings
BAUX_SESSION=1  # Current session number
BAUX_LEADER=" "  # Space key in editors
```

### **Rule 4: Accessibility Overrides**
```bash
# Font and display requirements
MIN_FONT_SIZE=20pt
MAX_RESOLUTION=1920x1080
HIGH_CONTRAST=true
KEYBOARD_ONLY=true
```

---

## **Implementation Guidelines**

### **For New Components**

#### **1. Inherit Existing Patterns**
```bash
# New tool should use:
# - Space as leader (if modal)
# - hjkl for navigation
# - Alt+1-9 for sub-item switching
# - Mod4 for global actions
```

#### **2. Check Environment**
```bash
# Respect existing layers
if [ -n "$BAUXWM" ]; then
    # bwm is running, adjust bindings
    bind_mod4_sessions=false
fi
```

#### **3. Document Bindings**
```bash
# Every component must document its keymap
# Include in README.md and KEYMAPS.md
# Test with different hardware configurations
```

### **For Existing Components**

#### **1. Audit Current Bindings**
```bash
# Check for conflicts
grep -r "bind.*key" /path/to/configs

# Verify accessibility
# Test with screen readers
# Verify high contrast support
```

#### **2. Standardize Modifiers**
```bash
# Use consistent modifier hierarchy
Ctrl  # Universal actions (copy, paste, quit)
Alt   # Application-specific actions
Mod4  # Global/system actions
Shift # Case modifications
```

#### **3. Test Across Hardware**
```bash
# Test on different keyboards
# Test with accessibility tools
# Test with various display sizes
```

---

## **Accessibility Requirements**

### **Visual Accessibility**
- **Font Size**: Minimum 20pt on 1920x1080 displays
- **Contrast**: Red/green/blue themes with high contrast
- **Scaling**: Prevent tiny text when graphics drivers load
- **Screen Readers**: Keyboard-only navigation support

### **Motor Accessibility**
- **Thumb Keys**: Prefer Space, Alt, Ctrl over pinky keys
- **Adjacent Keys**: hjkl pattern over spread-out combinations
- **Repeat Actions**: Minimize key combinations for common tasks
- **One-Handed Use**: Important operations possible with one hand

### **Cognitive Accessibility**
- **Consistent Patterns**: Same keys do same things everywhere
- **Predictable Behavior**: No surprise keybindings
- **Clear Feedback**: Visual/audio feedback for actions
- **Undo Support**: Easy reversal of actions

---

## **Keymap Testing Protocol**

### **Hardware Testing**
```bash
# Test on different keyboards
- Full-size keyboard
- Tenkeyless keyboard  
- Laptop keyboard
- External USB keyboard

# Test with accessibility tools
- Screen readers (Orca, NVDA)
- High contrast themes
- Large font settings
```

### **Software Testing**
```bash
# Test across all BAUX layers
- Console only
- bwm + terminals
- tmux sessions
- Neovim editing
- BAUX shell commands

# Test environment combinations
- BAUXWM=1 (bwm running)
- BAUXWM=0 (console/tmux only)
- Different terminal emulators
```

### **User Testing**
```bash
# Test with different user types
- Vim users (primary target)
- Emacs users (secondary)
- GUI-only users (accessibility target)
- Visually impaired users

# Test workflow completion
- Can user complete full development workflow?
- Can user navigate without vision?
- Can user work on different hardware?
```

---

## **Keymap Evolution Rules**

### **Adding New Bindings**
1. **Check Conflicts**: Ensure new binding doesn't conflict with existing
2. **Follow Patterns**: Use established modifier + key patterns
3. **Test Accessibility**: Verify works with accessibility tools
4. **Document Changes**: Update KEYMAPS.md and component READMEs

### **Modifying Existing Bindings**
1. **Backward Compatibility**: Don't break existing muscle memory
2. **Migration Path**: Provide transition period for users
3. **Accessibility Impact**: Ensure changes don't harm accessibility
4. **Cross-Component**: Update all affected components

### **Removing Bindings**
1. **Usage Analysis**: Confirm binding is truly unused
2. **Alternative Provided**: Ensure functionality available elsewhere
3. **Documentation Update**: Remove from all keymap documentation
4. **Deprecation Notice**: Warn users before removal

---

## **Success Metrics**

### **Consistency Score**
- **100%**: Same action uses same keys across all layers
- **Target**: 95%+ consistency for core workflows

### **Accessibility Score**
- **100%**: All features accessible without vision
- **Target**: 100% for core workflows, 90%+ overall

### **Learnability Score**
- **Time to productive**: < 30 minutes for vim users
- **Target**: < 1 hour for keyboard-native users

### **Hardware Compatibility**
- **Supported keyboards**: All major layouts
- **Target**: Works on 95%+ of modern keyboards

---

## **Component-Specific Keymap Standards**

### **bwm (Window Manager)**
```bash
# Tag switching (same as console sessions)
Mod4+1-9: Switch to tag 1-9

# Window management
Mod4+hjkl: Focus window in direction
Mod4+Enter: Spawn terminal
Mod4+b: Toggle status bar
Mod4+q: Close window
```

### **tmux (Multiplexer)**
```bash
# Prefix
Ctrl+Space: Command prefix

# Window management
Alt+1-9: Switch to window 1-9
Alt+hjkl: Select pane in direction

# Session management (when BAUXWM=0)
Mod4+1-9: Switch to session 1-9
Mod4+b: Toggle status bar
```

### **Neovim (Editor)**
```bash
# Leader
Space: Command prefix

# Buffer management
Space+1-9: Switch to buffer 1-9

# Window management
Ctrl+hjkl: Move between splits

# File operations
Space+ff: Find files
Space+fg: Live grep
Space+fb: Buffer list
```

### **BAUX Shell**
```bash
# Vi-mode enabled by default
set -o vi

# Session commands
baux session list
baux session attach <name>
baux session create <name>

# Mesh commands
baux mesh enroll
baux mesh status
```

---

## **Conclusion**

The BAUX keymap philosophy is built around **human factors** and **consistency**, not technical convenience. Every key binding serves the user's muscle memory and accessibility needs first.

**Keymap decisions are made at the human level, not the code level.** When in doubt, ask: "How would a visually impaired vim user expect this to work?"

This philosophy ensures BAUX remains **usable by feel** even when vision fails, maintaining productivity through **consistent, accessible, and intuitive keyboard interactions** across all components.

**Remember**: The goal is not just to make software work, but to make it work **naturally** for human hands and minds.</content>
<parameter name="filePath">/src/roxanne/KEYMAP-MASTER-PHILOSOPHY.md