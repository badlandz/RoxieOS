# Global Keymaps

The key to RoxieOS is a goal to create only what software is needed to achieve the desired IDE. That includes configuration to make all componants compatible, and this part, the Keymap Unification.

While BAUX-MESH is the backbone of functionality for RoxieOS, it's the ability to navigate the functionality of BAUX-MESH with unified keymaps that unlock the real power of BAUX-MESH with it's persistant RAG smart routed AI assist bot and distributed workload across your systems magic.

The goal is maximize producitivity, but leveraging muscle memory, to get "in the flow" of focusing on the code, and not even have to think about "how to edit the code" logistically.

Coming from vi, h, j, k, and l are "everything" and used globally when possible for "moving around."
Starting with dwm, the 1-9 plus 0 overviews for workspaces are fast orginization, and can be "expanded."

Starting with TMUX, the "window" into BAUX-MESH:
leader is maped to control-space, away from default control-b
allowing control-space-1 to control-space-9 being 9 quickly accessable "windows" in tmux.
Following this logic, alt-1 to alt-9 are tmux "sessions" with sets of windows, that can be quickly accessed, and if not existing a new session is automaticaly created in that location, can be renamed, but avaliable with quick consistent muscle memory.
One step up in X, bwm (modified dwm) has opt-1 to opt-9 allowing the "workspaces" at the "desktop/X" layer, and just one step further out.

This leverages muscle memory, 1 to 9 all work, with leader-space at the tmux window level, alt at the tmux session level, and opt at the X workspaces level. And, of course, your vi buffers will be mapped to leader-1 to 9 also. This allows large complex projects to be quickly navigated with minimal thought by user, all working in muscle memory not requiring a focus shift from the "I'm working on this" to "how do I get to that other thing."

This simple "unify keymaps in key software" to "similar logically consistant behaviour" seems obvious. However, it's not default behaviour out of the box. That's why RoxieOS exists, to create as much "unification" of behavior of software between it's componants as possible. Keymaping and functionality will always be the core goal of RoxieOS, not "modern looks and designs and sexy reddit unixporn rice."
