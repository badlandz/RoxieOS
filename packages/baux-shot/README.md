# baux-shot — The One True Screenshot Tool for RoxieOS

Press **Option + s** once.  
Get a perfect PNG.  
Works everywhere.

That’s it. That’s the entire readme.

### What it actually does

- In X11 → `maim` (select region or full screen, no borders, no cursor)
- In pure console / framebuffer → `fbgrab` → exact pixel-for-pixel dump of /dev/fb0
- Same keybind in tmux, dwm, and raw console
- Same output directory: `~/shots/roxie_YYYY-MM-DD_HHMMSS.png`
- Same behavior on a 2025 laptop or a 2012 Raspberry Pi running on a car battery in a ditch

No GUI picker.  
No “save as” dialog.  
No “do you want to copy to clipboard?” bullshit.

You are in the field.  
You press Option+s.  
You have proof.

### Dependencies (all < 8 MB total)

```bash
fbgrab imagemagick maim xclip
