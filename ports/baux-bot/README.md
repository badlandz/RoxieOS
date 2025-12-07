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
- **Real-time monitoring**: Automatically rebuilds knowledge base when repo changes
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

## Architecture

- **RAG System**: Builds context from git status + 50 most recent source files
- **Model Selection**: Automatically chooses best available model
- **Memory**: Logs all conversations for continuity
- **Integration**: Designed for tmux-based BAUXBSD workflow