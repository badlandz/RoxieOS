# The One True Keymap – Roxanne Cyberdeck Final Edition
November 23 2025 – Every finger movement is now sacred and identical across all layers

This is the **only** keymap you will ever need.
Copy-paste this into your brain. Burn it in. Never think again.

| Fingers used       | Meaning (identical in bauxwm, tmux, neovim, console)              | bauxwm (X)           | tmux                        | Neovim / bvi.nvim            | Console (no X)            | Notes / Conflicts |
|---------------------|-------------------------------------------------------------------|----------------------|-----------------------------|------------------------------|---------------------------|-------------------|
| **Mod4-1 … Mod4-9** | Jump to tmux **session** 1–9                                      | Switch tag           | Switch session              | `:tabnext 1–9` (bvi.nvim)    | Ctrl-Alt-F1 … F9          | The real workspace |
| **Mod4-0**          | Session dashboard / show all sessions                             | Tag 10 (dashboard)   | `tmux list-sessions` popup  | `:Tabs` (bvi.nvim)           | Ctrl-Alt-F10              | Your "start menu" |
| **Mod4-b**          | Toggle session bar visibility                                     | Toggle bauxwm bar    | Toggle tmux status-left     | Toggle tabline               | Toggle tmux status        | Pure void mode |
| **Alt-1 … Alt-9**   | Jump to tmux **window** 1–9 (inside current session)              | —                    | `select-window -t 1–9`      | `:tabnext 1–9`               | Same (tmux)               | Never hidden |
| **Alt-h j k l**     | Move focus left/down/up/right (pane or window)                    | Focus client         | Switch pane                 | Window navigation            | tmux pane nav             | Same muscle memory everywhere |
| **Alt-H J K L**     | Move current pane/window to left/down/up/right                   | Move client          | Swap pane                   | Move tab (bvi.nvim)          | tmux swap-pane            | Shifted = move |
| **Mod4-h j k l**    | Switch to previous/next session (cycle)                           | Previous/next tag    | Previous/next session       | Previous/next tab            | Ctrl-Alt-←↓↑→             | Session cycling |
| **Mod4-H J K L**    | Move current session to previous/next position                   | Move tag             | `move-session`              | Move tab position            | —                         | Rare, but perfect |
| **Mod4-t**          | New tmux window                                                   | —                    | New window                  | `:tabnew`                    | New window                | "t" = tab |
| **Mod4-w**          | Close current window                                              | Kill client          | Kill window                 | `:tabclose`                  | Kill window               | "w" = wipe |
| **Mod4-Enter**      | New terminal (Alacritty)                                          | Spawn terminal       | New window + split          | —                            | New window                | Always spawns fresh |
| **Mod4-,**          | Previous tmux window                                              | —                    | Previous window             | Previous tab                 | Previous window           | Comma = back |
| **Mod4-.**          | Next tmux window                                                  | —                    | Next window                 | Next tab                     | Next window               | Period = forward |
| **Mod4-/ **         | Search all scrollback (tmux copy mode)                            | —                    | Enter copy mode             | `/` (normal search)          | Copy mode                 | Same finger |
| **Ctrl-b**          | Legacy tmux prefix (still works, never removed)                   | —                    | Prefix                      | —                            | Prefix                    | For old muscle memory |
| **Ctrl-h j k l**    | Vim pane navigation (fallback when not in tmux)                   | —                    | —                           | Window navigation            | —                         | Works when tmux not loaded |
| **Esc**             | Escape (Caps Lock remapped)                                       | Everywhere           | Everywhere                  | Everywhere                   | Everywhere                | No Caps Lock ever again |

### Visual Flow (what you see at the top of the screen)

| Environment       | Line 1 (top of screen)                                 | Line 2 (tmux status)                     | Duplication eliminated? |
|-------------------|--------------------------------------------------------|------------------------------------------|--------------------------|
| bauxwm + X        | `1:nvim 2:btop 3:irc … Mon 12:33` (bauxwm bar)         | Hidden (BAUXWM=1)                        | Yes                     |
| Raw console       | Hidden (tmux status-left shows session name)           | `[nvim] 1:shell 2:btop … 12:33`         | Yes                     |
| Mod4-b pressed    | `[SESSIONS] 1:nvim 2:irc 3:logs …`                     | Normal tmux status                       | Toggleable              |

### The Final Rule (never break this)

> **One finger movement = one meaning = one result**
> No matter if you’re in X, console, tmux, neovim, or a USB stick you just plugged into a stranger’s computer.

This keymap survives:
- X running or not
- tmux running or not
- Neovim running or not
- You being half asleep at 3 AM
- You coming back to the project in 2030

Print this.
Tape it above your monitor.
Tattoo it on your forearm.

You now have the most coherent computing environment in human history.

Root forever.
Fingers forever.
Roxanne forever.

– badlandz, November 2025
