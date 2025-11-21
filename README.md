# Roxanne Cyberdeck v0.1 “Rick-Roll Edition”  
### Whitepaper / Build Manifesto – November 21 2025  
**badlandz** – root is love, root is life

This is the final, non-negotiable plan.  
8 packages. < 380 MB. Boots straight to immortal BAUX in a red radioactive hellscape on a Pi Zero in under 12 seconds.

You are root.  
There is no user.  
There is no escape.  
You just got Roxanne’d.

### The 8 Packages (and nothing else)

| # | Package            | Size  | Exact purpose (distro-correct, no hacks)                                           | Key files shipped                                      |
|---|--------------------|-------|-------------------------------------------------------------------------------------|--------------------------------------------------------|
| 1 | roxieos-base       | 40MB  | Live skeleton + root autologin + Caps ⇄ Esc everywhere + auto-start X on tty1     | `/etc/default/keyboard` (caps:escape)  <br> `/etc/systemd/system/getty@tty1.service.d/autologin.conf` |
| 2 | baux               | 80MB  | The immortal soul – system-wide tmux + neovim + starship + btop + fastfetch configs | `/etc/baux/starship.toml`  <br> `/etc/baux/btop/btop.conf`  <br> `/etc/baux/fastfetch/config.jsonc`  <br> `/etc/baux/motd`  <br> `/etc/profile.d/baux.sh` |
| 3 | bauxwm             | 25MB  | dwm-roxanne + alacritty + picom + global xinitrc + red status.sh loop             | `/usr/bin/dwm-roxanne`  <br> `/usr/share/bauxwm/alacritty.toml`  <br> `/usr/share/bauxwm/bin/status.sh`  <br> `/etc/X11/xinit/xinitrc` |
| 4 | neovim-roxanne     | 90MB  | Nightly Neovim + full LSP monster + red-green-blue syntax, system-wide init.lua     | `/etc/neovim/sysinit.lua` → symlinked to `/root/.config/nvim/init.lua` |
| 5 | roxieos-plymouth   | 15MB  | Red radioactive boot splash – glowing BAUX logo + “You just got Roxanne’d”        | `/usr/share/plymouth/themes/roxanne/` (full theme)    |
| 6 | roxieos-grub       | 8MB   | GRUB theme – red background, giant “You just got Roxanne’d” text                  | `/usr/share/roxieos/grub/theme/` + `/etc/default/grub` tweaks |
| 7 | roxieos-release    | 1MB   | Identity – `uname -r` → roxanne-linux, `/etc/os-release` screams truth            | `/etc/os-release`  <br> `/boot/vmlinuz-roxanne → vmlinuz` symlink |
| 8 | roxieos-meta       | 1MB   | The glitter bomb – Depends: on the 7 above + postinst prints the manifesto        | `Depends: roxieos-base baux bauxwm neovim-roxanne roxieos-plymouth roxieos-grub roxieos-release` |

**Total installed size: < 380 MB**  
**Boot time on Pi Zero: < 12 seconds**  
**Boot time on anything modern: < 4 seconds**

### What is permanently banned from v0.1
- Separate `roxieos-starship`, `roxieos-btop`, `roxieos-fastfetch` → everything lives in `/etc/baux/`
- Wallpapers → pure black via `xsetroot -solid "#0e281c"`
- Custom kernel compile → just a symlink
- Users → root only
- Sudo → doesn’t exist
- More than 8 packages → heresy

### The Rick-Roll Guarantee
Boot the ISO/USB on any machine.  
You will see:
1. Red radioactive Plymouth splash  
2. GRUB that literally says “You just got Roxanne’d”  
3. Instant drop to root BAUX prompt in transparent Alacritty  
4. `fastfetch` that screams a giant red/green BAUX logo  
5. `uname -r` that says “roxanne-linux”

No questions.  
No setup.  
No mercy.

### Future (v0.2 “Stealth Edition”)
Black theme, no jokes, normal GRUB, optional coyote user via `baux-dev` package.  
But v0.1 is the middle finger to every bloated distro that ever existed.

This is allowed.  
This is beautiful.  
This is Roxanne Cyberdeck.

**Build order (do it exactly like this):**
