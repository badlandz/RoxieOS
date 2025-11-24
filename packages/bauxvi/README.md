# BAUXVI

# BAUXVI Development Plan Summary (v0.1 to v1.0)

## Overview and Rationale
- **Core Pivot**: Start with an existing Debian-packaged vi variant for v0.1 to maximize out-of-box functionality while keeping the minimal RoxieOS ISO small. This accelerates debugging, packaging, and testing (including Neovide GUI) without compromising the "minimal-first" ethos. Defer custom patching to v1.0 for a tailored `baux.tiny` binary that fixes vi.tiny limitations without excessive bloat.
- **Benefits**: Aligns with immortal, fallback-safe vision; gets 70-80% of features (e.g., sessions, undo, tmux sync) working immediately; low-risk tradeoff—patching isn't a "huge project" but a scoped 1-2 week effort.
- **No Full Scrap Needed**: BAUXVI wrapper script remains unchanged (detects/launches available editor); vi.tiny stays as ultimate fallback, but v0.1 uses a beefier variant for quick wins.

## v0.1 Starting Variant: `vim` (Standard Debian Package)
- **Why Chosen**: Sweet spot for "accomplishes most out-of-box" (70-80% of BAUXVI goals) while smallest for minimal ISO. Unlocks key features like full +autocmd (auto-events for sessions), +persistent_undo (eternal history), +diff (undotree viz), +syntax (filetype plugins for DB/AI), without scripting bloat.
- **Size/Impact**: ~3.9-5MB installed (~1.5MB package); negligible ISO addition (+2-3MB over vi.tiny). Fits root-only minimalism.
- **Comparison to Alternatives**:
  - **vi.tiny** (~1.8-2MB): Too limited (20-30% functionality; no undo eternity, weak plugins); delays debugging.
  - **vim-nox** (~4-5.7MB): Slightly larger; adds unnecessary scripting (Lua/Python)—skip for minimal.
  - **Neovim Stable/Nightly** (~7-10MB): Too heavy for ISO base; use for madness mode/Neovide testing via wrapper.
- **Implementation**:
  - Install: `apt install vim` in RoxieOS build script.
  - Config: Launch via wrapper with `/etc/bauxvi/vimrc.tiny` (200-line setup: `set nocompatible`, enable undofile, load plugins like obsession/undotree/navigator).
  - Testing: Debug immortality (sessions/undo), pane sync, AI/DB pipes. Layer Neovim nightly for Neovide GUI (wrapper detects/switches).
  - Packaging: Build `bauxvi.deb` with wrapper, vimrc, and minimal plugins; test on fresh ISO.

## Roadmap to v1.0: Custom-Patched `baux.tiny`
- **Goal**: Fork vi.tiny into `baux.tiny`—recompile with selective fixes (e.g., +persistent_undo, full +autocmd, basic +syntax, +diff) to enable 90-100% functionality without inflating size (>3MB binary target).
- **Effort Assessment**: Not overwhelming—1-2 weeks (or less with community); standard open-source build process.
- **Steps**:
  1. Fork Vim repo (vim/vim on GitHub, ~50MB).
  2. Configure selectively: `./configure --with-features=normal --enable-persistent_undo --enable-autocmd --enable-syntax --disable-gui --disable-rubyinterp --disable-pythoninterp` (avoid deps/bloat).
  3. Build/Install: `make; make install` (fast, 10-20min on Pi).
  4. Package: Use Debian's Vim src scripts for `baux.tiny.deb`.
  5. Integrate: Replace vi in RoxieOS; wrapper detects as "baux.tiny".
- **Size Control**: Enabling fixes adds ~500KB-1MB; monitor with `ls -lh`.
- **Risks and Mitigations**:
  - Bloat: Low—modular; disable extras if needed.
  - Breaks: Test against plugin matrix (e.g., undotree).
  - Deps: Minimal (libc, tinfo)—no new libs.
  - Time: Iterative; reusable for future updates.
- **Timeline Fit**: Defer to v1.0 after v0.1 validation; focus now on wrapper/config rig for quick prototyping.

## Next Steps for Execution
- Prototype wrapper on `vim` today.
- Outline `.deb` spec and first commit.
- Test cycle: Minimal ISO → Neovide GUI → Feature immortality.
