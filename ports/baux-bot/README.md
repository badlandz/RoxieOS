# baux-bot - BAUXBSD AI Assistant

## Installation

1. Install Ollama:
   ```bash
   pkg install ollama
   ```

2. Pull recommended models (choose based on your hardware):
   ```bash
   # Fast & efficient (recommended for most workstations)
   ollama pull deepseek-coder:6.7b

   # Alternative good balance
   ollama pull qwen2.5:7b

   # Fastest (minimal hardware requirements)
   ollama pull llama3.2:3b
   ```

3. Install baux-bot:
    ```bash
    cd /usr/ports/misc/baux-bot
    make install clean
    ```

4. Enable automatic startup (optional, but recommended):
    The port automatically enables Ollama service in `/etc/rc.conf` during installation. If not:
    ```bash
    sudo service ollama enable  # Adds to rc.conf
    sudo service ollama start   # Starts immediately
    ```

## Usage

### Interactive Mode
```bash
baux-bot
```
Starts an interactive chat session with full RoxieOS codebase context.

### TMUX Integration
- `Alt+b` - Launch baux-bot in a new tmux pane
- The bot automatically monitors `~/src/RoxieOS/` for changes
- RAG rebuilds when files are modified

### Commands
- `exit` - Quit the bot
- `status` - Show repository status
- `read /path/to/file` - Force a specific file into the RAG context

## Features

- **Auto-detection**: Finds RoxieOS repo in `~/src/RoxieOS`, `/src/roxieos`, or via `$ROXIE_ROOT`
- **Auto-startup**: Ollama service starts automatically on boot after installation
- **Real-time monitoring**: Automatically rebuilds knowledge base when repo changes (lazy loading for speed)
- **FreeBSD optimized**: Uses FreeBSD-compatible commands and paths
- **Privacy focused**: Local Ollama models, no cloud dependencies
- **Development focused**: Specialized prompts for BAUXBSD/FreeBSD development

## Troubleshooting

### Ollama not found
```bash
service ollama start  # Start Ollama service
ollama serve          # Or run manually
```

### Repository not found
Set the `ROXIE_ROOT` environment variable:
```bash
export ROXIE_ROOT=/path/to/your/roxieos/repo
```

### Permission issues
The bot uses `~/.baux-bot/` for logs and RAG data - ensure write permissions.

### Auto-startup issues
If Ollama doesn't start on boot:
```bash
grep ollama_enable /etc/rc.conf  # Check if enabled
service ollama status           # Check status
```

## Architecture

### Current Implementation (FreeBSD v6.4)
- **RAG System**: Builds context from git status + 50 most recent source files
- **Model Selection**: Automatically chooses best available model from 16+ backends
- **Memory**: Logs all conversations for continuity
- **Integration**: Designed for tmux-based BAUXBSD workflow

### Evolution Roadmap (From Debian Salvage)

#### **Phase 1: Socket-Based Daemon (HIGH PRIORITY)**
**Goal:** Eliminate crashes with reliable IPC
**Salvaged from Debian v1:**
```bash
# Socket daemon prevents stdout/stderr conflicts
SOCKET_PATH="/tmp/baux-bot.sock"
mkfifo "$SOCKET_PATH"
# Background daemon + client connections
```

**Benefits:**
- No more crashes on API responses
- Persistent background operation
- Editor integration without blocking

#### **Phase 2: Tool Routing System (MEDIUM PRIORITY)**
**Goal:** Simplify routing from 16+ AI backends to modular tools
**Salvaged from Debian v1:**
```bash
# Route to specialized tools first
FAST_MODELS=("grok-cli" "ollama")
SEARCH_TOOLS=("ripgrep" "postgresql" "web")

route_query() {
    case "$query_type" in
        "code") has_cmd rg && echo "ripgrep" ;;
        "search") echo "web" ;;
        *) echo "ollama" ;;  # Fallback to AI
    esac
}
```

**Benefits:**
- Faster responses for specialized queries
- Reduced API dependency
- More reliable than complex AI routing

#### **Phase 3: BVI Editor Integration (HIGH PRIORITY)**
**Goal:** Seamless AI within Neovim workflow
**Salvaged from bvi.nvim:**
```lua
-- Visual selection to AI
vim.keymap.set('v', '<leader>ai', function()
    local selection = get_visual_selection()
    local result = vim.fn.system('baux-bot --socket "explain ' .. selection .. '"')
    show_floating_result(result)
end)

-- Sacred lattice: leader + 1-9 → buffer 1-9
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        jump_to_buffer_or_window(i)
    end)
end
```

**Benefits:**
- AI without leaving editor
- Context-aware queries
- Unified tmux/vim keymaps

### **Implementation Status**
- ✅ **Version Hashing**: `baux-bot v6.4-dev-[githash]`
- 🔄 **Socket Daemon**: Planned for crash prevention
- 🔄 **Tool Routing**: Planned for reliability
- 🔄 **Editor Integration**: Planned for workflow enhancement

### **Migration Strategy**
1. **Immediate**: Socket daemon to fix crashes
2. **Short-term**: Tool routing for stability
3. **Long-term**: Full BVI integration for productivity

**See `baux-bot-evolution-roadmap.md` for complete implementation details.**