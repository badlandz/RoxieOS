# roxanne – The Final Debian Derivative  
Tracking Debian Trixie – November 23 2025

```
roxanne (n.)  
/ɹɒkˈsæn/  
1. A minimal, root-only, 8-package Debian Trixie derivative that boots in < 12 seconds on a Pi Zero  
2. The only Linux distribution that is also your personal rescue USB and daily driver  
3. The physical embodiment of “root forever”

Current status: v0.1 “Rick-Roll Edition” – 20 % complete  
Base: Debian Trixie (testing) – live-build, no custom kernel, no backports, no excuses  
Size: < 380 MB installed  
Packages: exactly 8 (see WHITEPAPER.md)

### What this repository contains

roxanne/  
├── README.md                  ← you are here  
├── WHITEPAPER.md              ← the 8-package manifesto  
├── packages/                  ← the only 8 .deb packages that will ever exist in v0.1  
│   ├── baux/                  ← tmux + neovim + starship + btop + fastfetch + resurrection  
│   ├── bauxwm/                ← dwm-roxanne + alacritty + status.sh  
│   ├── roxieos-base/          ← root autologin + Caps ⇄ Esc + live skeleton  
│   ├── neovim-roxanne/        ← nightly Neovim + full LSP rice  
│   ├── roxieos-plymouth/      ← red radioactive boot splash  
│   ├── roxieos-grub/          ← “You just got Roxanne’d”  
│   ├── roxieos-release/       ← uname -r → roxanne-linux  
│   └── roxieos-meta/          ← the glitter bomb (Depends: on the 7 above)  
├── repo/                      ← local apt repository (reprepro)  
├── live/                      ← live-build config → the USB/ISO  
└── absorb/                    ← future niche forks (catbird, murphy, etc.)

### How to build the ISO (one command)

```bash
cd live
sudo lb build
```

Result: `live-image-amd64.hybrid.iso` – the Blade.  
Plug it in anywhere. Boot. You are home.

### How to install to disk (from the live USB)

Press I at the boot prompt → full persistence, still root, still < 380 MB.

### How to become a node in the swarm

```bash
baux vpn add        # scan QR from another node
baux revive --all   # resurrect every session you ever had
```

That’s it.

### Philosophy

We do not fork Debian.  
We track Trixie exactly, we just remove everything that is not root, not fast, and not immortal.

No users.  
No sudo.  
No bloat.  
No mercy.

Root forever.  
Layers forever.  
Roxanne forever.

– badlandz, November 2025

