# BAUX Bot API Setup Guide

## Overview
BAUX Bot supports multiple AI backends for different types of queries:
- **Ollama**: Local AI for RAG building and general assistance
- **Grok**: xAI for coding and BAUX-specific development
- **Gemini**: Google AI for research and general questions
- **Claude**: Anthropic for complex reasoning and careful implementation

## Current Setup

### ✅ Configured Backends
- **Ollama**: Local installation required
- **Grok**: API key configured via `~/mnt/drop-baux/keys/api_keys.sh`

### 🔄 Placeholder Backends (Need API Setup)
- **Gemini**: Google AI Studio API
- **Claude**: Anthropic API

### 🆓 FREE TOOLS - No Registration Required
- **Ollama**: Local AI models (already configured)
- **Aider**: AI pair programming (`pip install aider-chat`)
- **Mods**: Terminal AI (`go install github.com/charmbracelet/mods@latest`)
- **Fabric**: AI workflow framework (`pip install fabric-ai`)
- **ShellGPT**: Command line GPT with local models (`pip install shell-gpt`)
- **OpenCode**: Open-source AI (`curl -fsSL https://opencode.ai/install | bash`)

### 💰 PAID TOOLS - Require Subscription
- **Claude Code**: $20/mo Claude Pro (`curl -fsSL https://claude.ai/install.sh | bash`)
- **GitHub Copilot CLI**: $10/mo Copilot Individual (`npm install -g @github/copilot`)

### 🔑 API KEYS - Free but Require Account
- **Grok**: Already configured via xAI
- **Gemini**: Google AI Studio (free tier available)
- **Claude**: Anthropic API (pay per use)

## API Setup Instructions

### Google Gemini Setup
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Add to `~/mnt/drop-baux/keys/api_keys.sh`:
```bash
export GEMINI_API_KEY="your-api-key-here"
```

### Anthropic Claude Setup
1. Go to [Anthropic Console](https://console.anthropic.com/)
2. Create a new API key
3. Add to `~/mnt/drop-baux/keys/api_keys.sh`:
```bash
export CLAUDE_API_KEY="your-api-key-here"
```

## Implementation Notes

### Routing Logic - Network Chuck Ultimate AI Stack
BAUX Bot automatically routes queries based on content analysis and available tools:
- **Research/General**: → Fabric → Gemini
- **BAUX-Specific Coding**: → Aider → Claude Code → Grok (safety checks)
- **Complex Coding**: → Claude Code → Copilot CLI → Aider
- **General Coding**: → Aider → Mods → Copilot CLI → Claude
- **Quick Queries**: → ShellGPT → Mods → OpenCode → Grok
- **Destructive Operations**: → Claude (requires git safety)

**Network Chuck's Multi-AI Sync**: BAUX Bot maintains context across all tools, allowing seamless switching between different AIs working on the same project folder.

## 🚀 QUICK START - Free Tools Only

Install the free tools that work immediately:

```bash
# On any BAUX system (baux01, .133, etc.)

# Aider - AI pair programming
pip install aider-chat

# Mods - Terminal AI
go install github.com/charmbracelet/mods@latest

# Fabric - AI workflows
pip install fabric-ai

# ShellGPT - with local Ollama models
pip install shell-gpt

# OpenCode - Open-source AI
curl -fsSL https://opencode.ai/install | bash

# Test BAUX Bot with new tools
baux-bot
> How do I implement a new BAUX command?
# Should route to Aider for coding assistance
```

**Result**: BAUX Bot becomes significantly more powerful with 6 additional free AI tools!

### Safety Features
- Destructive operations require git-related keywords
- BAUX-specific queries get priority routing to Grok
- Fallback to current backend if routing fails

### Future Enhancements
- Multi-RAG context assembly
- Query complexity analysis
- Response quality validation
- Cost optimization across backends

## Testing
Once APIs are configured, test with:
```bash
baux-bot
> switch gemini
> What is the history of Unix?
> switch claude
> How should I implement a thread-safe queue in C?
```</content>
<parameter name="filePath">/src/RoxieOS/ports/baux-bot/API-SETUP.md