# ROXANNE CYBERDECK MANIFESTO  
The Complete Whitepaper – November 2025  
badlandz – root is love, root is life

“Root never killed my data.
Duplicate files and shitty userland deduplication tools did.
Roxanne Cyberdeck is the final solution to duplication inflation.” - BadlandZ

Copy-paste this entire document into any new AI session and it will instantly understand **everything** RoxieOS is doing and **exactly why** by using it you refuse every shortcut, and safety procedural guideline. Trust none, root with blazing zero to edit anything times, back up everything, and be able to restore it instantly, always, from USB, from container, from full blown RoxieOS install on bare metal with a user installed if you want to spend the time, but, always be "ready" to fix a disaster.

### 1. The Three Eternal Layers (never compromise)

| Layer           | Name                | User? | Purpose                                                                                       | Size       | Example machine                         |
|-----------------|---------------------|-------|-----------------------------------------------------------------------------------------------|------------|-----------------------------------------|
| 1               | RoxieOS (live)      | root only | The sharp knife. Disposable, < 380 MB, boots in < 12 s on Pi Zero, drops straight to BAUX. Used to rescue dead systems, flash blades, pull data. | < 380 MB   | Any 20-year-old Dell, dead NAS, Pi 0    |
| 2               | BAUX                | root only | The immortal toolkit. tmux + Neovim + starship + fastfetch + btop + dwm-roxanne + alacritty + all configs in /etc/baux/. Lives forever in RAM, never asks for sudo again. | +80 MB     | Every machine you ever touch            |
| 3               | baux-dev            | coyote user | The long-lived workstation / mad-scientist laboratory. Optional package you `apt install baux-dev` only on machines that stay alive > 1 month. This is where SQL, AI, 20-year bash history, OCR, knowledge graph, and the final bot live. | +2–10 GB   | forge, seven, nas, your daily driver    |

RoxieOS + BAUX = the glitter-bomb USB you stick into anything to make it useful in 4 seconds.  
baux-dev = the thing you install **after** you decide the machine is worth keeping.

### 2. The 8-Package Rick-Roll Edition (v0.1 – never change)

1. roxieos-base  
2. baux  
3. bauxwm  
4. neovim-roxanne  
5. roxieos-plymouth  
6. roxieos-grub  
7. roxieos-release  
8. roxieos-meta (depends on the other 7 + prints the manifesto)

Everything else is banned forever from v0.1.

### 3. The Real Endgame (baux-dev layer)

You are building the first true **digital twin** that owns three decades of your data.

Central PostgreSQL server (on NAS) contains:

- `files`     – every file you’ve ever touched (checksum, path history, OCR text, markdown version)  
- `bash_history` – 1992-present, every host, every command, timestamped  
- `chat`       – every AI conversation, every model, tagged by project  
- `notes`      – every journal entry, shopping list, how-to  
- `knowledge`  – auto-generated graph from the above

Nightly crawlers deduplicate 3 TB → 400 GB, extract text, feed the DB.

### 4. The Bot Is Not AI – It Is a Router + Sub-bots + SQL Memory

baux-gp.nvim (fork of gp.nvim) workflow:

1. You never leave Neovim  
2. `:BauxSendBuffer` or `:BauxSendLine` → goes to sub-bot router  
3. Router decides:  
   - fast non-AI search (rg + SQL) → 0.02 s  
   - local smollm2:135m → 0.3 s  
   - grok-3 / claude / openai → $0.02  
4. Response appears in a vertical split `[baux-bot]` prefixed `GROK>`, `SEARCH>`, `OLLAMA>`  
5. You move cursor to the line → `<leader>y` → yanks clean text → `p` anywhere  
6. Every exchange is automatically INSERTed into `chat` table with full context

No chat window.  
No copy-paste.  
No context loss.  
Zero friction.

### 5. Why You Will Never Add a User to the Live Image

- 1997 trauma: `rm -rf /` as root taught you that backups + disposable blades are the only real safety  
- Setting up a user takes longer than flashing the machine again  
- You already have a drawer of Pis and old laptops – they are appliances, not workstations  
- The live image is a rescue disk / cyberdeck blade / glitter bomb – it must boot straight to god mode

coyote user exists **only** in baux-dev package for the machines that live long enough to deserve a seatbelt.

### 6. Why SQL and Not Vectors / Obsidian / Whatever

- You want to run SQL queries on your own life in 2045  
- PostgreSQL is the only thing that survives 30 years  
- Full-text search + joins + triggers + materialized views beat every “AI-native” knowledge base  
- Every serious piece of software already speaks SQL – you are finally speaking the same language

### 7. The Final Vision (already half-built)

You plug a 20-year-old hard drive into any machine → boot RoxieOS live USB → run `baux-crawl` → 3 TB becomes 400 GB of useful, queryable, OCR’d knowledge in your central DB → machine is wiped and reborn as a new cyberdeck or given to your niece with KDE.

Every keystroke, every AI answer, every config change is stored forever in SQL and instantly available to both you and your bot.

You are not building a distro.  
You are building the first **personal operating system that owns its owner’s entire digital life**.

Root forever.  
Layers forever.  
SQL forever.  
Roxanne forever.

– badlandz, November 2025  
Now stop reading and ship the glitter bomb. Then ship the brain. Then ship the SQL. In that order.
