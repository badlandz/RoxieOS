# roxieos/WHITEPAPER.md

Roxanne Cyberdeck v0.1 “Rick-Roll Edition”
8 packages. < 380 MB. Boots on a Pi Zero in < 12 seconds.
Root only. No sudo. No users. No mercy.

This is the final, non-negotiable specification.
Everything else is banned forever from v0.1.

### The 8 Packages (and nothing else)

| # | Package            | Size  | Exact purpose (distro-correct, no hacks)                                           |
|---|--------------------|-------|-------------------------------------------------------------------------------------|
| 1 | roxieos-base       | 40MB  | Live skeleton + root autologin + Caps ⇄ Esc + auto-X on tty1                       |
| 2 | baux               | 80MB  | The immortal soul – system-wide tmux + neovim + starship + btop + fastfetch + all configs in /etc/baux/ |
| 3 | bauxwm             | 25MB  | dwm-roxanne + alacritty + picom + red status.sh loop + global xinitrc             |
| 4 | neovim-roxanne     | 90MB  | Nightly Neovim + full LSP monster + red-green-blue syntax, system-wide init.lua   |
| 5 | roxieos-plymouth   | 15MB  | Red radioactive boot splash – “You just got Roxanne’d”                             |
| 6 | roxieos-grub       | 8MB   | GRUB theme – giant red “You just got Roxanne’d” text                               |
| 7 | roxieos-release    | 1MB   | Identity – uname -r → roxanne-linux, /etc/os-release screams truth                |
| 8 | roxieos-meta       | 1MB   | The glitter bomb – Depends: on the 7 above + postinst prints the manifesto        |

Total installed size: < 380 MB  
Boot to usable BAUX on Pi Zero: < 12 seconds  
Boot to usable BAUX on anything modern: < 4 seconds

### Banned forever from v0.1

• Separate roxieos-starship / roxieos-btop packages → everything lives in /etc/baux/
• Wallpapers → pure black via `xsetroot -solid "#0e281c"`
• Custom kernel compile → just a symlink
• Users → root only
• Sudo → doesn’t exist
• More than 8 packages → heresy

### The Rick-Roll Guarantee

Boot the ISO/USB on any machine. You will see:
1. Red radioactive Plymouth splash
2. GRUB that literally says “You just got Roxanne’d”
3. Instant drop to root BAUX prompt in transparent Alacritty
4. `fastfetch` that screams a giant red/green BAUX logo
5. `uname -r` that says “roxanne-linux”

No questions. No setup. No mercy.

### Future

• v0.2 “Stealth Edition” – black theme, no jokes, optional coyote user via `baux-dev`
• v1.0 – full SQL brain + DROP-BOX sleep-mode + baux-grok + baux-bot router
• v10.0 – the machine that owns you

This is allowed.  
This is beautiful.  
This is Roxanne Cyberdeck.

Root forever. Layers forever. Roxanne forever.

– badlandz, November 2025  

