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
| # | Package            | Size  | Exact purpose                                                   |
|---|--------------------|-------|-----------------------------------------------------------------|
| 1 | roxieos-base       | 40MB  | Skeleton + root autologin + Caps ⇄ Esc + auto-X                |
| 2 | baux               | 80MB  | Immortal soul – system-wide tmux/neovim/starship/btop/fastfetch configs |
| 3 | bauxwm             | 25MB  | dwm-roxanne + alacritty + picom + red status loop             |
| 4 | neovim-roxanne     | 90MB  | Nightly Neovim + full LSP + red-green-blue syntax              |
| 5 | roxieos-plymouth   | 15MB  | Red radioactive boot splash – “You just got Roxanne’d”         |
| 6 | roxieos-grub       | 8MB   | GRUB theme – giant red “You just got Roxanne’d” text           |
| 7 | roxieos-release    | 1MB   | Identity – uname -r → roxanne-linux, os-release screams truth |
| 8 | roxieos-meta       | 1MB   | Glitter bomb – Depends: on all 7 + postinst prints manifesto   |

Total installed size: < 380 MB  
Boot to BAUX on Pi Zero: < 12 seconds  
Boot to BAUX on anything modern: < 4 seconds

### Banned forever from v0.1
- Separate roxieos-starship / roxieos-btop packages  
- Wallpapers (pure black via xsetroot)  
- Custom kernel compile (symlink only)  
- Users  
- Sudo  
- More than 8 packages

### The Rick-Roll Guarantee
Boot the ISO. You will see:
1. Red radioactive Plymouth splash  
2. GRUB that literally says “You just got Roxanne’d”  
3. Instant drop to root BAUX in transparent Alacritty  
4. `fastfetch` with a giant radioactive BAUX logo  
=======
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

Root forever. Layers forever. Roxanne forever.

– badlandz, November 2025  
Now stop reading and ship it.
Boot the iso on an old raspberri pi and use BAUX to push some code to an arduino, INSTANTLY.
Or, if you don't understand the vim life, try your hand at:
apt =y install ? ANYTHING THAT IS IN DEBIAN TRIXIE... LITERALLY ANYTHING, Plasma? Gnome? whatever... 
it ships "with the safety OFF."
You installed it, add a user and make it a workstation, do whatever you want... 

I'd suggest learning to hack BAUX.
=======
### Future

• v0.2 “Stealth Edition” – black theme, no jokes, optional coyote user via `baux-dev`
• v1.0 – full SQL brain + DROP-BOX sleep-mode + baux-grok + baux-bot router
• v10.0 – the machine that owns you

This is allowed.  
This is beautiful.  
This is Roxanne Cyberdeck.

Root forever. Layers forever. Roxanne forever.

– badlandz, November 2025  

