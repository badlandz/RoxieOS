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

### Routing Logic
BAUX Bot automatically routes queries based on content analysis:
- **Research/General**: → Gemini
- **BAUX Coding**: → Grok (with safety checks)
- **Complex Reasoning**: → Claude
- **Destructive Operations**: → Claude (requires git safety)

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