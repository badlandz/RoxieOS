# BAUX-Bot Evolution: Salvaged Concepts from Debian Implementation
**Roadmap for FreeBSD Integration - Key Ideas to Implement**

## Executive Summary

Analysis of old Debian baux-bot implementations reveals **three distinct architectural approaches** that should be integrated into the FreeBSD version:

1. **Socket-Based Daemon** (Debian v1) - Simple, reliable inter-process communication
2. **Tool Routing Architecture** (Debian v1) - Modular query routing vs monolithic AI
3. **BVI Editor Integration** (bvi.nvim) - Deep Neovim workflow integration

## 1. Socket-Based Daemon Architecture (HIGH PRIORITY)

### Current Problem
FreeBSD baux-bot crashes on API responses, lacks reliable IPC.

### Salvaged Solution
```bash
# From Debian implementation - proven working
SOCKET_PATH="/tmp/baux-bot.sock"
PID_FILE="$HOME/.baux-bot/bot.pid"

# Daemon mode with FIFO socket
run_daemon() {
    mkfifo "$SOCKET_PATH"
    echo $$ > "$PID_FILE"

    while true; do
        read -r request < "$SOCKET_PATH"
        response=$(handle_request "$request")
        echo "$response" > "$SOCKET_PATH"
    done
}

# Client mode
send_request() {
    echo "$1" > "$SOCKET_PATH"
    read -r response < "$SOCKET_PATH"
    echo "$response"
}
```

### Benefits for FreeBSD
- **Reliable IPC**: No more crashes from stdout/stderr conflicts
- **Background Operation**: Bot runs persistently, clients connect via socket
- **Editor Integration**: Neovim can send requests without blocking
- **Debugging**: Separate logs for daemon vs client operations

### Implementation Plan
1. Add socket daemon mode to FreeBSD baux-bot
2. Migrate current CLI to socket client
3. Add `--daemon` and `--client` modes
4. Update error handling for socket communication

## 2. Tool Routing Architecture (MEDIUM PRIORITY)

### Current Problem
FreeBSD version has 16+ AI backends in monolithic routing - complex and crash-prone.

### Salvaged Solution
```bash
# From Debian - simple, extensible tool routing
FAST_MODELS=("grok-cli" "ollama")
SLOW_MODELS=("claude-cli" "openai-cli")
SEARCH_TOOLS=("ripgrep" "postgresql" "web")

route_query() {
    local query="$1"

    # Code-related → ripgrep
    if echo "$query" | grep -qi "function\|class\|error"; then
        has_cmd rg && echo "ripgrep" && return
    fi

    # Search → web/PostgreSQL
    if echo "$query" | grep -qi "search\|find"; then
        echo "web"
        return
    fi

    # Default to fastest available AI
    for model in "${FAST_MODELS[@]}"; do
        has_cmd "$model" && echo "$model" && return
    done

    echo "none"
}
```

### Benefits for FreeBSD
- **Simplicity**: Clear decision tree vs complex AI routing
- **Extensibility**: Easy to add new tools (elasticsearch, etc.)
- **Reliability**: Tool existence checks prevent crashes
- **Performance**: Routes to fastest appropriate tool

### Implementation Plan
1. Add tool routing as fallback to AI routing
2. Implement ripgrep, web search, PostgreSQL integrations
3. Add tool availability detection
4. Simplify AI routing logic

## 3. BVI Editor Integration (HIGH PRIORITY)

### Current Problem
FreeBSD has no Neovim integration - users must leave editor to use AI.

### Salvaged Solution
```lua
-- From bvi.nvim - seamless editor integration
vim.keymap.set('v', '<leader>ai', function()
    -- Get visual selection
    local selection = get_visual_selection()

    -- Send to baux-bot via socket
    local result = vim.fn.system('baux-bot --client "explain ' .. selection .. '"')

    -- Display in floating window or replace selection
    show_floating_result(result)
end, { desc = "AI Explain Selection" })

vim.keymap.set('n', '<leader>ac', function()
    -- Get current line/buffer context
    local context = get_code_context()

    -- Send to baux-bot for completion
    local completion = vim.fn.system('baux-bot --client "complete ' .. context .. '"')

    -- Insert completion
    insert_completion(completion)
end, { desc = "AI Code Completion" })
```

### Benefits for FreeBSD
- **Seamless Workflow**: AI without leaving editor
- **Context Awareness**: Sends relevant code/file context
- **Visual Feedback**: Results in floating windows/splits
- **Buffer Integration**: Direct manipulation of editor content

### Implementation Plan
1. Create Neovim plugin with socket client
2. Add visual selection AI commands
3. Implement context-aware prompting
4. Add result display in floating windows

## 4. Workflow Integration Patterns (MEDIUM PRIORITY)

### Current Problem
FreeBSD version is CLI-only, no editor or workflow integration.

### Salvaged Solutions

#### A. Tmux + Neovim Harmony
```bash
# From bvi.nvim keymaps - tmux-aware navigation
vim.keymap.set('n', '<A-h>', '<C-w>h')  -- Navigate vim splits
vim.keymap.set('n', '<A-j>', '<C-w>j')  -- Also works in tmux panes
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')
```

#### B. Buffer Management
```lua
-- Sacred lattice: leader + 1-9 → jump to buffer 1-9
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        -- Smart buffer jumping with tmux integration
        jump_to_buffer_or_window(i)
    end)
end
```

#### C. AI Pipeline Integration
```lua
-- Visual selection → AI → Result in split
vim.keymap.set('v', '<leader>gp', function()
    local selection = get_visual_selection()
    local result = run_ai_pipeline(selection, "explain")
    open_result_in_split(result)
end)
```

### Benefits for FreeBSD
- **Unified Keymap**: Same keys work in vim splits and tmux panes
- **Buffer Navigation**: Direct access to buffers 1-9
- **AI Workflows**: Visual selection to AI results
- **Split Management**: Results appear in logical locations

## Implementation Roadmap

### Phase 1: Core Infrastructure (This Week)
1. ✅ **Socket Daemon** - Implement reliable IPC
2. 🔄 **Tool Routing** - Add ripgrep/web search fallbacks
3. 🔄 **Error Handling** - Fix current crash issues

### Phase 2: Editor Integration (Next Week)
4. 🔄 **Neovim Plugin** - Socket client for editor commands
5. 🔄 **Visual AI** - Selection-to-AI workflows
6. 🔄 **Context Awareness** - Send relevant code/file context

### Phase 3: Workflow Polish (Following Weeks)
7. 🔄 **Tmux Harmony** - Unified navigation keymaps
8. 🔄 **Buffer Management** - Sacred lattice implementation
9. 🔄 **Pipeline Integration** - Multi-step AI workflows

## Key Architectural Insights

### 1. **Simplicity over Complexity**
- Debian v1: 4 tools, simple routing → reliable
- FreeBSD v6: 16+ backends, complex routing → crashes
- **Lesson**: Start simple, add complexity gradually

### 2. **IPC over Stdout/Stderr**
- Socket-based communication prevents crashes
- Background daemon enables persistent state
- Client/server model scales better

### 3. **Editor as Primary Interface**
- Users live in editors, not terminals
- AI should enhance editing workflow
- Visual selections provide better context

### 4. **Modular Tool Integration**
- Route to specialized tools (grep, DB, web)
- Fall back to AI for general queries
- Each tool has specific strengths

## Migration Strategy

### Immediate (Fix Current Issues)
1. Implement socket daemon to prevent crashes
2. Add tool routing as reliable fallback
3. Fix API response parsing issues

### Short-term (Add Capabilities)
1. Create basic Neovim socket client
2. Add visual selection AI commands
3. Implement tmux-aware keymaps

### Long-term (Full Integration)
1. Complete bvi.nvim-style editor integration
2. Add PostgreSQL/SeaweedFS persistence
3. Implement multi-step AI pipelines

## Success Criteria

- **No more crashes** on API responses
- **Seamless editor integration** for AI workflows
- **Reliable tool routing** with fallbacks
- **Unified keymaps** across tmux/vim boundaries
- **Context-aware AI** using code/file context

This salvaged architecture provides a **proven path** from the current crash-prone system to a robust, editor-integrated AI assistant.</content>
<filePath>baux-bot-evolution-roadmap.md