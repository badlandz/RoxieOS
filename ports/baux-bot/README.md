# baux-bot - BAUX AI Assistant

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
- **Development focused**: Specialized prompts for BAUX/FreeBSD development

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

- **RAG System**: Builds context from git status + 50 most recent source files
- **Model Selection**: Automatically chooses best available model
- **Memory**: Logs all conversations for continuity
- **Integration**: Designed for tmux-based BAUX workflow
