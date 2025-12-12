#!/bin/bash
# grok-api.sh - Direct GROK API interface for Roxanne

# Read from stdin or command line
if [[ -p /dev/stdin ]]; then
    PAYLOAD=$(cat)
else
    PAYLOAD="$1"
fi

# Try to parse as JSON first
QUESTION=$(echo "$PAYLOAD" | jq -r '.question // empty' 2>/dev/null || echo "")
CONTEXT=$(echo "$PAYLOAD" | jq -r '.context // empty' 2>/dev/null || echo "")

# If JSON parsing failed, treat as plain text question
if [[ -z "$QUESTION" ]]; then
    QUESTION="$PAYLOAD"
    CONTEXT=""
fi

# Use GROK_API_KEY from environment
API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

if [[ -z "$API_KEY" ]]; then
    echo "Error: No GROK API key found. Set GROK_API_KEY or GROK_KEY environment variable."
    exit 1
fi

# Build the user message with context
if [[ -n "$CONTEXT" ]]; then
    USER_CONTENT="Context: ${CONTEXT:0:1000}

Question: $QUESTION"
else
    USER_CONTENT="$QUESTION"
fi

# Create JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
  "model": "grok-2-1212",
  "messages": [
    {
      "role": "system",
      "content": "You are Grok helping build Roxanne Cyberdeck OS. Be direct, technical, and helpful. Focus on FreeBSD, tmux, AI integration, and cyberdeck development."
    },
    {
      "role": "user",
      "content": "$USER_CONTENT"
    }
  ],
  "temperature": 0.3,
  "max_tokens": 1000
}
EOF
)

# Make the API call
curl -s https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD" | jq -r '.choices[0].message.content // "API Error: No response"' 2>/dev/null || echo "API Error: Request failed"
