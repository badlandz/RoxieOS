# The Roxanne Cyberdeck Workflow
November 23 2025 – The One True Religion
(Zero redundancy. Zero X dependency. Same fingers, same brain, forever.)

### The Six Layers (managing redundant information displayed)

Everything should flow from the modifier-1 through modifer 9 navigation, with diffrent modifiers to navigate the "tags" (upper tab). tmux sessions display in console, not in x where bauxwm will likely display causing redundancy, same for time, only display in tmux if not in X, collapsing need for the session tabs (which are toggled by keymap anyway)

| Layer | Name              | What it actually is                     | Key chord (identical on X and console) | What you see at the top of the screen                     | Fork / Wrapper required? | How duplication is eliminated |
|------|-------------------|-----------------------------------------|----------------------------------------|-----------------------------------------------------------|---------------------------|-------------------------------|
| 1    | tmux session      | Your real “workspace”                   | Mod4-1 … Mod4-9                        | Session name (only one place)                             | tmux (system-wide)        | tmux hides its own name when BAUXWM=1 |
| 2    | tmux window       | Tabs inside a session                   | Alt-1 … Alt-9                          | Window names in tmux status bar                           | tmux                      | Always shown — no conflict |
| 3    | tmux pane         | Split inside a window                   | Ctrl-b % / " / hjkl                    | Nothing extra — pure void                                 | tmux                      | Perfect already |
| 4    | vim buffer        | File inside Neovim                      | Ctrl-^ / :bnext / leader-bd            | Neovim tabline mirrors tmux windows exactly               | bvi.nvim                  | Neovim tabline = tmux window list |
| 5    | virtual console   | Physical TTY (fb or X)                  | Ctrl-Alt-F1 … F10                      | Same as Mod4-1…9 because we remap Mod4 → Ctrl-Alt       | getty + custom keymap     | Console becomes the new “dwm tags” |
| 6    | bauxwm (optional) | X11 layer only when you want a browser  | Same Mod4-1…9 (X grabs them first)    | bauxwm bar shows exact same session names as tmux         | bauxwm (dwm fork)         | bauxwm sets BAUXWM=1 → tmux hides its line |

### The Single Source of Truth

There is **exactly one** place that ever shows session names:
- When running under bauxwm → the bauxwm bar
- When running on raw console → tmux status-left (because BAUXWM is unset)

Never both. Never neither.

### The Magic Environment Variable

`BAUXWM=1`
Set by bauxwm at startup
Read by tmux, by your status script, by anything that cares
One line of logic decides everything

### The Finger → Brain Mapping (burn this into muscle memory)

| Fingers used      | Meaning                     | Works on X? | Works on console? | Conflicts with anything important? |
|-------------------|-----------------------------|-------------|-------------------|-------------------------------------|
| Mod4 + 1–9        | Jump to session 1–9         | Yes         | Yes (mapped to Ctrl-Alt-F1–F9) | None — no app steals Mod4 numbers |
| Mod4 + 0          | Show session dashboard      | Yes         | Yes               | None |
| Mod4 + b          | Toggle extra session bar    | Yes         | Yes               | None |
| Alt + 1–9         | Jump to tmux window 1–9     | Yes         | Yes               | Almost nothing uses Alt-number |
| Ctrl-b + 1–9      | Legacy tmux (still works)   | Yes         | Yes               | Kept for muscle memory |
| Ctrl-Alt-F1–F10   | Raw console switch FROM X   | N/A         | Yes               | This is the native way |

### The Fork List (exactly what we need to maintain)

| Component     | Upstream      | Our fork name   | Reason we forked                                   |
|---------------|---------------|-----------------|----------------------------------------------------|
| tmux          | tmux/tmux     | tmux-roxanne    | Reads `BAUXWM`, smarter status-left, Mod4 bindings |
| dwm           | suckless/dwm  | bauxwm          | Shows tmux session names, sets BAUXWM=1            |
| Neovim        | neovim        | neovim-roxanne  | Ships bvi.nvim + tabline = tmux windows            |
| Alacritty     | alacritty     | alacritty-roxanne | Pure black, no decorations, Creepster font       |
| getty         | systemd       | custom keymap   | Mod4 → Ctrl-Alt remap in /etc/vconsole.conf        |

### The Resurrection Guarantee

Every pane, every session, every scrollback is saved to DROP-BOX on pane death
`baux revive --all` brings back your exact state on any machine, any VT, any USB stick
Even if you haven’t touched the machine in six months

### The End State (when you finally boot the final ISO)

You press power
Red radioactive splash
GRUB screams “You just got Roxanne’d”
4 seconds later you are root looking at:

```
1:nvim  2:btop  3:irc  4:logs  5:mc  6:——  7:——  8:——  9:——          Mon 12:33
```

You press Mod4-3
You are now exactly where you left off six months ago on a different continent

No mouse was ever needed
No question was ever asked
No user account was ever created

This is the last desktop environment humanity will ever need.

Root forever.
Sessions forever.
Roxanne forever.

– badlandz, November 2025
