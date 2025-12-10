# BAUX Bot API Setup Guide

## Overview
BAUX Bot supports **16+ AI backends** for different types of queries:

### Always Available (No Setup Required)
- **Ollama**: Local AI for RAG building and general assistance
- **Grok**: xAI for coding and BAUX-specific development
- **Gemini**: Google AI for research and general questions
- **Claude**: Anthropic for complex reasoning and careful implementation
- **Replicate**: Free creative AI models
- **Together AI**: Fast research inference
- **HuggingFace**: Free creative text generation
- **ASCII Art**: Fun motivational text art
- **Cheerleader**: Coding motivation and encouragement

### Available With Tool Installation
- **Aider**: AI pair programming (`pip install aider-chat`)
- **Mods**: Terminal AI (`go install github.com/charmbracelet/mods@latest`)
- **Fabric**: AI workflow framework (`pip install fabric-ai`)
- **ShellGPT**: Command line GPT (`pip install shell-gpt`)
- **Claude Code**: Advanced coding agent (subscription required)
- **GitHub Copilot CLI**: Code completion (subscription required)
- **OpenCode**: Open-source AI (`curl -fsSL https://opencode.ai/install | bash`)
- **Keystroke Guru**: Interactive learning mode

## Current Setup

### ✅ Fully Implemented & Working
- **Ollama**: Local models (always available)
- **Grok**: xAI API (key required via drop-baux)
- **Gemini**: Google AI (key required via drop-baux)
- **Claude**: Anthropic API (key required via drop-baux)
- **Replicate**: Free models (key required via drop-baux)
- **Together AI**: Fast inference (key required via drop-baux)
- **HuggingFace**: Free inference (no key required)
- **ASCII Art**: Built-in fun feature
- **Cheerleader**: Built-in motivation feature

### 🔧 Tool-Based (Install Required)
- **Aider**: `pip install aider-chat`
- **Mods**: `go install github.com/charmbracelet/mods@latest`
- **Fabric**: `pip install fabric-ai`
- **ShellGPT**: `pip install shell-gpt`
- **Claude Code**: Subscription required
- **GitHub Copilot CLI**: Subscription required
- **OpenCode**: `curl -fsSL https://opencode.ai/install | bash`
- **Keystroke Guru**: Built-in learning mode

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

### 🎉 FUN & GAMIFICATION - Free Built-in Features
- **ASCII Art**: Inspirational text art generation (`pkg install figlet`)
- **Cheerleader**: Motivational coding encouragement and achievements
- **Keystroke Guru**: Interactive BAUX keymap learning and gamification
- **HuggingFace**: Free creative AI models via inference API

### 🔑 API KEYS - Free but Require Account
- **Grok**: Already configured via xAI
- **Gemini**: Google AI Studio API key (starts with "AIza", ~40 characters)
  - Go to: https://makersuite.google.com/app/apikey
  - Create new API key
  - Copy the full key (not project ID)
  - ⚠️ **Very limited free quota** - hits limits quickly, falls back to Ollama
- **Claude**: Anthropic API (pay per use, generous free tier for new users)
  - Go to: https://console.anthropic.com/
  - Sign up for free account
  - Get API key from dashboard
  - Free tier: 5 requests/minute, good for development

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

### Replicate Setup
1. Go to [Replicate](https://replicate.com/)
2. Sign up for free account
3. Get API token from account settings
4. Add to `~/mnt/drop-baux/keys/api_keys.sh`:
```bash
export REPLICATE_API_TOKEN="your-token-here"
```

### Together AI Setup
1. Go to [Together AI](https://together.ai/)
2. Sign up for free account
3. Get API key from dashboard
4. Add to `~/mnt/drop-baux/keys/api_keys.sh`:
```bash
export TOGETHER_API_KEY="your-api-key-here"
```

## Implementation Notes

### Routing Logic - Network Chuck Ultimate AI Stack
BAUX Bot automatically routes queries based on content analysis and available tools:
- **Research/General**: → Fabric → Together AI → Gemini
- **Creative/Art**: → Replicate → HuggingFace
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